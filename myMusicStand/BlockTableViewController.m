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
        
    }
}

@end
