//
//  FilesListTableViewController.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileTableController.h"
#import "PDFPagingViewController.h"
#import "myMusicStandAppDelegate.h"
#import "File.h"

#define NUM_BLOCKS_PER_CELL 3
#define FIRST_LABEL_TAG 0
#define FIRST_BLOCK_TAG 4
#define FIRST_CHECK_TAG 7

@interface FileTableController (PrivateMethods)

- (void)openPDF:(UITapGestureRecognizer *)recognizer;
- (NSURL *)URLForFileName:(NSString *)filename;

@end

@implementation FileTableController

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc andTableView:(UITableView *)tv
{
    self = [super initWithManagedObjectContext:moc andTableView:tv];
    
    if (self)
    {
        // Register for SaveNotification any context
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadFiles:) 
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];
        
        [self setModel:[context allEntity:@"File"]];
    }
    
    return self;
}

- (void)dealloc
{
    [tableView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark Modifiers
- (void)deleteFilesForSelectedModels
{    
    // File objects to delete
    NSMutableArray *filesToDelete = [[NSMutableArray alloc] init];
    
    // Figure out what files to delete
    for (File *file in model)
    {
        // if a selected model has the same file name
        if ([selectedModels containsObject:file])
        {
            [filesToDelete addObject:file];
        }
    }
    
    // Used to delete file in documents dir
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    // Delete the files 
    for (id file in filesToDelete)
    {
        // delete that file (in docs and context)
        [context deleteObject:file];
        
        NSURL *url = [self URLForFileName:[file filename]];
        [fm removeItemAtURL:url error:&error];
    }
    
    // Save all changes
    [context save:nil];
    
    // Clean up
    [filesToDelete release];
}

#pragma mark - Helper methods

- (void)configureCell:(UITableViewCell *)cell 
         forIndexPath:(NSIndexPath *)indexPath  
{
    // File to display
    File *file;
    // Label to display alias of File
    UILabel *label;
    UIView *block;
    UIImageView *check;
    
    // Loop through all possible blocks for the cell and attempt to set their values
    int labelTagOffset = FIRST_LABEL_TAG; // starting offset 
    int blockTagOffset = FIRST_BLOCK_TAG;
    int checkTagOffset = FIRST_CHECK_TAG;
    
    for (int index = NUM_BLOCKS_PER_CELL * [indexPath row]; // BLOCKS * row gives us the first index we can use
         index < [model count] && labelTagOffset < NUM_BLOCKS_PER_CELL; index++)
    {
        
        file = [model objectAtIndex:index];
        label = (UILabel *)[cell viewWithTag:labelTagOffset + 1];
        [label setText:[file alias]];
        block = [cell viewWithTag:blockTagOffset];
        
        // make block not hidden
        [block setHidden:NO];
                 
        // Set font color 
        [label setTextColor:[UIColor whiteColor]];
        
        // Add a gesture recognizer
        UIGestureRecognizer *gr = 
            [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(editAlias:)];
        [label addGestureRecognizer:gr];
        [gr release];
        
        // Add tap recognizer to block
        gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [block addGestureRecognizer:gr];
        [gr release];
        
        // Set accessiblity labels
        [block setAccessibilityLabel:[[file filename] stringByAppendingString:@" block"]];
        
        // Add mapping of block to filename, this will allow us to have the name of the 
        // file we want to open once the block is clicked
        [blocksToModel setObject:file forKey:[NSValue valueWithPointer:block]];
        
        // Show check if file is in selectedModels
        if ([selectedModels containsObject:file])
        {
            // show check
            check = (UIImageView *)[cell viewWithTag:checkTagOffset];
            [check setHidden:NO];
        }
        
        labelTagOffset++;
        blockTagOffset++;
        checkTagOffset++;
    }

}

// Returns a url in the docs directory with the filename provided
- (NSURL *)URLForFileName:(NSString *)filename
{
    myMusicStandAppDelegate *delegate = [myMusicStandAppDelegate sharedInstance];

    NSURL *docsDir = [delegate applicationDocumentsDirectory];
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
    myMusicStandAppDelegate *delegate = [myMusicStandAppDelegate sharedInstance];
    // Get block from recognizer
    UIView *block = [recognizer view];
    
    // Get the filename from dict
    File *file = [blocksToModel objectForKey:
                                        [NSValue valueWithPointer:block]];
    
    NSString *filename = [file filename];
    
    NSURL *url = [self URLForFileName:filename];

    // Instantiate PDFViewer
    PDFPagingViewController *pdfViewer = 
        [[PDFPagingViewController alloc] initWithPDFURLArray:[NSArray arrayWithObject:url]];
    
    // Hide the navbar
    UIView *bottomOfStand = [delegate bottomOfStand];
    [bottomOfStand setHidden:YES];
    
    // show the PDFViewer
    [[self navigationController] pushViewController:pdfViewer animated:NO];
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
    [[field retain] autorelease]; // hold onto the field for alittle while
    [field removeFromSuperview];
    
    // hit test the cell for the lable at center
    UILabel *label = (UILabel *)[cell hitTest:center withEvent:nil];
    

    [label setText:[field text]];
    
    // TODO: set the model to reflect the change
    
}

@end

