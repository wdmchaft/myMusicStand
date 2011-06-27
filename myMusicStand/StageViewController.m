//
//  StageViewController.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StageViewController.h"
#import "BlockTableController.h"
#import "FileTableController.h"
#import "SetlistTableController.h"
#import "myMusicStandAppDelegate.h"
#import "TimestampEntity.h"

#define FILES_CONTROLLER_INDEX 0
#define NAV_BAR_HEIGHT 44

@implementation StageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)dealloc
{
    [tabControl release];
    [actionItem release];
    [blockController release];
    [bottomOfStand release];
    [tableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    context = [[myMusicStandAppDelegate sharedInstance] managedObjectContext];
    
    // Do any additional setup after loading the view from its nib.
    
    blockController = [[FileTableController alloc] initWithManagedObjectContext:context andTableView:tableView];
    // Set navigationController
    [blockController setNavigationController:[self navigationController]];
    
    // Set visual aspects of tableview
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setAllowsSelection:NO];
    
    // Give the tableView a label of "Charts"
    [tableView setAccessibilityLabel:@"Charts"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [blockController release];
    blockController = nil;
    [bottomOfStand release];
    bottomOfStand = nil;
    [tableView release];
    tableView = nil;
    [tabControl release];
    tabControl = nil;
    [actionItem release];
    actionItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark Action Methods

- (IBAction)showActionItems:(UIBarButtonItem *)sender
{
    // Nav item is container for action item options
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    
    // Create bbi for navItem
    UIBarButtonItem *emailItem = [[UIBarButtonItem alloc] initWithTitle:@"Email"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(attemptToSendEmail:)];
    UIBarButtonItem *printItem = [[UIBarButtonItem alloc] initWithTitle:@"Print" 
                                                                  style:UIBarButtonItemStyleBordered 
                                                                 target:self
                                                                 action:@selector(attemptToPrint:)];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(delete:)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStyleBordered 
                                                                  target:self
                                                                  action:@selector(hideActionItems:)];
    // pack all the bbis into nav item
    [navItem setLeftBarButtonItems:[NSArray arrayWithObjects:emailItem, printItem, deleteItem, nil]];
    [navItem setRightBarButtonItem:cancelItem];
    
    // put navitem onto bottom of stand
    [bottomOfStand setItems:[NSArray arrayWithObject:navItem] 
                   animated:YES];
    
    // Cleanup
    [navItem release];
    [printItem release];
    [deleteItem release];
    [emailItem release];
    [cancelItem release];
}

/*
 *  Reset the bottomOfStand back to its original configuration
 */ 
- (IBAction)hideActionItems:(UIBarButtonItem *)sender
{
    UINavigationItem *navItem = [[UINavigationItem alloc] init];

    // set original navItems 
    [navItem setRightBarButtonItem:actionItem];
    [navItem setTitleView:tabControl];
    
    NSArray *navArray = [NSArray arrayWithObject:navItem];
    [bottomOfStand setItems:navArray animated:NO];
    
    [navItem release];
}

/*
 *  Display print options for selected blocks
 */
- (void)attemptToPrint:(UIBarButtonItem *)sender 
{
    NSLog(@"Print selected blocks");
}

/*
 *  Email selected blocks only if the total file size
 *  is less than the maximum email file size (tbd)
 */
- (void)attemptToSendEmail:(UIBarButtonItem *)sender
{
    NSLog(@"Email selected blocks");
}

/*
 *  Delete selected blocks
 */
- (void)delete:(UIBarButtonItem *)sender
{
    NSLog(@"Delete selected blocks");
}

// When the tab changes we know we have to switch controllers
- (IBAction)tabIndexChanged:(UISegmentedControl *)sender
{
    BlockTableController *newBlockController;
    UITableView *newTableView = [[UITableView alloc] initWithFrame:[tableView frame]
                                                             style:UITableViewStylePlain];
    
    // Define frames to use for animations
    CGRect leftframe = [tableView frame];
    leftframe.origin.x -= leftframe.size.width;
    
    CGRect rightframe = [tableView frame];
    rightframe.origin.x += rightframe.size.width;
    
    // Final frame to use
    CGRect centerframe = [tableView frame];
    
    // frame to use when animating out tableview
    CGRect outframe;
    
    if ([sender selectedSegmentIndex] == FILES_CONTROLLER_INDEX)
    {
        // display files controller, giving it the ability to update the tableview 
        newBlockController = [[FileTableController alloc] initWithManagedObjectContext:context
                                                                          andTableView:newTableView];
        // set new view as leftframe and animate it in
        [newTableView setFrame:leftframe];
        
        outframe = rightframe;
        
    }
    else 
    {
        // else show setlists controller
        newBlockController = [[SetlistTableController alloc] initWithManagedObjectContext:context
                                                                             andTableView:newTableView];
        // set new view as rightframe and animate it in
        [newTableView setFrame:rightframe];
        
        outframe = leftframe;
    }
    
    
    // add the new view to the window
    [[self view] addSubview:newTableView];
    
    // Set visual aspects of tableview
    [newTableView setBackgroundColor:[UIColor clearColor]];
    [newTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [newTableView setAllowsSelection:NO];
    
    [newTableView reloadData];
    
    // move navbar to front
    [[self view] bringSubviewToFront:bottomOfStand];
    
    
    
    [UIView animateWithDuration:0.2 
                     animations:^{
                         
                         [tableView setFrame:outframe];
                         [newTableView setFrame:centerframe];
                     }
                     completion:^(BOOL finished){
                         
                         // remove the rootController's view from window
                         [tableView removeFromSuperview]; 
                         [tableView release];
                         
                         // Set new tableView
                         tableView = [newTableView retain];
                         
                         // Set new blockController
                         [blockController release];
                         blockController = newBlockController;
                         
                         // Set the properties of blockController
                         [blockController setNavigationController:[self navigationController]];
                         [blockController setTableView:tableView];
                         
                     }];
    
    
    
}

@end
