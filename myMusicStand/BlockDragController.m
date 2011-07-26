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
#import "Thumbnail.h"

@implementation BlockDragController
{
    // Offsets in dragged view
    CGFloat xOffset;
    CGFloat yOffset;
    UIView *dragView;
    
    StageViewController *__weak delegate;
}

- (id)initWithStageViewController:(StageViewController *)aDelegate
{
    self = [super init];
    if (self) {
        delegate = aDelegate;
    }
    
    return self;
}

- (SEL)dragEvenHandler
{
    return @selector(handleLongPress:);
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    UIView *targetView = [recognizer view];
    
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
        [dragView removeFromSuperview];
        dragView = nil;
    }
}

@end
