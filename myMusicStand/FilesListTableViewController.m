//
//  FilesListTableViewController.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilesListTableViewController.h"
#import "File.h"

#define NUM_BLOCKS_PER_CELL 3

@implementation FilesListTableViewController

@synthesize files;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        files = [[NSArray alloc] init];
        
    }
    return self;
}

- (void)dealloc
{
    [files release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int index = [files count];

    // Calculate if there is a remainder
    int remainder = index % NUM_BLOCKS_PER_CELL;
    
    // if we have a remainder 
    if (remainder != 0)
    {
        // add one extra 
        return index / NUM_BLOCKS_PER_CELL + 1;
    }
    // else we don't need an extra row
    return index / NUM_BLOCKS_PER_CELL;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    // File to display
    File *file;
    // Label to display alias of File
    UILabel *label;
    
    // Loop through all possible blocks for the cell and attempt to set their values
    int tagOffset = 0; // starting offset 
    for (int index = NUM_BLOCKS_PER_CELL * [indexPath row]; // BLOCKS * row gives us the first index we can use
         index < [files count] && tagOffset < NUM_BLOCKS_PER_CELL; index++)
    {
        
        file = [files objectAtIndex:index];
        label = (UILabel *)[cell viewWithTag:tagOffset + 1];
        [label setText:[file alias]];
        
        // Set font color 
        [label setTextColor:[UIColor whiteColor]];
        
        // Add a gesture recognizer
        UIGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(editAlias:)];
        [label addGestureRecognizer:gr];
        [gr release];
        
        tagOffset++;
    }
    
    return cell;
}

// Handle long press on alias label in a cell
-(void)editAlias:(UIGestureRecognizer *)recognizer
{
    UIView *view = [recognizer view];
    // Create field with the same frame as the view
    UITextField *text = [[UITextField alloc] initWithFrame:[view frame]];
    
    // hide the view
    [view setHidden:YES];
    
    // add the field to the superview of the recognizer's view
    [[view superview] addSubview:text];
}

@end

