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
#define FIRST_BLOCK_TAG 4
#define FIRST_LABEL_TAG 1
#define FIRST_CHECK_TAG 7

@interface BlockTableController (privateMethods)
// private methods
- (void)configureCell:(UITableViewCell *)cell 
         forIndexPath:(NSIndexPath *)indexPath;
@end

@implementation BlockTableController

@synthesize navigationController;
@synthesize tableView;
@synthesize model;
@synthesize isSelectingBlocks;

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
        isSelectingBlocks = NO; // By default selection of blocks is disabled 
        selectedModels = [[NSMutableArray alloc] init];
        blocksToModel = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [blocksToModel release];
    [selectedModels release];
    [model release];
    [context release];
    [super dealloc];
}

#pragma mark - Setter methods

// Since we are no longer able to select blocks 
// clear out selectedModels
- (void)setIsSelectingBlocks:(BOOL)newIsSelectingBlocks
{
    // clear out models
    [selectedModels removeAllObjects];
    isSelectingBlocks = newIsSelectingBlocks;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return 270;
}

#pragma mark - helper methods
- (void)configureCell:(UITableViewCell *)cell 
         forIndexPath:(NSIndexPath *)indexPath    
{
    // Parts of cell that are related to a block
    UILabel *label;
    UIView *block;
    UIImageView *checkMark; 
    
    // Loop through all possible blocks for the cell and attempt to set their values
    int labelTagOffset = FIRST_LABEL_TAG; 
    int blocTagOffset = FIRST_BLOCK_TAG; 
    int checkTagOffset = FIRST_CHECK_TAG; 
    
    for (int index = NUM_BLOCKS_PER_CELL * [indexPath row]; // BLOCKS * row gives us the first index in model we can use
         index < [self numberOfBlocks] && labelTagOffset <= NUM_BLOCKS_PER_CELL; index++)
    {
        // Get label for tag
        label = (UILabel *)[cell viewWithTag:labelTagOffset];
        // Get block for tag
        block = [cell viewWithTag:blocTagOffset];
        checkMark = (UIImageView *)[cell viewWithTag:checkTagOffset];
        
        // Make block visible
        [block setHidden:NO];
        
        [self customConfigurationForBlock:block label:label checkMark:checkMark atIndex:index];
        
        labelTagOffset++;
        blocTagOffset++;
        checkTagOffset++;
        
    }
}

- (void)customConfigurationForBlock:(UIView *)block 
                              label:(UILabel *)label 
                          checkMark:(UIImageView *)check 
                            atIndex:(int)index
{
    // No-op method allows for block customization by subclasses
}

// Delete all selectedModels and allow for subclass to customize 
// predelete steps
// NOTE: this method isn't under test
- (void)deleteSelectedModels
{
    // Delete the selectedModels
    for (id aModel in selectedModels)
    {
        [self customStepForDeletionOfModel:aModel];
        
        // delete that file (in docs and context)
        [context deleteObject:aModel];
    }
    
    // Save all changes
    [context save:nil];
}

- (void)customStepForDeletionOfModel:(NSManagedObject *)aModel
{
    // do nothing
}

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

// Add the model to the selectedModels array
- (void)toggleBlockSelection:(UITapGestureRecognizer *)recognizer
{  
    // Get block from recognizer
    UIView *block = [recognizer view];
    
    // Get the title from dict
    id aModel = [blocksToModel objectForKey:[NSValue valueWithPointer:block]];
    
    // If filename it is already in selectedModels
    if ([selectedModels containsObject:aModel])
    {
        // remove it
        [selectedModels removeObject:aModel];
    }
    else // select not yet selected filename block
    {
        // add to selectedModels
        [selectedModels addObject:aModel];
    }    
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
