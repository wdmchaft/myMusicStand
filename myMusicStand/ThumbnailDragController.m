
#import "ThumbnailDragController.h"
#import "StageViewController.h"
#import "BlockTableController.h"
#import "FileTableController.h"
#import "File.h"
#import "Setlist.h"
#import "Thumbnail.h"
#import "myMusicStandAppDelegate.h"
#import "SetlistViewLayout.h"

@implementation ThumbnailDragController
{
    // Offsets in dragged view
    CGFloat xOffset;
    CGFloat yOffset;
    __block UIView *dragView;
    
    StageViewController *__weak delegate;
    NSManagedObjectContext *setlistContext;
    Setlist *newSetlist;
    UIView *targetView;

    SetlistViewLayout *viewLayout;
}

- (id)initWithStageViewController:(StageViewController *)aDelegate
{
    self = [super init];
    if (self) {
        delegate = aDelegate;
        NSManagedObjectContext *context = [[myMusicStandAppDelegate sharedInstance] managedObjectContext];
        // create a context just for editing the setlist
        setlistContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [setlistContext setParentContext:context];
        
        // create a new setlist
        newSetlist = [NSEntityDescription insertNewObjectForEntityForName:@"Setlist" inManagedObjectContext:setlistContext];
        
        viewLayout = [[SetlistViewLayout alloc] initWithScrollView:[delegate backOfStand]];

    }
    
    return self;
}

- (void)animateDragViewOnStandToFrame:(CGRect)newFrame completion:(void (^)(BOOL finished))completion;
{
    // animate dragview back to normal
    [UIView animateWithDuration:0.2 
                     animations:^{
                         [dragView setTransform:CGAffineTransformIdentity];
                         [dragView setAlpha:1.0];
                         [dragView setFrame:newFrame];
                     }
                     completion:completion];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    targetView = [recognizer view];
    
    // touched point
    CGPoint point = [recognizer locationInView:[delegate view]];
    
    // Since we have recieved a event and we assume the delegate has a FileTableController
    FileTableController *blockController = (FileTableController *)[delegate blockController];
    
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        // create a dragging view that is the same dimensions as targetview in terms of this view
        CGRect dragViewFrame = [[targetView superview] convertRect:[targetView frame] toView:[delegate view]];

        // show the dragging view        
        dragView = [[UIView alloc] initWithFrame:dragViewFrame];
        [[delegate view] addSubview:dragView];
        
        // make the dragView look like the targetView   
        File *fileObject = [(FileTableController *)blockController fileForBlock:targetView];
        UIImage *image = [[UIImage alloc] initWithData:[[fileObject thumbnail] data]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:[dragView bounds]];
        [dragView addSubview:imageView];
        
        // animate dragview to show it has been grabbed
        CGAffineTransform transform = [dragView transform];
        transform = CGAffineTransformMakeScale(1.15, 1.15);
        CGFloat alpha = 0.75;
        
        [UIView animateWithDuration:0.2 
                         animations:^{

                                 [dragView setTransform:transform];
                                 [dragView setAlpha:alpha];
                         }];
       
        
        // current center
        CGPoint center = [[delegate view] convertPoint:[targetView center] fromView:[targetView superview]];
        
        // keep track of offset while dragging
        xOffset = point.x - center.x;
        yOffset = point.y - center.y;
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {        
        // move the view to recreate the offset 
        CGPoint newCenter = CGPointMake(point.x - xOffset, point.y - yOffset);
        
        [dragView setCenter:newCenter];
               
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        __weak id weakSelf = self;
        int position =[viewLayout insertThumbnail:dragView completion:^{
                            [UIView animateWithDuration:0.3 
                                              animations:^{
                                                  ThumbnailDragController *strongSelf = weakSelf;
                                                  if (strongSelf)
                                                  {
                                                      [dragView setTransform:CGAffineTransformIdentity];
                                                      [dragView setAlpha:1.0];
                                                  }
                                              }];
                        }];
        
        // it wasn't inserted so throw away the dragView
        if (position == -1)
        {
            [dragView removeFromSuperview];
        }
        
    }
}

- (CGRect)frameOnStandForPosition:(int)position
{
    CGRect frame = [dragView frame];
    
    frame.origin.x = frame.size.width * position;
    
    frame.origin.y = 6;
    
    return frame;
}
@end
