//
//  BlockDragController.m
//  myMusicStand
//
//  Created by Steven Solomon on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BlockDragController.h"
#import "StageViewController.h"
#import "BlockTableController.h"
#import "FileTableController.h"
#import "File.h"
#import "Setlist.h"
#import "Thumbnail.h"
#import "myMusicStandAppDelegate.h"

/*
    Helper class that holds a thumbnail and its position
    this is used in a hash to allow us to get at the view
    and it's position so we can move them around easily
 */
@interface ThumbnailPositionPair : NSObject 

@property (nonatomic, strong) UIView *thumbnail;
@property (nonatomic, assign) int position;

@end

@implementation ThumbnailPositionPair
{
    UIView *thumbnail;
    int postion;
}

@synthesize thumbnail;
@synthesize position;

@end


@interface BlockDragController ()
#pragma mark Private Methods
- (CGRect)frameOnStandForPosition:(int)position;
- (void)relayoutThumbnails;
@end

@implementation BlockDragController
{
    // Offsets in dragged view
    CGFloat xOffset;
    CGFloat yOffset;
    __block UIView *dragView;
    
    StageViewController *__weak delegate;
    NSManagedObjectContext *setlistContext;
    Setlist *newSetlist;
    UIView *targetView;
    
    // Mapping of thumbnails to position
    NSMutableDictionary *thumbnailMapping;
    int intendedPosition; // where the user seems to want to place the dragView
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
        
        thumbnailMapping = [[NSMutableDictionary alloc] init];

    }
    
    return self;
}

- (SEL)dragEventHandler
{
    return @selector(handleLongPress:);
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
        
        // Hit test backOfStand with our center to see if we hit subviews
        UIView *hitThumbnail = [[delegate backOfStand] hitTest:newCenter withEvent:nil];
        
        // Check that we have a subview of the backOfStand
        if (hitThumbnail != [delegate backOfStand] && hitThumbnail != nil)
        {
            // Get the pair for the hitThumbnail
            ThumbnailPositionPair *pair = [thumbnailMapping valueForKey:[hitThumbnail description]]; 
            intendedPosition = [pair position];
           
            NSLog(@"Inteneded Position %d", intendedPosition);
        }
        else if (hitThumbnail == nil)
        {
            // default value is last position
            intendedPosition = [thumbnailMapping count];
            NSLog(@"Default used");
                    
        }
        
        [self relayoutThumbnails];
        
        
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        // hittest dragview with backOfStand 
        BOOL standContainsPoint = CGRectContainsPoint([[delegate backOfStand] frame], 
                                                      [dragView center]);
        
        if (standContainsPoint)
        {            
            //[[newSetlist orderedFiles] count]; // get the number of files in the set
            
            // determine where to show the dragView
            CGRect viewsFrame = [self frameOnStandForPosition:intendedPosition];
            
            // animate dragview back to normal
            [UIView animateWithDuration:0.2 
                             animations:^{
                                 [dragView setTransform:CGAffineTransformIdentity];
                                 [dragView setAlpha:1.0];
                                 [dragView setFrame:viewsFrame];
                             }
                             completion:^(BOOL finished)
                             {
                                 [[delegate backOfStand] addSubview:dragView];

                                 // add the thumbnail to the mapping
                                 ThumbnailPositionPair *pair = [[ThumbnailPositionPair alloc] init];
                                 [pair setThumbnail:dragView];
                                 [pair setPosition:intendedPosition];
                                 
                                 [thumbnailMapping setValue:pair
                                                     forKey:[dragView description]];

                                 dragView = nil;
                             }];
            
            // Add File to setlist
            File *file = [(FileTableController *)[delegate blockController] fileForBlock:targetView];
            // add the file object to the local context
            File *localContextFile = (File *)[setlistContext objectWithID:[file objectID]];
            // finally add the file to the setlist
            [newSetlist insertFile:localContextFile 
                          forIndex:intendedPosition
                         inContext:setlistContext];
            
        }
        else
        {
            [dragView removeFromSuperview];
        }
    }
}

/*
    Determines the frame within a music stand to give the appearence of ordering 
 
    @param index the position where the thumbnail will be placed visually on the stand
 
    @return the frame for the thumbnail to be displayed in 
 
 */
- (CGRect)frameOnStandForPosition:(int)position
{
    CGRect frame = [dragView frame];
    
    frame.origin.x = frame.size.width * position;
    
    frame.origin.y = 6;
    
    return frame;
}

/*
    Relayout the views in the backOfStand according to their position in the 
    mapping. After determining the new frame we animate the view to it
 */
- (void)relayoutThumbnails
{
    // Relayout subviews of the backOfStand, when we get the the hit position 
    // that thumbnail and each after it is moved one position right
    NSArray *pairs = [thumbnailMapping allValues];
    
    // Sort the array by each pair's position
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];
    pairs = [pairs sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];

    // Create a newMapping
    NSMutableDictionary *newMapping = [[NSMutableDictionary alloc] init];
    
    // Loop through pairs and move them to the correct position
    int i = 0;
    for (ThumbnailPositionPair *aPair in pairs)
    {
        // When i is the intended position of the the dragView 
        if (i >= intendedPosition)
        {
            [aPair setPosition:(i + 1)];
        }
        else
        {
            [aPair setPosition:i];
            
        }
        
        CGRect newFrame = [self frameOnStandForPosition:[aPair position]];
        UIView *thumbnail = [aPair thumbnail];
        

        [thumbnail setFrame:newFrame];
        
        // add the modified pair to the new mapping
        [newMapping setValue:aPair forKey:[thumbnail description]];
        i++;
    }
    
    // swap in the newMapping
    thumbnailMapping = newMapping;
}
@end
