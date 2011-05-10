//
//  myMusicStandTests.m
//  myMusicStandTests
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "myMusicStandTests.h"
#import "myMusicStandAppDelegate.h"

@implementation myMusicStandTests

- (void)setUp
{
    [super setUp];
    delegate = [myMusicStandAppDelegate sharedInstance];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testDelegateExists
{
    STAssertNotNil(delegate, @"The App Delegate should exist");
}
@end
