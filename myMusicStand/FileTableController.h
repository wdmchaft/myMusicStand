/**
 *  @file FileTableController
 *  @author Steven Solomon <solomon.steven.m@gmail.com>
 *  @date 5/10/11
 *
 *  @discussion
 *  This class is a subclass of BlockTableController. It extends its superclass
 *  to allow dragging of blocks by delegating the task to ThumbnailDragController object
 *
 */

#import <UIKit/UIKit.h>
#import "BlockTableController.h"

@class myMusicStandAppDelegate, NSManagedObjectContext, StageViewController, File;
@interface FileTableController : BlockTableController <UITextFieldDelegate>

/**
 *  Allows clients that use this class to toggle gesture recognition on the thumbnails within
 *  the tableView
 */
@property (nonatomic, assign) BOOL canDragBlocks;

/**
 *  Allows for the selector used to respond to block gestures to be set
 */
@property (nonatomic, assign) SEL longPressSelector; 

/**
 *  Allows for target used in block gesture recognition to be set. 
 *  Note that the target isn't retained by us so it may not exist
 *  when a gesture recogition event is sent to it.
 */
@property (nonatomic, weak) id longPressTarget;

/**
 *  Reloads the files from it's instance of NSManagedObjectContext and then
 *  updates the tableView to reflect any new files. This is run anytime 
 *  the context we managed saves.
 *
 *  @param notification
 *  Currently an NSManagedObjectContextDidSaveNotification we are listening for.
 *  
 */
- (void)reloadFiles:(NSNotification *)notification;

/**
 *  Future will allow us to modify the alias of a file via the label under a thumbnail
 *  
 *  @param recognizer
 *  A gesture we will use to allow this feature to be used.
 */
-(void)editAlias:(UIGestureRecognizer *)recognizer;

/**
 *  @abstract
 *  A File instance that is mapped to the view passed in
 *
 *  @discussion
 *  This class keeps a mapping of blocks (aka thumbnails) to File instances
 *  allowing for fast lookup of the File that is displayed in the block
 *
 *  @param block
 *  A thumbnail displaying a file we care about and we want to access the actual
 *  file.
 *
 *  @return 
 *  the file corresponding to the block passed in
 */
- (File *)fileForBlock:(UIView *)block; 
@end
