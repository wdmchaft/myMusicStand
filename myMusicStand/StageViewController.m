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
    
    // Give the tableView a label of "Charts"
    [tableView setAccessibilityLabel:@"Charts"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark Action Methods

// When the tab changes we know we have to switch controllers
- (IBAction)tabIndexChanged:(UISegmentedControl *)sender
{
    BlockTableController *newBlockController;
    UITableView *newTableView = [[UITableView alloc] initWithFrame:[tableView frame]
                                                             style:UITableViewStylePlain];
    
    if ([sender selectedSegmentIndex] == FILES_CONTROLLER_INDEX)
    {
        // display files controller, giving it the ability to update the tableview 
        newBlockController = [[FileTableController alloc] initWithManagedObjectContext:context
                                                                          andTableView:newTableView];
        
    }
    else 
    {
        // else show setlists controller
        newBlockController = [[SetlistTableController alloc] init];
        
        // Give the controller the current setlists
        NSMutableArray *setlists = [[context allEntity:@"Setlist"] mutableCopy];
        
        [(SetlistTableController *)newBlockController setModel:[setlists autorelease]];
    }
    
    CGRect leftframe = [[self view] frame];
    leftframe.origin.x -= leftframe.size.width;
    
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
                         
                         [tableView setFrame:leftframe];
                     }
                     completion:^(BOOL finished){
                         
                         // remove the rootController's view from window
                         [tableView removeFromSuperview]; 
                         [tableView release];
                         
                         // Set new tableView
                         tableView = newTableView;
                         
                         // unregister old block controller 
                         [[NSNotificationCenter defaultCenter] removeObserver:blockController];
                         // Register blockController for notifications
                         [[NSNotificationCenter defaultCenter] addObserver:newBlockController
                                                                  selector:@selector(reloadModel:) 
                                                                      name:NSManagedObjectContextDidSaveNotification
                                                                    object:nil];
                         
                         // Set new blockController
                         [blockController release];
                         blockController = newBlockController;
                         
                         // Set the properties of blockController
                         [blockController setNavigationController:[self navigationController]];
                         [blockController setTableView:tableView];
                         
                     }];
    
    
    
}

@end
