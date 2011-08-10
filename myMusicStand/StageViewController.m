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
#import "Thumbnail.h"
#import "File.h"
#import "SetlistTableController.h"
#import "myMusicStandAppDelegate.h"
#import "TimestampEntity.h"
#import "MailComposerController.h"
#import "ThumbnailDragController.h"

#define FILES_CONTROLLER_INDEX 0
#define NAV_BAR_HEIGHT 44
#define BACK_OF_STAND_Y_OFFSET 208
#define DONE_BUTTON_Y_INSET 7

typedef enum 
{
    MusicStandStateUp = 0,
    MusicStandStateDown
} MusicStandState;

@interface StageViewController ()
#pragma mark Private Helper Methods
// move the musicstand ui from one state to passed in state
- (void)moveMusicStandToState:(MusicStandState)toState;
// update the setlists display the add block based on isAddBlockShowing flag
-(void)updateAddBlockDisplayOnBlockController:(BlockTableController *)aBlockController;
@end

@implementation StageViewController
{
    BlockTableController *blockController;
    NSManagedObjectContext *context;
    IBOutlet UITableView *tableView;
    IBOutlet UINavigationBar *bottomOfStand;
    IBOutlet UIScrollView *backOfStand;
    IBOutlet UIButton *doneButton; // button for finishing edit of a setlist
    IBOutlet UISegmentedControl *tabControl;
    IBOutlet UIBarButtonItem *actionItem;
    IBOutlet UIImageView *imageOfStand;
    IBOutlet UIImageView *standTripod;
    
    UIBarButtonItem *emailItem;
    BOOL isAddBlockShowing; // flag to keep track of setlist's addBlockShowing property
    
    // flag to keep track of when stand and it's components are down
    MusicStandState musicStandState; 
    
    MailComposerController *composerController; // responsible for handling email UI
    
    ThumbnailDragController *dragController; // handles dragging blocks on screen    
}

@synthesize blockController;
@synthesize backOfStand;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    // setup states of none ui ivars
    musicStandState = MusicStandStateUp;
    isAddBlockShowing = YES;
    
    // composer for email messages
    composerController = [[MailComposerController alloc] initWithStageViewController:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    context = [[myMusicStandAppDelegate sharedInstance] managedObjectContext];
    
    blockController = [[FileTableController alloc] initWithManagedObjectContext:context andTableView:tableView];
    // Set navigationController
    [blockController setNavigationController:[self navigationController]];
    // Add us as delegate
    [blockController setDelegate:self];
    
    // Set visual aspects of tableview
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setAllowsSelection:NO];
    
    // Give the tableView a label of "Charts"
    [tableView setAccessibilityLabel:@"Charts"];

    // Give the bottom of stand its backgroud image
    UIImage *bottomOfStandImage = [UIImage imageNamed:@"bottomOfStand"];
    UIEdgeInsets bottomOfStandInsets = UIEdgeInsetsMake(6, 21, 0, 21);
    bottomOfStandImage = [bottomOfStandImage resizableImageWithCapInsets:bottomOfStandInsets];
    [bottomOfStand setBackgroundImage:bottomOfStandImage forBarMetrics:UIBarMetricsDefault];
    
    // Relayout nav bar items to have proper spacing
    [self layoutInitialBarItems];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    blockController = nil;
    bottomOfStand = nil;
    tableView = nil;
    tabControl = nil;
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

    emailItem = [[UIBarButtonItem alloc] initWithTitle:@"Email"
                                                 style:UIBarButtonItemStyleBordered
                                                target:self
                                                action:@selector(sendEmail:)];

    UIBarButtonItem *printItem = [[UIBarButtonItem alloc] initWithTitle:@"Print" 
                                                                  style:UIBarButtonItemStyleBordered 
                                                                 target:self
                                                                 action:@selector(attemptToPrint:)];
    
    [printItem setEnabled:NO];
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(delete:)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStyleBordered 
                                                                  target:self
                                                                  action:@selector(layoutInitialBarItems)];
    
    // Add spacing button
    UIBarButtonItem *leftSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                                                                               target:nil 
                                                                               action:nil];
    [leftSpaceItem setWidth:15.0];
    
    // Array of items to show on screen
    NSArray *itemsArray = [NSArray arrayWithObjects:leftSpaceItem, emailItem, printItem, deleteItem, nil];
    
    // pack all the bbis into navitem
    [navItem setLeftBarButtonItems:itemsArray];
        

    // Add spacing button
    UIBarButtonItem *rightSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                                                                                target:nil 
                                                                                action:nil];
    [rightSpaceItem setWidth:15.0];
    itemsArray = [NSArray arrayWithObjects:rightSpaceItem, cancelItem,nil];
    
    // Show cancel item
    [navItem setRightBarButtonItems:itemsArray];
    
    // show items we created
    [bottomOfStand setItems:[NSArray arrayWithObject:navItem] 
                   animated:YES];
    
    // Allow block selection
    [blockController setIsSelectingBlocks:YES];
    
    // Stop display of add button in setlistsTableController
    isAddBlockShowing = NO;
    [self updateAddBlockDisplayOnBlockController:blockController];
}

