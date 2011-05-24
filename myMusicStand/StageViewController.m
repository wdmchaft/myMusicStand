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
    
    blockController = [[FileTableController alloc] init];
    // Set navigationController
    [blockController setNavigationController:[self navigationController]];
    
    // Set blockController as delegate and datasource of our table
    [tableView setDelegate:blockController];
    [tableView setDataSource:blockController];
    
    // Set visual aspects of tableview
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
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
    BlockTableController *listController;
    
    if ([sender selectedSegmentIndex] == FILES_CONTROLLER_INDEX)
    {
        // display files controller
        // else show setlists controller
        listController = 
        [[FileTableController alloc] initWithStyle:UITableViewStylePlain];
        
        // Give the controller the current setlists
        NSMutableArray *files = 
        [[context allEntity:@"File"] mutableCopy];
        
        [(FileTableController *)listController setFiles:files];
        
    }
    else 
    {
        // else show setlists controller
        listController = 
        [[SetlistTableController alloc] initWithStyle:UITableViewStylePlain];
        
        // Give the controller the current setlists
        NSMutableArray *setlists = [[context allEntity:@"Setlist"] mutableCopy];
        
        [(SetlistTableController *)listController setSetlists:[setlists autorelease]];
    }
    
    CGRect leftframe = [[self view] frame];
    leftframe.origin.x -= leftframe.size.width;
    
    // add the new view to the window
    [[self view] addSubview:[listController view]];
    
    // move navbar to front
    [[self view] bringSubviewToFront:bottomOfStand];
    
    [UIView animateWithDuration:0.2 
                     animations:^{
                         
                         [[self view] setFrame:leftframe];
                     }
                     completion:^(BOOL finished){
                         
                         // remove the rootController's view from window
                         [[self view] removeFromSuperview]; 
                         
                         // release the other controller
                         [self release];
                         
                         //self = listController;
                         
                         [[self tableView] reloadData];
                         
                     }];
    
    
    
}

@end
