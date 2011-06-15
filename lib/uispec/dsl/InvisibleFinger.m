//
//  InvisibleFinger.m
//  UISpec
//
//  Created by Steve Solomon on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InvisibleFinger.h"
#import "VisibleTouch.h"
#import "TouchSynthesis.h"
#import "EventSynthesis.h"

@implementation InvisibleFinger

@synthesize point;
@synthesize targetView;

- (id)init
{
    @throw @"Illegal instantiation use initWithPoint instead";
}

- (id)initWithPoint:(CGPoint)aPoint andTarget:(UIView *)view
{
    if (self = [super init]) 
    {
        point = aPoint;
        [self setTargetView:view];
    }
    
    return self;
}

// Helper method to abstract sending event messages to all recognizers for our target view
- (void)sendSelector:(SEL)selector withEvent:(UIEvent *)event andTouches:(NSSet *)touches
{
    // Send event to the gesture recognizers
    for (UIGestureRecognizer *recognizer in [targetView gestureRecognizers])
    {
        // Sure this is ugly but compiler warnings are uglier
        [recognizer performSelector:selector 
                         withObject:touches 
                         withObject:event];
    }

}
- (void)performEvent:(UIEvent *)event withTouch:(UITouch *)touch
{
    NSSet *touches = [[NSSet alloc] initWithObjects:&touch count:1];
    
    // Display a visible touch on screen
    CGPoint convertedPoint = [[targetView superview] convertPoint:point fromView:targetView];
    VisibleTouch *visibleTouch = [[VisibleTouch alloc] initWithCenter:convertedPoint];
    [[targetView superview] addSubview:visibleTouch];
    [[targetView superview] bringSubviewToFront:visibleTouch];
     
    // Display 
    // Send begining event
    [self sendSelector:@selector(touchesBegan:withEvent:) withEvent:event andTouches:touches];
    [targetView touchesBegan:touches withEvent:event];

    // Change touch phase
    [touch setPhase:UITouchPhaseEnded];
    
    // Pause to allow for touch to be seen
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, .25, false);
    
    // Send ending event
    [self sendSelector:@selector(touchesEnded:withEvent:) withEvent:event andTouches:touches];
    [targetView touchesEnded:touches withEvent:event];
    
    [visibleTouch removeFromSuperview];
    [visibleTouch release];
    [touches release];
}

- (void)performGestures
{
    // Create touch and event
    UITouch *touch = [[UITouch alloc] initInView:targetView 
                                          xcoord:(int)point.x 
                                          ycoord:(int)point.y];
    
    UIEvent *event = [[NSClassFromString(@"UITouchesEvent") alloc] initWithTouch:touch];
    
    [self performEvent:event withTouch:touch];
    
    [touch release];
    [event release];
}

@end
