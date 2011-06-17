//
//  Path.h
//  UISpec
//
//  Class to wrap solving of gesture path equation
//  for now we only support a simple linear path but who 
//  knows about the future =)
//
//  Created by Steve Solomon on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Path : NSObject
{
    CGPoint startPoint;
    CGPoint endPoint;
    int slope;
    int distance;
    CGPoint midPoint;
    int yIntercept;
    int stepSize; // default size is 3
}

// Desginated Initializer
- (id)initWithStartPoint:(CGPoint)start endPoint:(CGPoint)end;

@property (nonatomic, readonly) CGPoint startPoint;
@property (nonatomic, readonly) CGPoint endPoint;
@property (nonatomic, readonly) int slope;
@property (nonatomic, readonly) int distance;
@property (nonatomic, readonly) CGPoint midPoint;
@property (nonatomic, readonly) int yIntercept;
@property (nonatomic, assign) int stepSize;

- (NSArray *)points; // All the points in the path incrementally using stepSize
@end
