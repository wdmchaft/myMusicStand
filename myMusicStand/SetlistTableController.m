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

@implementation SetlistTableController

- (id)init
{
    @throw @"Illegal instantiation! please use: initWithManagedObjectContext:";
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc
{
    self = [super initWithManagedObjectContext:moc];
    if (self) {
        // Custom initialization
        
    }
    return self;

}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Helper methods

- (int)numberOfBlocks 
{
    return [model count] + NUM_ADD_BLOCKS;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self blockCellForTableView:tv];
    
    // Setlist to display
    Setlist *setlist;
    // Label to display alias of File
    UILabel *label;
    UIView *block;
    
    // Loop through all possible blocks for the cell and attempt to set their values
    int tagOffset = FIRST_LABEL_TAG; // starting label tag offset 
    int blocTagOffset = FIRST_BLOCK_TAG; // starting block tag offset
    
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
            
            continue;
        }
        
        setlist = [model objectAtIndex:index];
        
        [label setText:[setlist title]];
        
                
        tagOffset++;
        blocTagOffset++;
    }
    
    return cell;
}

#pragma mark Gesture Response methods
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

@end

