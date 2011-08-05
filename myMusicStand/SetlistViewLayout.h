/**
 *  @file SetlistViewLayout
 *  @author Steven Solomon <solomon.steven.m@gmail.com>
 *  @date 8/4/11
 *
 *  @section DESCRIPTION
 *  This class is used as a model for displaying dragable views
 *  displayed in a scrollview. It handles layout and animation for 
 *  the subviews of a scrollView
 */

#import <Foundation/Foundation.h>

@interface SetlistViewLayout : NSObject

/**
 *
 *  Designated intializer. 
 *  
 *  @param scrollView the scrollView whos layout we manage
 *
 *  @return instance of this class
 */
- (id)initWithScrollView:(UIScrollView *)scrollView;

/**
 *  Checks listing for the thumbnail and returns its position. 
 *  Note that positions are zero based.
 *  
 *  @param thumbnail 
 *  the thumbnail whos position we want to look up
 *
 *  @return 
 *  position of the thumbnail
 */
- (int)postionOfThumbnail:(UIView *)thumbnail;

/**
 *  Inserts a thumbnail into the ordered listing of thumbnails and into
 *  the view ivar at the appropriate position. Position of the thumbnail 
 *  is determined by checking positioning against other thumbnails.
 *
 *  @param thumbnail 
 *  the thumbnail to insert into the listing
 *
 *  @param completion 
 *  a void block used called immediatly after inserting a thumbnail
 *  into the scrollview 
 *
 *  @return 
 *  the position of that the thumbnail has been inserted into
 */
- (int)insertThumbnail:(UIView *)thumbnail completion:(void (^)(void))completion;

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
@end
