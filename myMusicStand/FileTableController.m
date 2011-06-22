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

@implementation FileTableController

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc andTableView:(UITableView *)tv
{
    self = [super initWithManagedObjectContext:moc andTableView:tv];
    
    if (self)
    {
        // Creat our map
        blocksToFilenames = [[NSMutableDictionary alloc] init];
        
        // Register for ReloadTableNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadFiles:) 
                                                     name:@"ReloadTableNotification" 
                                                   object:nil];
        
        [self setModel:[context allEntity:@"File"]];
    }
    
    return self;
}

- (void)dealloc
{
    [tableView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [blocksToFilenames release];
    [super dealloc];
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
    
    // Loop through all possible blocks for the cell and attempt to set their values
    int labelTagOffset = FIRST_LABEL_TAG; // starting offset 
    int blockTagOffset = FIRST_BLOCK_TAG;
    
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
        gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPDF:)];
        [block addGestureRecognizer:gr];
        [gr release];
        
        // Set accessiblity labels
        [block setAccessibilityLabel:[[file filename] stringByAppendingString:@" block"]];
        
        // Add mapping of block to filename, this will allow us to have the name of the 
        // file we want to open once the block is clicked
        [blocksToFilenames setObject:[file filename] forKey:[NSValue valueWithPointer:block]];
        
        labelTagOffset++;
        blockTagOffset++;
    }

}

#pragma mark - Table view data source

- (void)reloadFiles:(NSNotification *)notification
{
    [self setModel:[context allEntity:@"File"]];
    [tableView reloadData];
}

- (void)openPDF:(UITapGestureRecognizer *)recognizer
{
    myMusicStandAppDelegate *delegate = [myMusicStandAppDelegate sharedInstance];

    // Get block from recognizer
    UIView *block = [recognizer view];
    NSURL *docsDir = [delegate applicationDocumentsDirectory];
    
    // Get the filename from dict
    NSString *filename = [blocksToFilenames objectForKey:
                                        [NSValue valueWithPointer:block]];
    
    // Create the url for the PDF
    NSURL *url = [docsDir URLByAppendingPathComponent:filename];

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

