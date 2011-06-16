//
//  StageViewControllerTests.m
//  myMusicStand
//
//  Created by Steve Solomon on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StageViewControllerTests.h"
#import "StageViewController.h"

@implementation StageViewControllerTests

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

- (void)testThreeFingerSwipeSetup
{
    StageViewController *controller = [[StageViewController alloc] initWithNibName:nil bundle:nil];
    UISwipeGestureRecognizer *recognizer = [controller horizontalSwipe];
    NSArray *recognizers = [[controller view] gestureRecognizers];
    
    STAssertNotNil(controller, @"Shouldn't be nil");
    STAssertNotNil(recognizer, @"Swipe recognizer");
    STAssertEquals(UISwipeGestureRecognizerDirectionLeft || UISwipeGestureRecognizerDirectionRight, 
                   [recognizer direction], @"should only be left or right");
    STAssertEquals(3, (int)[recognizer numberOfTouchesRequired] , @"The swipe should require 3 touches");
    STAssertTrue([recognizers containsObject:recognizer], @"The recognizer should have been added to our view");

}
@end
