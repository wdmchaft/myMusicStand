//
//  BlockTableViewController.m
//  
//
//  Created by Steve Solomon on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BlockTableController.h"
#import "myMusicStandAppDelegate.h"

#define NUM_BLOCKS_PER_CELL 3

@interface BlockTableController (privateMethods)
// private methods
- (void)configureCell:(UITableViewCell *)cell 
         forIndexPath:(NSIndexPath *)indexPath;
@end

@implementation BlockTableController

@synthesize navigationController;
@synthesize tableView;
@synthesize model;

#pragma mark - Life cycle

- (id)init
{
    @throw @"Illegal instantiation! please use: initWithManagedObjectContext:";
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc andTableView:(UITableView *)tv
{
    self = [super init];
    if (self) {
        context = [moc retain];
        model = [[NSArray alloc] init];
        tableView = [tv retain];
        [tableView setDataSource:self];
        [tableView setDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [model release];
    [context release];
    [super dealloc];
}

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

- (void)configureCell:(UITableViewCell *)cell 
         forIndexPath:(NSIndexPath *)indexPath
{
     @throw @"Subclass responsibility";
}


- (void) setUpModelWithContext:(NSManagedObjectContext *)context
{
    @throw @"Subclass responsibility";
}



// Number of blocks to display in the table
- (int)numberOfBlocks 
{
    return [model count];
}

#pragma mark TableView DataSource Methods

// Determine the number of rows based on the number of blocks in the table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfBlocks = [self numberOfBlocks];
    
    // Calculate if there is a remainder
    int remainder = numberOfBlocks % NUM_BLOCKS_PER_CELL;
    
    // if we have a remainder 
    if (remainder != 0)
    {
        // add one extra 
        return numberOfBlocks / NUM_BLOCKS_PER_CELL + 1;
    }
    // else we don't need an extra row
    return numberOfBlocks / NUM_BLOCKS_PER_CELL;
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self blockCellForTableView:tv];
    
    [self configureCell:cell forIndexPath:indexPath];

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
        
        // reset the accessibility label
        [subview setAccessibilityLabel:@""];
    }
}

@end
