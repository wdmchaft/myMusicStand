//
//  SetlistTableViewController.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetlistTableViewController.h"
#import "Setlist.h"

#define NUM_BLOCKS_PER_CELL 3
#define NUM_ADD_BLOCKS 1

@implementation SetlistTableViewController

@synthesize setlists;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int index = [setlists count];
    
    // Calculate if there is a remainder
    int remainder = index % NUM_BLOCKS_PER_CELL;
    
    // if we have a remainder 
    if (remainder != 0)
    {
        // add one extra 
        return index / NUM_BLOCKS_PER_CELL + 1 + NUM_ADD_BLOCKS;
    }
    // else we don't need an extra row
    return index / NUM_BLOCKS_PER_CELL + NUM_ADD_BLOCKS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Setlist to display
    Setlist *setlist;
    // Label to display alias of File
    UILabel *label;
    
    // Loop through all possible blocks for the cell and attempt to set their values
    int tagOffset = 0; // starting offset 
    for (int index = NUM_BLOCKS_PER_CELL * [indexPath row]; // BLOCKS * row gives us the first index we can use
         index < [setlists count] && tagOffset < NUM_BLOCKS_PER_CELL; index++)
    {
        
        setlist = [setlists objectAtIndex:index];
        label = (UILabel *)[cell viewWithTag:tagOffset + 1];
        [label setText:[setlist title]];
        
        // Set font color 
        [label setTextColor:[UIColor whiteColor]];
        
        tagOffset++;
    }
    
    return cell;
}

@end

