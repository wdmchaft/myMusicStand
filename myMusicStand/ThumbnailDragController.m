
#import "ThumbnailDragController.h"
#import "StageViewController.h"
#import "BlockTableController.h"
#import "FileTableController.h"
#import "File.h"
#import "Setlist.h"
#import "Thumbnail.h"
#import "myMusicStandAppDelegate.h"

#define THUMBNAIL_LEFT_PADDING 10
#define THUMBNAIL_TOP_PADDING 6
#define THUMBNAIL_WIDTH 162
#define THUMBNAIL_HEIGHT 201
#define MIN_SCROLLVIEW_CONTENT_WIDTH 769
#define SCROLLVIEW_CONTENT_HEIGHT 252

@implementation ThumbnailDragController
{
    // Offsets in dragged view
    CGFloat xOffset;
    CGFloat yOffset;
    __block UIView *dragView;
    File *fileBeingDragged;
    
    StageViewController *__weak delegate;
    UIScrollView *__weak backOfStand;
    NSManagedObjectContext *setlistContext;
    Setlist *newSetlist;
    UIView *targetView;


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
        
        backOfStand = [delegate backOfStand];
        

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

- (void)addFileToSetlistAndUpdateView
{
    if (!CGRectContainsPoint([backOfStand frame], [dragView center]))
    {
        [dragView removeFromSuperview];
        return;
    }
    
    int lastPossiblePosition = [[newSetlist orderedFiles] count];
    
    CGRect newFrame = [self frameForPosition:lastPossiblePosition];
    
    // Async add file to setlist
    [setlistContext performBlock:^{
        // Get the file in terms of this context
        File *fileInSetlistContext = (File *)[setlistContext objectWithID:[fileBeingDragged objectID]];
        [newSetlist insertFile:fileInSetlistContext 
                      forIndex:lastPossiblePosition 
                     inContext:setlistContext];
    }];
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    // Animate the frame
    [UIView animateWithDuration:0.2
                     animations:^{
                         [dragView setFrame:newFrame];
                     }
                     completion:^(BOOL finished){
                         // Work for main queue
                         dispatch_async(mainQueue, ^{
                             
                             [backOfStand addSubview:dragView];
                             
                             // Grow the content size to show all the thumbnails
                             CGSize newContentSize = CGSizeMake(MIN_SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
                             newContentSize.width = (THUMBNAIL_WIDTH + THUMBNAIL_LEFT_PADDING) + newFrame.origin.x;
                             
                             if (newContentSize.width <= MIN_SCROLLVIEW_CONTENT_WIDTH)
                             {
                                 newContentSize.width = MIN_SCROLLVIEW_CONTENT_WIDTH;
                             }
                             [backOfStand setContentSize:newContentSize];
                             
                         });
                         
                         
                         
                         // Remove any existing gesture recognizers
                         for (UIGestureRecognizer *recognzier in [dragView gestureRecognizers])
                         {
                             [dragView removeGestureRecognizer:recognzier];
                         }
                         
                         // Create a gesture recognizer and add it to thumbnail
                         UIGestureRecognizer *recognizer = 
                         [[UILongPressGestureRecognizer alloc] initWithTarget:self     
                                                                       action:@selector(handleReordering:)];
                         
                         [dragView addGestureRecognizer:recognizer];
                         
                         [UIView animateWithDuration:0.2 
                                          animations:^{
                                              [dragView setTransform:CGAffineTransformIdentity];
                                              [dragView setAlpha:1.0];
                                          }];
                         
                     }];
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
        fileBeingDragged = [(FileTableController *)blockController fileForBlock:targetView];
        UIImage *image = [[UIImage alloc] initWithData:[[fileBeingDragged thumbnail] data]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:[dragView bounds]];
        [dragView addSubview:imageView];
        
        [self makeDragViewAppearGrabbed];       
        
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
        [self addFileToSetlistAndUpdateView];

        
    }
}

- (void)makeDragViewAppearGrabbed
{
    // animate dragview to show it has been grabbed
    CGAffineTransform transform = [dragView transform];
    transform = CGAffineTransformMakeScale(1.15, 1.15);
    CGFloat alpha = 0.75;
    
    [UIView animateWithDuration:0.2 
                     animations:^{
                         
                         [dragView setTransform:transform];
                         [dragView setAlpha:alpha];
                     }];
}

- (void)handleReordering:(UILongPressGestureRecognizer *)recognizer
{
    targetView = [recognizer view];
    
    // touched point
    CGPoint point = [recognizer locationInView:[delegate view]];
    
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        [[delegate view] addSubview:targetView];
        
        dragView = targetView;
        
        // current center
        CGPoint center = [[delegate view] convertPoint:[targetView center] fromView:[targetView superview]];
        
        // keep track of offset while dragging
        CGPoint offset = [[delegate backOfStand] contentOffset];
        
        // make center offset from content offset in scrollview
        center.x -= offset.x;
        center.y -= offset.y;
        
        [dragView setCenter:center];
        
        // keep track of x and y offsets
        xOffset = point.x - center.x;
        yOffset = point.y - center.y;
        
        [self makeDragViewAppearGrabbed];
        

    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {        
        // move the view to recreate the offset 
        CGPoint newCenter = CGPointMake(point.x - xOffset, point.y - yOffset);
        
        [dragView setCenter:newCenter];
        
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        [self addFileToSetlistAndUpdateView];        
    }

}

- (CGRect)frameForPosition:(int)position
{
    CGRect frame = CGRectMake(0, THUMBNAIL_TOP_PADDING, THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT);
    
    CGFloat offset = (THUMBNAIL_LEFT_PADDING * (position + 1)) + position * frame.size.width;
    
    frame.origin.x = offset;
    
    return frame;
}
@end
