//
//  Path.m
//  UISpec
//
//  Created by Steve Solomon on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Path.h"

@implementation Path

@synthesize startPoint;
@synthesize endPoint;
@synthesize slope;
@synthesize distance;
@synthesize midPoint;
@synthesize yIntercept;
@synthesize stepSize;

- (id)init
{
    @throw @"Illegal init method use: initWithPoint1:point2";
}

- (id)initWithStartPoint:(CGPoint)start endPoint:(CGPoint)end;
{
    if (self = [super init])
    {
        startPoint = start;
        endPoint = end;
        slope = (end.y - start.y) / (end.x - start.x);
        distance = sqrtf(powf((end.x - start.x), 2) + powf((end.y - start.y), 2));
        midPoint = CGPointMake((start.x + end.x) / 2 , (start.y + end.y) / 2);
        yIntercept = start.y - (slope * start.x);
        stepSize = 3;
    }
    
    return self;
}

- (NSArray *)points
{
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (int currentX = startPoint.x; currentX < endPoint.x; currentX += stepSize)
    {
        CGPoint newPoint = CGPointMake(currentX + stepSize, (slope * (currentX + stepSize)) + yIntercept);
        [points addObject:[NSValue valueWithCGPoint:newPoint]];
    }
    
    [points autorelease];
    
    // return immutable copy
    return [[points copy] autorelease];
}
@end
