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

- (id)initWithScrollView:(UIScrollView *)scrollView;
- (int)postionOfThumbnail:(UIView *)thumbnail;
- (int)insertThumbnail:(UIView *)thumbnail completion:(void (^)(void))completion;
- (CGRect)frameForPosition:(int)position;
@end
