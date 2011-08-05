//
//  SetlistViewLayoutTests.m
//  myMusicStand
//
//  Created by Steven Solomon on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetlistViewLayoutTests.h"
#import <OCMock/OCMock.h>
#import "SetlistViewLayout.h"

@implementation SetlistViewLayoutTests
{
    SetlistViewLayout *layout; // SUT
    UIView *thumbnail; // thumbnail to be used in testing
    id mockScrollView; // mocking fixture
    
}

- (void)setUp
{
    [super setUp];
    
    // Create partial mock
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 768, 252)];
    mockScrollView = [OCMockObject partialMockForObject:scrollView];
    
    layout = [[SetlistViewLayout alloc] initWithScrollView:mockScrollView];
    thumbnail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 162, 201)];
}

- (void)testThumbnailInsertionIntoLayoutAndScrollView
{    
    [[mockScrollView expect] addSubview:thumbnail];
   
    // check that it has the proper layout
    STAssertEquals(0, [layout insertThumbnail:thumbnail completion:nil], @"Thumbnail postion should be correct");

    // wait for animation completion due to it's async nature
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    
    STAssertEquals([layout frameForPosition:0], [thumbnail frame], @"Make sure thumbnail's frame has been set");
    [mockScrollView verify];
    
}

- (void)testFrameForPosition
{
    STAssertEquals(CGRectMake(10, 6, 162, 201), [layout frameForPosition:0], @"Frame should be correct");
    STAssertEquals(CGRectMake(182, 6, 162, 201), [layout frameForPosition:1], @"Frame should be correct");
}
@end
