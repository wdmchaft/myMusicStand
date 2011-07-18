//
//  FilesListTableViewController.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileTableController.h"
#import "PDFDocumentViewController.h"
#import "myMusicStandAppDelegate.h"
#import "StageViewController.h"
#import "File.h"
#import "Thumbnail.h"

#define MAXIMUM_EMAIL_ATTACHMENT_SIZE 20 * 1024 * 1024 // 20 MB in terms of bytes

@interface FileTableController (PrivateMethods)

- (void)openPDF:(UITapGestureRecognizer *)recognizer;
- (NSURL *)URLForFileName:(NSString *)filename;

@end

@implementation FileTableController
{
    // the sum of all the selected Models file sizes
    NSNumber *totalSelectedFileSize;
    StageViewController *__weak delegate;
    
}

@synthesize delegate;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc andTableView:(UITableView *)tv
{
    self = [super initWithManagedObjectContext:moc andTableView:tv];
    
    if (self)
    {
        // Register for SaveNotification from the mainContext
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadFiles:) 
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:moc];
        
        [self setModel:[context allEntity:@"File"]];
        
        totalSelectedFileSize = [NSNumber numberWithInt:0];
    }
    
    return self;
}


#pragma mark - Helper methods
- (void)customStepForDeletionOfModel:(NSManagedObject *)aModel
{
    File *file = (File *)aModel;
    
    // Used to delete file in documents dir
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    // Remove file from disk
    NSURL *url = [self URLForFileName:[file filename]];
    [fm removeItemAtURL:url error:&error];
}

- (void)customConfigurationForBlock:(UIView *)block label:(UILabel *)label checkMark:(UIImageView *)check atIndex:(int)index
{
    File *file = [model objectAtIndex:index];
    
    [label setText:[file alias]];
    
    // Set accessiblity labels
    [block setAccessibilityLabel:[[file alias] stringByAppendingString:@" block"]];
    

    // Add mapping of block to filename, this will allow us to have the name of the 
    // file we want to open once the block is clicked
    [blocksToModel setObject:file forKey:[NSValue valueWithNonretainedObject:block]];
    
    // Show check if file is in selectedModels
    if ([selectedModels containsObject:file])
    {
        // show check
        [check setHidden:NO];
    }
    
    // Determine if we can display a thumbnail
    Thumbnail *thumbnail = [file thumbnail];
    if (thumbnail != nil)
    {
        // Load image for thumbnail
        UIImage *image = [[UIImage alloc] initWithData:[thumbnail data]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

        // display image within block's bounds
        [imageView setFrame:[block bounds]];
        
        // show thumbnail in block
        [block addSubview:imageView];

    }
    
    // add tap recognizer to block
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                          action:@selector(handleTap:)];
    [block addGestureRecognizer:tap];

}

// when a model was added to the selectedModels we add in it's fileSize
- (void)customStepforAddingSelectedModel:(NSManagedObject *)aModel
{
    long newTotal = [totalSelectedFileSize longValue] + [[(TimestampEntity *)aModel size] longValue];
    totalSelectedFileSize = [NSNumber numberWithLong:newTotal]; 
    
    // determine if we should disable the email action button
    if (newTotal >= MAXIMUM_EMAIL_ATTACHMENT_SIZE)
    {
        [delegate setEmailButtonEnabled:NO];
    }
}

- (void)customStepforRemovingSelectedModel:(NSManagedObject *)aModel
{
    long newTotal = [totalSelectedFileSize longValue] - [[(TimestampEntity *)aModel size] longValue];
    totalSelectedFileSize = [NSNumber numberWithLong:newTotal];
    
    // determine if we should enable the email action button
    if (newTotal < MAXIMUM_EMAIL_ATTACHMENT_SIZE)
    {
        [delegate setEmailButtonEnabled:YES];
    }
}

// Returns a url in the docs directory with the filename provided
- (NSURL *)URLForFileName:(NSString *)filename
{
    myMusicStandAppDelegate *appDelegate = [myMusicStandAppDelegate sharedInstance];

    NSURL *docsDir = [appDelegate applicationDocumentsDirectory];
    // Create the url for the PDF
    NSURL *url = [docsDir URLByAppendingPathComponent:filename];
    
    return url;
}

#pragma mark - Table view data source

- (void)reloadFiles:(NSNotification *)notification
{
    [self setModel:[context allEntity:@"File"]];
    [tableView reloadData];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        if (!isSelectingBlocks)
        {
            [self openPDF:recognizer];
        }
        else
        {
            [self toggleBlockSelection:recognizer];
            [[self tableView] reloadData];
        }
    }
}

- (void)openPDF:(UITapGestureRecognizer *)recognizer
{
    myMusicStandAppDelegate *appDelegate = [myMusicStandAppDelegate sharedInstance];
    // Get block from recognizer
    UIView *block = [recognizer view];
    
    // Get the filename from dict
    File *file = [blocksToModel objectForKey:[NSValue valueWithNonretainedObject:block]];
    
    NSString *filename = [file filename];
    
    NSURL *url = [self URLForFileName:filename];

    // Load controller for document
    PDFDocumentViewController *pdfDocumentController = 
        [[PDFDocumentViewController alloc] initWithNibName:@"PDFDocumentViewController"
                                                    bundle:nil 
                                                       URL:url];

    // Allow pdfDocument to tie into delegate to send emails
    [pdfDocumentController setDelegate:delegate];
    
    // Hide the navbar
    UIView *bottomOfStand = [appDelegate bottomOfStand];
    [bottomOfStand setHidden:YES];
    
    // show the PDFViewer
    [[self navigationController] pushViewController:pdfDocumentController animated:NO];
}

// Handle long press on alias label in a cell
-(void)editAlias:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        UILabel *label = (UILabel *)[recognizer view];
        
        // Create field with the same frame as the view
        UITextField *text = [[UITextField alloc] initWithFrame:[label frame]];
        
        // make text color same as view color
        [text setTextColor:[(UILabel*)label textColor]];
        // make text same as view text
        [text setText:[(UILabel *)label text]];
        // clear the label 
        [label setText:@""];
        
        // add the field to the superview of the recognizer's view
        [[label superview] addSubview:text];
        
        // set us as delegate
        [text setDelegate:self];
        
        // make text first responder
        [text becomeFirstResponder];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)field
{
    // get the center of the field
    CGPoint center = [field center];
    // get superview
    UIView *cell = [field superview];
    
    // resign first responder 
    [field resignFirstResponder];
    
    // remove the field from the cell
     // hold onto the field for alittle while
    [field removeFromSuperview];
    
    // hit test the cell for the lable at center
    UILabel *label = (UILabel *)[cell hitTest:center withEvent:nil];
    

    [label setText:[field text]];
    
    // TODO: set the model to reflect the change
    
}

@end

