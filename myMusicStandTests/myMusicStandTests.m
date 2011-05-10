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
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testDelegateExists
{
    myMusicStandAppDelegate *delegate = [myMusicStandAppDelegate sharedInstance];
    STAssertNotNil(delegate, @"The App Delegate should exist");
}
@end
