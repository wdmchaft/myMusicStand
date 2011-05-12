//
//  SetupTests.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetupTests.h"


@implementation SetupTests

- (void)setUp
{
    [super setUp];
    yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)tearDown
{
    [super tearDown];
}
- (void)testAppDelegate 
{
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
}

- (void)testWindowSubview
{
    UIWindow *window = [yourApplicationDelegate window];
    STAssertEquals(1, (NSInteger)[[window subviews] count], 
                   @"The window shoud have 1 subview but it had %lu", [[window subviews] count]);
    
    UIView *subview;
    STAssertNoThrow(subview = [[window subviews] objectAtIndex:0], 
                    @"Accessing the subview should be valid");
}
@end
