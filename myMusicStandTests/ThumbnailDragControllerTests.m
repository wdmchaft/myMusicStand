//
//  ThumbnailDragControllerTests.m
//  myMusicStand
//
//  Created by Steven Solomon on 8/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ThumbnailDragControllerTests.h"
#import "ThumbnailDragController.h"

@implementation ThumbnailDragControllerTests

- (void)testFrameForPosition
{
    ThumbnailDragController *controller = [[ThumbnailDragController alloc] init];
    STAssertEquals(CGRectMake(10, 6, 162, 201), [controller frameForPosition:0], @"Frame should be correct");
    STAssertEquals(CGRectMake(182, 6, 162, 201), [controller frameForPosition:1], @"Frame should be correct");
}
@end
