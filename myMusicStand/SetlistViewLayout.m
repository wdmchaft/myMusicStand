
#import "SetlistViewLayout.h"

#define THUMBNAIL_LEFT_PADDING 10
#define THUMBNAIL_TOP_PADDING 6
#define THUMBNAIL_WIDTH 162
#define THUMBNAIL_HEIGHT 201

@implementation SetlistViewLayout
{
    // Book keeping structure 
    NSMutableDictionary *mapping;
    
    // ScrollView we manage
    UIScrollView *view;
}

/**
 *  Designated intializer. 
 *  
 *  @param scrollView the scrollView whos layout we manage
 *
 *  @return instance of this class
 */
- (id)initWithScrollView:(UIScrollView *)scrollView
{
    self = [super init];
    if (self) 
    {
        mapping = [[NSMutableDictionary alloc] init];
        view = scrollView;
    }
    
    return self;
}

/**
 *  Checks listing for the thumbnail and returns its position. 
 *  Note that positions are zero based.
 *  
 *  @param thumbnail the thumbnail whos position we want to look up
 *
 *  @return position of the thumbnail
 */
- (int)postionOfThumbnail:(UIView *)thumbnail
{
    NSNumber *position = [mapping objectForKey:[thumbnail description]];
    return [position intValue];
}

/**
 *  Inserts a thumbnail into the ordered listing of thumbnails and into
 *  the view ivar at the appropriate position. Position of the thumbnail 
 *  is determined by checking positioning against other thumbnails.
 *
 *  @param thumbnail the thumbnail to insert into the listing
 *  @param completion a ^(void) block used called immediatly after inserting a thumbnail
 *                    into the scrollview 
 *
 *  @return the position of that the thumbnail has been inserted into
 */
- (int)insertThumbnail:(UIView *)thumbnail completion:(void (^)(void))completion;
{
    int lastPosition = [mapping count];
    NSNumber *positionAsNumber = [NSNumber numberWithInt:lastPosition];
    
    [mapping setValue:positionAsNumber forKey:[thumbnail description]];
    
    [view addSubview:thumbnail];
    
    // call completion block
    if (completion)
    {
        completion();
    }
    
    int position = [self postionOfThumbnail:thumbnail];
    
    return position;
}

/**
 *  Helper method to calculate the frame for a thumbnail at a 
 *  given position in the scrollView. This shouldn't be called by
 *  outside classes.
 *
 *  @param position position used to calculate the frame of a thumbnail
 *
 *  @return frame for the thumbnail
 */
- (CGRect)frameForPosition:(int)position
{
    CGRect frame = CGRectMake(0, THUMBNAIL_TOP_PADDING, THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT);
    
    CGFloat xOffset = (THUMBNAIL_LEFT_PADDING * (position + 1)) + position * frame.size.width;
    
    frame.origin.x = xOffset;
    
    return frame;
}
@end
