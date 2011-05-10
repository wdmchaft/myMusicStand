//
//  myMusicStandTests.m
//  myMusicStandTests
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "myMusicStandTests.h"
#import "myMusicStandAppDelegate.h"
#import "FilesListTableViewController.h"

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

- (void)testViewIsTableView
{
    UIView *view = [[[delegate window] subviews] objectAtIndex:0];
    STAssertNotNil(view, @"The view must exist");
    STAssertTrue([view isKindOfClass:[UITableView class]], 
                 @"The view should be a UITableView");
}
- (void)testViewDelegate
{
    UITableView *view = [[[delegate window] subviews] objectAtIndex:0];
    FilesListTableViewController *aDelegate = [view delegate];
    STAssertNotNil(aDelegate,
                 @"The view's delegate should be filesListTableViewController");
}
@end
