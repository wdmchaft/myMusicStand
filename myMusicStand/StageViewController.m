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
        context = [[myMusicStandAppDelegate sharedInstance] managedObjectContext];
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
    // Do any additional setup after loading the view from its nib.
    
    blockController = [[FileTableController alloc] initWithManagedObjectContext:context];
    // Set navigationController
    [blockController setNavigationController:[self navigationController]];
    
    // Give blockControll ref to tableView
    [(FileTableController *)blockController setTableView:tableView];
    
    // Set blockController as delegate and datasource of our table
    [tableView setDelegate:blockController];
    [tableView setDataSource:blockController];
    
    // Set visual aspects of tableview
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Give the tableView a label of "Charts"
    [tableView setAccessibilityLabel:@"Charts"];
    
    // Register blockController for notifications
    [[NSNotificationCenter defaultCenter] addObserver:blockController
                                             selector:@selector(reloadModel:) 
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];
    // Reload the data in the table
    [tableView reloadData];
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
        // display files controller
        // else show setlists controller
        newBlockController = [[FileTableController alloc] init];
        
        // Give the controller the current setlists
        NSMutableArray *files = 
        [[context allEntity:@"File"] mutableCopy];
        
        [(FileTableController *)newBlockController setFiles:files];

        // Give ref to tableView
        [(FileTableController *)newBlockController setTableView:newTableView];
        
    }
    else 
    {
        // else show setlists controller
        newBlockController = [[SetlistTableController alloc] init];
        
        // Give the controller the current setlists
        NSMutableArray *setlists = [[context allEntity:@"Setlist"] mutableCopy];
        
        [(SetlistTableController *)newBlockController setSetlists:[setlists autorelease]];
    }
    
    CGRect leftframe = [[self view] frame];
    leftframe.origin.x -= leftframe.size.width;
    
    // add the new view to the window
    [[self view] addSubview:newTableView];
    
    // Set visual aspects of tableview
    [newTableView setBackgroundColor:[UIColor clearColor]];
    [newTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [newTableView setAllowsSelection:NO];
    
    // Set blockController as delegate and datasource of our table
    [newTableView setDelegate:newBlockController];
    [newTableView setDataSource:newBlockController];
    
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