- (void)layoutInitialBarItems
{
    // Get first navItem
    UINavigationItem *navItem = [[bottomOfStand items] objectAtIndex:0];

    // set original navItems 
    UIBarButtonItem *rightSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                                                                                   target:nil 
                                                                                   action:nil];
    [rightSpaceItem setWidth:15.0];
    [navItem setRightBarButtonItems:[NSArray arrayWithObjects:rightSpaceItem, actionItem, nil]];
    
    // create a new tabControl
    [self createAndStoreNewTabControl];
    
    [navItem setTitleView:tabControl];

    [navItem setLeftBarButtonItems:nil];
    
    NSArray *navArray = [NSArray arrayWithObject:navItem];
    [bottomOfStand setItems:navArray animated:NO];
    
    // stop block selection
    [blockController setIsSelectingBlocks:NO];
    // reload table
    [[blockController tableView] reloadData];
    
    // reshow add block after cancel is hit in action menu
    isAddBlockShowing = YES;
    [self updateAddBlockDisplayOnBlockController:blockController];
}

// allow for public way to setEnabled attr on email action button
- (void)setEmailButtonEnabled:(BOOL)enabled
{
    [emailItem setEnabled:enabled];
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
- (void)sendEmail:(UIBarButtonItem *)sender
{    
    NSArray *selectedModels = [blockController selectedModels];
    
    // Build array of attachment urls
    NSMutableArray *attachments = [[NSMutableArray alloc] init];
    for (File *file in selectedModels)
    {
        myMusicStandAppDelegate *appDelegate = [myMusicStandAppDelegate sharedInstance];
        NSURL *url = [appDelegate applicationDocumentsDirectory];
        url = [url URLByAppendingPathComponent:[file filename] isDirectory:NO];
        [attachments addObject:url];
    }
    
    // display the email
    [self displayEmailWith:attachments];
    
}

- (void)displayEmailWith:(NSArray *)attachmentURLs
{
    // delegate the handling of email stuff to composerController
    [composerController displayEmailWith:attachmentURLs];
}

/*
 *  Delete selected blocks
 */
- (void)delete:(UIBarButtonItem *)sender
{
    [blockController deleteSelectedModels];
}

// When the tab changes we know we have to switch controllers
- (IBAction)tabIndexChanged:(UISegmentedControl *)sender
{
    BlockTableController *newBlockController;
    
    // Frame for music stand being up
    CGRect defaultFrame = CGRectMake(0, 44, 768, 960);
    
    // Frame for music stand being down
    if (musicStandState == MusicStandStateDown)
    {
        defaultFrame = CGRectMake(0, 252, 768, 752);
    }
    UITableView *newTableView = [[UITableView alloc] initWithFrame:defaultFrame
                                                             style:UITableViewStylePlain];
    
    // Define frames to use for animations
    CGRect leftframe = defaultFrame;

    leftframe.origin.x -= leftframe.size.width;
    
    CGRect rightframe = defaultFrame;
    rightframe.origin.x += rightframe.size.width;
    
    // Final frame to use
    CGRect centerframe = defaultFrame;
    
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
        
        // give FileTableController the method we want it to use for long presses
        [(FileTableController *)newBlockController setLongPressTarget:dragController];
        [(FileTableController *)newBlockController setLongPressSelector:@selector(handleLongPress:)];
        
    }
    else 
    {
        // else show setlists controller
        newBlockController = [[SetlistTableController alloc] initWithManagedObjectContext:context
                                                                             andTableView:newTableView];
        // set up to display the isAddBlockShowing
        [self updateAddBlockDisplayOnBlockController:newBlockController];
        
        // set new view as rightframe and animate it in
        [newTableView setFrame:rightframe];
        
        outframe = leftframe;
    }
    
    // Add us as delegate
    [newBlockController setDelegate:self];
    
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
                         
                         // Set new tableView
                         tableView = newTableView;
                         
                         // Set new blockController
                         blockController = newBlockController;
                         
                         // Set the properties of blockController
                         [blockController setNavigationController:[self navigationController]];
                         [blockController setTableView:tableView];
                         
                     }];
    
    
    
}

#pragma mark Stand Moving Methods
- (void)slideStandDown
{
    // clear out the stand of subviews
    for (UIView *subview in [backOfStand subviews])
    {
        [subview removeFromSuperview];
    }
    
    [self moveMusicStandToState:MusicStandStateDown];
    isAddBlockShowing = NO;
    
    // allow dragging by setting the dragController 
    dragController = [[ThumbnailDragController alloc] initWithStageViewController:self];
    
}

- (void)slideStandUp
{
    [self moveMusicStandToState:MusicStandStateUp];
    isAddBlockShowing = YES; // reset to display add block
    [self updateAddBlockDisplayOnBlockController:blockController];
    
    // disable dragging of views, if we are in viewing teh file controller
    if ([blockController isKindOfClass:[FileTableController class]])
    {
        [(FileTableController *)blockController setLongPressTarget:nil];
        [tableView reloadData];
    }
    
    // trash dragController
    dragController = nil;    
}

