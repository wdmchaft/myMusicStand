/**
 *  @file ThumbnailDragController
 *  @author Steven Solomon <solomon.steven.m@gmail.com>
 *  @date 7/26/11
 *
 *  @section DESCRIPTION
 *  This class wraps the handling of a long press event on a Thumbnail from a tableView
 *  allowing it to be dragged around the screen and possibly dropped onto the musicStand by
 *  the user.
 */

#import <Foundation/Foundation.h>

@class StageViewController;
@interface ThumbnailDragController : NSObject

/**
 *  Designated intializer for ThumbnailDragController
 *
 *  @param aDelegate 
 *  our delegate is used to get information about the screen and the 
 *  placement of visual components
 *
 *  @return 
 *  an instance of ThumbnailDragController
 */
- (id)initWithStageViewController:(StageViewController *)aDelegate;

/**
 *  Handles a long press event on a block (aka a thumbnail) after 
 *  the long press begins this method determines how to visually move
 *  the thumbnail around the screen as the user performs dragging motions
 *
 *  @param recognizer 
 *  recognizer for the event.
 */
-(void)handleLongPress:(UILongPressGestureRecognizer *)recognizer;

/**
 *  Animate the dragView to its new Frame in the delegates backOfStand
 *
 *  @param newFrame 
 *  frame for the dragView
 *
 *  @param completion 
 *  completion block that is called after animation
 *
 */
- (void)animateDragViewOnStandToFrame:(CGRect)newFrame completion:(void (^)(BOOL finished))completion;

/**
 *  @abstract 
 *  Animate DragView to appear as grabbed.
 *
 *  @discussion
 *  A grabbed appearence on iOS is slightly less opaque and larger than a normal view.
 */
- (void)makeDragViewAppearGrabbed;

/**
 *  @private
 *  Helper method to calculate the frame for a thumbnail at a 
 *  given position in the scrollView. This shouldn't be called by
 *  outside classes.
 *
 *  @param position 
 *  position used to calculate the frame of a thumbnail
 *
 *  @return 
 *  frame for the thumbnail
 */
- (CGRect)frameForPosition:(int)position;

/**
 *  @abstract
 *  Helper method to add file to setlist and also update the view to show change.
 *
 *  @discussion 
 *  Checks if the file should be added to a setlist based on where it is dropped.
 *  If it should be added the addition is animated.
 */
- (void)addFileToSetlistAndUpdateView;
@end
