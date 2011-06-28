//
//  SetlistTableViewController.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetlistTableController.h"
#import "myMusicStandAppDelegate.h"
#import "Setlist.h"

#define NUM_BLOCKS_PER_CELL 3
#define NUM_ADD_BLOCKS 1
#define FIRST_BLOCK_TAG 4
#define FIRST_LABEL_TAG 0
#define FIRST_CHECK_TAG 7

@interface SetlistTableController (PrivateMethods)

- (void)handleTap:(UITapGestureRecognizer *)recognizer;

@end

@implementation SetlistTableController

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc andTableView:(UITableView *)tv
{
    self = [super initWithManagedObjectContext:moc andTableView:tv];
    
    if (self) 
    {
        // setup model with Setlists
        [self setModel:[context allEntity:@"Setlist"]];
        // Register to receive SaveNotifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadFiles:)
                                                     name:NSManagedObjectContextDidSaveNotification 
                                                   object:nil];
        
        blocksToSetlistId = [[NSMutableDictionary alloc] init];
    }
    return self;

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [blocksToSetlistId release];
    [super dealloc];
}
#pragma mark - Helper methods

- (int)numberOfBlocks 
{
    return [super numberOfBlocks] + NUM_ADD_BLOCKS;
}

// Add the filename to the selectedModels array
- (void)toggleBlockSelection:(UITapGestureRecognizer *)recognizer
{  
    // Get block from recognizer
    UIView *block = [recognizer view];
    
    // Get the title from dict
    id managedObject = [blocksToSetlistId objectForKey:[NSValue valueWithPointer:block]];
    
    // If filename it is already in selectedModels
    if ([selectedModels containsObject:managedObject])
    {
        // remove it
        [selectedModels removeObject:managedObject];
    }
    else // select not yet selected filename block
    {
        // add to selectedModels
        [selectedModels addObject:managedObject];
    }    
}

#pragma mark - Table view data source
- (void)reloadFiles:(NSNotification *)notification
{
    [self setModel:[context allEntity:@"Setlist"]];
    [tableView reloadData];
}

#pragma mark Gesture Response methods
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        if (!isSelectingBlocks)
        {
            // TODO: add setlist viewing
        }
        else
        {
            [self toggleBlockSelection:recognizer];
            [[self tableView] reloadData];
        }
    }

}

- (void)createSetlist:(UITapGestureRecognizer *)recognizer
{
    // Once tapped create an empty setlist and reload the table
    if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        
        // Create new setlist
        Setlist *setlist = [Setlist setlistWithContext:context];
        
        // Set attributes for setlist
        [setlist setTitle:@"Unnamed Set"];
         
        [context save:nil];
    }
}

#pragma mark - Helper methods
- (void)configureCell:(UITableViewCell *)cell 
         forIndexPath:(NSIndexPath *)indexPath    
{
    // Setlist to display
    Setlist *setlist;
    // Label to display alias of File
    UILabel *label;
    UIView *block;
    UIImageView *check; // check image
    
    // Loop through all possible blocks for the cell and attempt to set their values
    int tagOffset = FIRST_LABEL_TAG; // starting label tag offset 
    int blocTagOffset = FIRST_BLOCK_TAG; // starting block tag offset
    int checkTagOffset = FIRST_CHECK_TAG; // starting check offset
    
    for (int index = NUM_BLOCKS_PER_CELL * [indexPath row]; // BLOCKS * row gives us the first index we can use
         index < [model count] + 1 && tagOffset < NUM_BLOCKS_PER_CELL; index++)
    {
        // get label for tag
        label = (UILabel *)[cell viewWithTag:tagOffset + 1];
        // Set font color 
        [label setTextColor:[UIColor whiteColor]];
        
        // get block for tag
        block = [cell viewWithTag:blocTagOffset];
        // hide the spinner in the block
        [(UIActivityIndicatorView *)[[block subviews] objectAtIndex:0] stopAnimating];
        
        // make block not hidden
        [block setHidden:NO];
        
        // If we are at the add button index
        if (index == [model count])
        {
            // set add set button
            [label setText:@"Add setlist"];
            
            UITapGestureRecognizer *tap = 
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(createSetlist:)];
            [block addGestureRecognizer:tap];
            
            [block setAccessibilityLabel:@"Add Setlist block"];
            
            [tap release];
            
            // remove this block from mapping so it can't be used 
            [blocksToSetlistId removeObjectForKey:[NSValue valueWithPointer:block]];
            
            continue; // skip rest of code
        }
        
        // normal block configuration
        
        
        setlist = [model objectAtIndex:index];
        
        // Show check if setlist is in selectedModels
        if ([selectedModels containsObject:setlist])
        {
            // show check
            check = (UIImageView *)[cell viewWithTag:checkTagOffset];
            [check setHidden:NO];
        }
        
        // add tap recognizer to block
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                              action:@selector(handleTap:)];
        [block addGestureRecognizer:tap];
        
        [tap release];
        
        // Add block mapping from block to setlist title
        [blocksToSetlistId setObject:setlist forKey:[NSValue valueWithPointer:block]];
        
        // Show title of setlist
        [label setText:[setlist title]];
        
        
        tagOffset++;
        blocTagOffset++;
        checkTagOffset++;
        
    }
    
}

- (void)deleteFilesForSelectedModels
{    
    // File objects to delete
    NSMutableArray *modelsToDelete = [[NSMutableArray alloc] init];
    
    // Delete the selectedModels
    for (id object in selectedModels)
    {
        // delete that file (in docs and context)
        [context deleteObject:object];
    }
    
    // Save all changes
    [context save:nil];
    
    // Clean up
    [modelsToDelete release];
}

@end