#pragma mark Helper Methods
// Method to move the MusicStand UI to the desired state
- (void)moveMusicStandToState:(MusicStandState)toState
{
    // if we are already in the desired state do nothing
    if (musicStandState == toState)
    {
        return;
    }
    
    // else mark stand as down
    musicStandState = toState;
    
    // new rects to move the ui
    CGRect newTableFrame = [tableView frame];
    CGRect newBottomOfStandFrame = [bottomOfStand frame];
    CGRect newBackOfStandFrame = [backOfStand frame];
    CGRect newDoneButtonFrame = [doneButton frame];
    CGRect newImageOfStandFrame = [imageOfStand frame];
    CGRect newStandTripodFrame = [standTripod frame];
    
    // determine how to set the UI
    if (toState == MusicStandStateDown)
    {
        newTableFrame.origin.y += BACK_OF_STAND_Y_OFFSET;
        newTableFrame.size.height -= BACK_OF_STAND_Y_OFFSET;
        

        newBottomOfStandFrame.origin.y += BACK_OF_STAND_Y_OFFSET;
    
        newBackOfStandFrame.origin.y += BACK_OF_STAND_Y_OFFSET;
        
        newImageOfStandFrame.origin.y += BACK_OF_STAND_Y_OFFSET; 
        
        newStandTripodFrame.origin.y += BACK_OF_STAND_Y_OFFSET;
        
        newDoneButtonFrame.origin.y += (BACK_OF_STAND_Y_OFFSET + DONE_BUTTON_Y_INSET);
    }
    else // State up
    {
        newTableFrame.origin.y -= BACK_OF_STAND_Y_OFFSET;
        newTableFrame.size.height += BACK_OF_STAND_Y_OFFSET;
        
        newBottomOfStandFrame.origin.y -= BACK_OF_STAND_Y_OFFSET;
        
        newBackOfStandFrame.origin.y -= BACK_OF_STAND_Y_OFFSET;
        
        newImageOfStandFrame.origin.y -= BACK_OF_STAND_Y_OFFSET;
        
        newStandTripodFrame.origin.y -= BACK_OF_STAND_Y_OFFSET;
        
        newDoneButtonFrame.origin.y -= (BACK_OF_STAND_Y_OFFSET - DONE_BUTTON_Y_INSET);
    }
    
    // Animate UI to new positioning
    [UIView animateWithDuration:0.2 
                     animations:^{                         
                         // move all the components of the stand down
                         [tableView setFrame:newTableFrame];
                         [bottomOfStand setFrame:newBottomOfStandFrame];
                         [backOfStand setFrame:newBackOfStandFrame];
                         [doneButton setFrame:newDoneButtonFrame];
                         [imageOfStand setFrame:newImageOfStandFrame];
                         [standTripod setFrame:newStandTripodFrame];
                         
                     }
                     completion:^(BOOL finished){
                         
                         // add buttons for cancel and done to bottomOfStand
                         UINavigationItem *navItem = [[bottomOfStand items] objectAtIndex:0];
                         
                         if (musicStandState == MusicStandStateDown)
                         {
                             UIBarButtonItem *bbi = 
                             [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                              style:UIBarButtonItemStyleDone 
                                                             target:self 
                                                             action:@selector(slideStandUp)];
                             
                             UIBarButtonItem *spaceItem = 
                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                                                                              target:nil 
                                                                              action:nil];
                             [spaceItem setWidth:15.0];
                             [navItem setRightBarButtonItems:[NSArray arrayWithObjects:spaceItem, bbi, nil]];
                             
                             bbi = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(slideStandUp)];
                             
                             spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                                                                                       target:nil 
                                                                                       action:nil];
                             [spaceItem setWidth:15.0];
                             [navItem setLeftBarButtonItems:[NSArray arrayWithObjects:spaceItem, bbi, nil]];
                         }
                         else // State down
                         {
                             [self layoutInitialBarItems];
                         }
                     }];

}

- (void)createAndStoreNewTabControl
{
    // Make sure new control has the same index selected
    NSInteger selectedSegmentIndex = [tabControl selectedSegmentIndex];
    
    // Create our new instance and store it in our ivar
    tabControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Charts",  @"Sets", nil]];
    
    // Set visual attributes
    [tabControl setSelectedSegmentIndex:selectedSegmentIndex];
    [tabControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    
    [tabControl addTarget:self 
                   action:@selector(tabIndexChanged:) 
         forControlEvents:UIControlEventValueChanged];
    
    CGRect frame = [tabControl frame];
    frame.size.width = 307;
    [tabControl setFrame:frame];

}

-(void)updateAddBlockDisplayOnBlockController:(BlockTableController *)aBlockController
{
    // if we are showing a setlistTableController's content
    if ([aBlockController isKindOfClass:[SetlistTableController class]])
    {
        [(SetlistTableController *)aBlockController setAddBlockShowing:isAddBlockShowing];
        [tableView reloadData];
    }
}


@end
