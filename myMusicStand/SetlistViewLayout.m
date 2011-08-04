
#import "SetlistViewLayout.h"

@implementation SetlistViewLayout
{
    NSMutableDictionary *mapping;
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        mapping = [[NSMutableDictionary alloc] init];
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
 *  Inserts a thumbnail into the ordered listing of thumbnails. 
 *  Position of the thumbnail is determined by checking positioning 
 *  against other thumbnails.
 *
 *  @param thumbnail the thumbnail to insert into the listing
 *
 *  @return the position of that the thumbnail has been inserted into
 */
- (int)insertThumbnail:(UIView *)thumbnail
{
    int lastPosition = [mapping count];
    NSNumber *positionAsNumber = [NSNumber numberWithInt:lastPosition];
    
    [mapping setValue:positionAsNumber forKey:[thumbnail description]];
    
    int position = [self postionOfThumbnail:thumbnail];
    
    return position;
}
@end
