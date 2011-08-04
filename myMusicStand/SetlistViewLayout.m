
#import "SetlistViewLayout.h"

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
@end
