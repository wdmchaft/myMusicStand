/**
 *  @file SetlistViewLayout
 *  @author Steven Solomon <solomon.steven.m@gmail.com>
 *  @date 8/4/11
 *
 *  @section DESCRIPTION
 *  This class is used to keep as a model for displaying dragable views
 *  displayed in a scrollview. 
 */

#import <Foundation/Foundation.h>

@interface SetlistViewLayout : NSObject

- (id)initWithScrollView:(UIScrollView *)scrollView;
- (int)postionOfThumbnail:(UIView *)thumbnail;
- (int)insertThumbnail:(UIView *)thumbnail completion:(void (^)(void))completion;

@end
