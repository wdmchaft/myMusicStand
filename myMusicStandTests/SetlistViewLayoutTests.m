//
//  SetlistViewLayoutTests.m
//  myMusicStand
//
//  Created by Steven Solomon on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetlistViewLayoutTests.h"
#import "SetlistViewLayout.h"

@implementation SetlistViewLayoutTests

- (void)testThumbnailInsertionIntoLayout
{
    SetlistViewLayout *layout = [[SetlistViewLayout alloc] init];
    UIView *thumbnail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 162, 201)];
    
    // check that it has the proper layout
    STAssertEquals(0, [layout insertThumbnail:thumbnail], @"Thumbnail postion should be correct");
}

@end
