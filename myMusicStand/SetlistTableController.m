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

#define NUM_ADD_BLOCKS 1

@interface SetlistTableController (PrivateMethods)

- (void)handleTap:(UITapGestureRecognizer *)recognizer;
- (void)customConfigurationForBlock:(UIView *)block label:(UILabel *)label 
                           checkMark:(UIImageView *)check 
                            atIndex:(int)index;

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
    }
    return self;

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
- (int)numberOfBlocks 
{
    return [super numberOfBlocks] + NUM_ADD_BLOCKS;
}


- (void)customConfigurationForBlock:(UIView *)block label:(UILabel *)label checkMark:(UIImageView *)check atIndex:(int)index
{
    // Action selector to be used for tapGestureRecognizer
    SEL tapSelector;
    
    // Configure add button in this block
    if (index == [model count])
    {
        // set add set button
        [label setText:@"Add setlist"];
        
        // set tap gesture handling action
        tapSelector = @selector(createSetlist:);
        
        [block setAccessibilityLabel:@"Add Setlist block"];
        
        // remove this block from mapping so it can't be used 
        [blocksToModel removeObjectForKey:[NSValue valueWithNonretainedObject:block]];
    }
    else 
    {
        // Display a setlist in block
        Setlist *setlist = [model objectAtIndex:index];
        
        // Show check if setlist is in selectedModels
        if ([selectedModels containsObject:setlist])
        {
            // show checkMark
            [check setHidden:NO];
        }
        
        // tap gesture handling selector
        tapSelector = @selector(handleTap:);
        
        // Show title of setlist
        [label setText:[setlist title]];
        [label setAccessibilityLabel:[setlist title]];
        
        // Add block mapping from block to setlist title
        [blocksToModel setObject:setlist forKey:[NSValue valueWithNonretainedObject:block]];
    }
    
    
    // add tap recognizer to block
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                          action:tapSelector];
    [block addGestureRecognizer:tap];
    
}

@end

