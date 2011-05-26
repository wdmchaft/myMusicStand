//
//  BlockTableViewController.m
//  
//
//  Created by Steve Solomon on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BlockTableController.h"
#import "myMusicStandAppDelegate.h"

@implementation BlockTableController

@synthesize navigationController;
@synthesize tableView;

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return 270;
}

#pragma mark - helper methods

// Helper method to generate a block cell for the tableView
- (UITableViewCell *)blockCellForTableView:(UITableView *)tv  
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Load the tableview cell
        [[NSBundle mainBundle] loadNibNamed:@"BlockTableViewCell"
                                      owner:self
                                    options:nil];
        // Set the cell
        cell = tvCell;
        // Clear pointer to cell
        tvCell = nil;
        
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section  
{
    @throw @"Subclass resposibility";
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @throw @"Subclass responsibility";
    
    return nil;
}

- (void) setUpModelWithContext:(NSManagedObjectContext *)context
{
    @throw @"Subclass responsibility";
}

- (void)reloadModel:(id)sender
{
    // Get delegate
    myMusicStandAppDelegate *delegate = [myMusicStandAppDelegate sharedInstance];
    
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    [self setUpModelWithContext:context];
    
    [tableView reloadData];
    
}
@end

// Override cell's perpareForReuse method to clear all labels
@implementation UITableViewCell (clearCellLabels)

-(void)prepareForReuse
{
    for (UIView *subview in [[self contentView] subviews])
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            [subview performSelector:@selector(setText:) withObject:@""];
        }
        else
        {
            // UIView class
            [subview setHidden:YES];
        }
        
        // remove any gesture recognizers on subviews
        for (UIGestureRecognizer *recognizer in [subview gestureRecognizers])
        {
            [subview removeGestureRecognizer:recognizer];
        }
        
        // reset the accessibility label
        [subview setAccessibilityLabel:@""];
    }
}

@end
