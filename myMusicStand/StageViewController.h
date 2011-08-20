/**
 *  @file StageViewController
 *  @author Steven Solomon <solomon.steven.m@gmail.com>
 *  @date 5/24/11
 *
 *  @abstract
 *  This class is the overall controller for the myMusicStand app.
 *  
 *  @discussion 
 *  StageViewController manages the stage analogy throughout the app.
 *  It delegates managing of the tableView to a subclass of blockController.
 *  It handles all tasks that require knowledge of a myMusicStandDelegate and
 *  navigationController for the app. 
 *  
 *  It provides interfaces to allow for the musicStand on screen to be slid up and
 *  down as well as emailing model objects as attachments.
 *
 */

#import <UIKit/UIKit.h>

@class BlockTableController;
@interface StageViewController : UIViewController 

/**
 *  @property 
 *  A pointer to an object that controls the layout of a table into blocks.
 */
@property (nonatomic, strong, readonly) BlockTableController *blockController;

/**
 *  @property
 *  A scroll view where charts may be dragged in order to build a setlist.
 */
@property (nonatomic, strong, readonly) UIScrollView *backOfStand;

/**
 *  @abstract 
 *  Handle transition between subclasses of BlockTableController.
 *
 *  @discussion
 *  
 */
- (IBAction)tabIndexChanged:(UISegmentedControl *)sender;
- (IBAction)showActionItems:(UIBarButtonItem *)sender;

/**
 *  @abstract 
 *  Configures barbutton items in a navBar to initial configuration.
 *  
 *  @discussion
 *  This method should only be called from within this class. It is used
 *  to modify a instance variable bottomOfStand's navItem.
 */
- (void)layoutInitialBarItems;

/**
 *  @abstract
 *  Creates and stores new UISegmentedControl and stores it into tabControl ivar.
 *
 *  @discussion
 *  Each time we layoutInitialBarItems we want to recreate the tabControl.
 *  We create a new UISegmentedControl instance and return it after 
 *  duplicating any attributes we care about.
 */
- (void)createAndStoreNewTabControl;

- (void)setEmailButtonEnabled:(BOOL)enabled;
- (void)displayEmailWith:(NSArray *)attachmentURLs;
- (void)slideStandDown;

/**
 *  @abstract
 *  Slide the music stand up and save the changes if the sender is the 
 *  "Done" button.
 *
 *  @discussion
 *  If the sender has the title "Done" the stand also saves the changes to the 
 *  NSManagedObjectContext.
 *  
 *  @param sender
 *  Caller of this method.
 */
- (void)slideStandUp:(UIBarButtonItem *)sender;

/**
 *  @abstract 
 *  Determine the frame to be used based on interface orientation and musicStandState
 *  
 *  @discussion 
 *  The tableView being displayed requires drastically different frames based on
 *  the musicStandState and the device orientation. 
 *  <br />Resulting in 4 configurations:
 *      <ul>
 *          <li>musicStandDown and landscape </li>
 *          <li>musicStandUp and landscape</li>
 *          <li>musicStandDown and portrait</li>
 *          <li>musicStandUp and portrait</li>
 *      </ul>
 *
 *  @param orientation
 *  The orientation to use in determining the frame.
 *
 *  @return 
 *  The calculated frame.
 */
- (CGRect)determineTableFrame:(UIInterfaceOrientation)orientation;

/**
 *  @abstract 
 *  Render a screenshot of the entire view heirarchy.
 *
 *  @discussion
 *  In order to perform a crossfade animation we needed to capture an image of the 
 *  entire screen. This method generates such an image.
 *
 *  @return
 *  Image of the entire view heirarchy.
 */
- (UIImage*)screenshot;
@end
