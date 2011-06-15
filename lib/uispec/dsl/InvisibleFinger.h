//
//  InvisibleFinger.h
//  UISpec
//
//  This class wraps gesture performing functionality, it 
//  allows for a VisibleTouch to be displayed as well as the handling of
//  backend event calls to gesture recognizers for it's targetView
//  
//  Created by Steve Solomon on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvisibleFinger : NSObject
{
    CGPoint point; 
    UIView *targetView;
}

// Designated Initializer
- (id)initWithPoint:(CGPoint)aPoint andTarget:(UIView *)view;

// Be aware point's default initialization is (0,0) 
@property (nonatomic, readonly) CGPoint point;
@property (nonatomic, retain) UIView *targetView;

// Performs touch event (for internal use only do not call directly)
- (void)performEvent:(UIEvent *)aEvent withTouch:(UITouch *)touch;
// Performs Gestures contained within
- (void)performGestures;
@end
