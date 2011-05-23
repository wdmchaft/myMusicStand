//
//  BlockTableViewController.m
//  
//
//  Created by Steve Solomon on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BlockTableViewController.h"


@implementation BlockTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the background view
    UITableView *tv = [self tableView];
    [tv setBackgroundColor:[UIColor clearColor]];
    // Set separator style
    [tv setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // Set tableview to not allow selection
    [tv setAllowsSelection:NO];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return 270;
}

#pragma mark - helper methods

// Helper method to generate a block cell for the tableView
- (UITableViewCell *)blockCellForTableView:(UITableView *)tableView  
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    }
}

@end
