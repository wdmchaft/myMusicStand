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
#import "File.h"
#import "SetlistTableController.h"
#import "myMusicStandAppDelegate.h"
#import "TimestampEntity.h"

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
- (void)updateAddBlockDisplay;
@end

@implementation StageViewController
{
    BlockTableController *blockController;
    NSManagedObjectContext *context;
    IBOutlet UITableView *tableView;
    IBOutlet UINavigationBar *bottomOfStand;
    IBOutlet UIView *backOfStand;
    IBOutlet UIButton *doneButton; // button for finishing edit of a setlist
    IBOutlet UISegmentedControl *tabControl;
    IBOutlet UIBarButtonItem *actionItem;
    UIBarButtonItem *emailItem;
    BOOL isAddBlockShowing; // flag to keep track of setlist's addBlockShowing property
    
    // flag to keep track of when stand and it's components are down
    MusicStandState musicStandState; 
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    // setup states of none ui ivars
    musicStandState = MusicStandStateUp;
    isAddBlockShowing = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    context = [[myMusicStandAppDelegate sharedInstance] managedObjectContext];
    
    // Do any additional setup after loading the view from its nib.
    
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
                                                                  action:@selector(hideActionItems:)];
    
    // Array of items to show on screen
    NSArray *itemsArray = [NSArray arrayWithObjects:emailItem, printItem, deleteItem, nil];
    
    // If we are using new 5.0 api 
    if ([navItem respondsToSelector:@selector(setLeftBarButtonItems:)])
    {
        // pack all the bbis into navitem
        [navItem setLeftBarButtonItems:itemsArray];
    }
    else // Assuming 4.3 api 
    {
        // create frame for toolbar
        CGRect toolbarFrame = [bottomOfStand bounds];
        toolbarFrame.size.width = 400;
        
        // Put all items in a toolbar
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
        [toolbar setItems:itemsArray];
        
        // Put toolbar into navItem, which will be put into the bottomOfStand
        UIBarButtonItem *toolBarContainer = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
        [navItem setLeftBarButtonItem:toolBarContainer];
        
    }
    
    // show items we created
    [bottomOfStand setItems:[NSArray arrayWithObject:navItem] 
                   animated:YES];
    
    // Show cancel item
    [navItem setRightBarButtonItem:cancelItem];
    
    // Allow block selection
    [blockController setIsSelectingBlocks:YES];
    
    // Stop display of add button in setlistsTableController
    isAddBlockShowing = NO;
    [self updateAddBlockDisplay];
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
    
    
    // stop block selection
    [blockController setIsSelectingBlocks:NO];
    // reload table
    [[blockController tableView] reloadData];
    
    // reshow add block after cancel is hit in action menu
    isAddBlockShowing = YES;
    [self updateAddBlockDisplay];
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
    // Handle email account not being setup
    if (![MFMailComposeViewController canSendMail])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email not setup"
                                                        message:@"Please set up an email account in the Mail app,"
                              @" so we can help you share your charts"
                                                       delegate:nil 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    [composer setMailComposeDelegate:self];
    
    // Set up message
    [composer setSubject:@"Checkout out this chart from myMusicStand"];
    
    for (NSURL *url in attachmentURLs)
    {
        NSData *data = [NSData dataWithContentsOfURL:url];
        [composer addAttachmentData:data mimeType:@"pdf" fileName:[url lastPathComponent]];
    }
    
    // Display composer
    [self presentModalViewController:composer animated:YES];
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
        
        // set up to display the isAddBlockShowing
        [self updateAddBlockDisplay];
        
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
    [self moveMusicStandToState:MusicStandStateDown];
    
}

- (void)slideStandUp
{
    [self moveMusicStandToState:MusicStandStateUp];
    isAddBlockShowing = YES; // reset to display add block
    [self updateAddBlockDisplay];
    
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
    
    
    // determine how to set the UI
    if (toState == MusicStandStateDown)
    {
        newTableFrame.origin.y += BACK_OF_STAND_Y_OFFSET;
        newTableFrame.size.height -= BACK_OF_STAND_Y_OFFSET;
        

        newBottomOfStandFrame.origin.y += BACK_OF_STAND_Y_OFFSET;
        
        
        newBackOfStandFrame.origin.y += BACK_OF_STAND_Y_OFFSET;
        
        
        newDoneButtonFrame.origin.y += (BACK_OF_STAND_Y_OFFSET + DONE_BUTTON_Y_INSET);
    }
    else // State up
    {
        newTableFrame.origin.y -= BACK_OF_STAND_Y_OFFSET;
        newTableFrame.size.height += BACK_OF_STAND_Y_OFFSET;
        
        newBottomOfStandFrame.origin.y -= BACK_OF_STAND_Y_OFFSET;
        
        newBackOfStandFrame.origin.y -= BACK_OF_STAND_Y_OFFSET;
        
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
                             [navItem setRightBarButtonItem:bbi];
                             
                             bbi = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(slideStandUp)];
                             [navItem setLeftBarButtonItems:[NSArray arrayWithObject:bbi]];
                         }
                         else // State down
                         {
                             [navItem setRightBarButtonItem:actionItem];
                             [navItem setLeftBarButtonItems:nil];
                         }
                     }];

}

-(void)updateAddBlockDisplay
{
    // if we are showing a setlistTableController's content
    if ([blockController isKindOfClass:[SetlistTableController class]])
    {
        [(SetlistTableController *)blockController setAddBlockShowing:isAddBlockShowing];
    }
}
#pragma mark MFMailComposeDelegate Methods
- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error
{
    // close the composer 
    [controller dismissModalViewControllerAnimated:YES];
}

@end
