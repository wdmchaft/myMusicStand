
#import "SetlistViewLayout.h"

#define THUMBNAIL_LEFT_PADDING 10
#define THUMBNAIL_TOP_PADDING 6
#define THUMBNAIL_WIDTH 162
#define THUMBNAIL_HEIGHT 201
#define MIN_SCROLLVIEW_CONTENT_WIDTH 769
#define SCROLLVIEW_CONTENT_HEIGHT 252

@implementation SetlistViewLayout
{
    // Book keeping structure 
    NSMutableDictionary *mapping;
    
    // ScrollView we manage
    UIScrollView *view;
}

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

- (int)postionOfThumbnail:(UIView *)thumbnail
{
    NSNumber *position = [mapping objectForKey:[thumbnail description]];
    return [position intValue];
}

- (int)insertThumbnail:(UIView *)thumbnail completion:(void (^)(void))completion;
{
    if (!CGRectContainsPoint([view frame], [thumbnail center]))
    {
        return -1;
    }
    
    int lastPosition = [mapping count];
    NSNumber *positionAsNumber = [NSNumber numberWithInt:lastPosition];
    
    [mapping setValue:positionAsNumber forKey:[thumbnail description]];

    CGRect newFrame = [self frameForPosition:lastPosition];
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    // Animate the frame
    [UIView animateWithDuration:0.2
                     animations:^{
                         [thumbnail setFrame:newFrame];
                     }
                     completion:^(BOOL finished){
                         dispatch_async(mainQueue, ^{
                             
                            [view addSubview:thumbnail];
                             
                             // Grow the content size to show all the thumbnails
                             CGSize newContentSize = CGSizeMake(MIN_SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
                             newContentSize.width = (THUMBNAIL_WIDTH + THUMBNAIL_LEFT_PADDING) + newFrame.origin.x;

                             if (newContentSize.width <= MIN_SCROLLVIEW_CONTENT_WIDTH)
                             {
                                 newContentSize.width = MIN_SCROLLVIEW_CONTENT_WIDTH;
                             }
                             [view setContentSize:newContentSize];
                            
                         });
                         
                         [UIView animateWithDuration:0.2 
                                          animations:^{
                                             [thumbnail setTransform:CGAffineTransformIdentity];
                                             [thumbnail setAlpha:1.0];
                                         }];
                         // call the completion block
                         if (completion)
                         {
                             completion();
                         }
                     }];
    
    int position = [self postionOfThumbnail:thumbnail];
    
    return position;
}

- (CGRect)frameForPosition:(int)position
{
    CGRect frame = CGRectMake(0, THUMBNAIL_TOP_PADDING, THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT);
    
    CGFloat xOffset = (THUMBNAIL_LEFT_PADDING * (position + 1)) + position * frame.size.width;
    
    frame.origin.x = xOffset;
    
    return frame;
}
@end
