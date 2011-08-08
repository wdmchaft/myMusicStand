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

@property (nonatomic, readonly) BlockTableController *blockController;
@property (nonatomic, readonly) UIScrollView *backOfStand;

- (IBAction)tabIndexChanged:(UISegmentedControl *)sender;
- (IBAction)showActionItems:(UIBarButtonItem *)sender;
- (void)setEmailButtonEnabled:(BOOL)enabled;
- (void)displayEmailWith:(NSArray *)attachmentURLs;
- (void)slideStandDown;
- (void)slideStandUp;

@end
