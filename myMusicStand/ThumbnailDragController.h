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
 *  Determines the frame within a music stand to give the appearence of ordering 
 *
 *  @param index 
 *  the position where the thumbnail will be placed visually on the stand
 *
 *  @return 
 *  the frame for the thumbnail to be displayed in 
 *
 */
- (CGRect)frameOnStandForPosition:(int)position;

/**
 *  Relayout the views in the backOfStand according to their position in a book keeping
 *  datastructure. After determining the new frame we animate the view to it.
 */
- (void)relayoutThumbnails;

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
 *  Hit test the backOfStand and determine which position the user is intending to 
 *  drop the dragView.
 *
 *  @param center 
 *  the center of the dragView to use in our calculation for dragView's intended position
 */
- (void)processHitTestForPoint:(CGPoint)center;
@end
