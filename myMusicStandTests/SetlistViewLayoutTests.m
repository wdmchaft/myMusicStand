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
    UIScrollView *scrollView;
    
}

- (void)setUp
{
    [super setUp];
    
    // Create nice mock
    mockScrollView = [OCMockObject niceMockForClass:[UIScrollView class]];
    CGRect mockFrame = CGRectMake(0, 0, 768, 252);
    [[[mockScrollView stub] andReturnValue:[NSValue valueWithCGRect:mockFrame]] frame];
    
    layout = [[SetlistViewLayout alloc] initWithScrollView:mockScrollView];
    thumbnail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 162, 201)];
}

- (void)testThumbnailInsertionIntoLayoutAndScrollView
{    
    [[mockScrollView expect] addSubview:thumbnail];
    
    // check that it has the proper layout
    STAssertEquals(0, [layout insertThumbnail:thumbnail], @"Thumbnail postion should be correct");

    // wait for animation completion due to it's async nature
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    
    STAssertEquals([layout frameForPosition:0], [thumbnail frame], @"Make sure thumbnail's frame has been set");
    [mockScrollView verify];
    
}

// NOTE: this test require simulator orientation to be portrait
- (void)testScrollViewContentSizeGrowsToShowSubviews
{
    [[mockScrollView stub] setContentSize:CGSizeMake(768, 252)];
    
    // Add 4 thumbnails 
    for (int i = 0; i < 5; i++)
    {
        thumbnail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 162, 201)];
        [layout insertThumbnail:thumbnail];
    }
    
    [[mockScrollView expect] setContentSize:CGSizeMake(870, 252)];
    [layout insertThumbnail:thumbnail];
    
    // wait to complete animations
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    
    [mockScrollView verify];
}

- (void)testThumbnailWithCenterNotInScrollViewIsNotInserted
{
    // Make thumbnail no where near scrollview
    [thumbnail setCenter:CGPointMake(1000, 1000)];
    
    STAssertEquals(-1, [layout insertThumbnail:thumbnail], 
                   @"Thumbnail should not have been inserted");
}
- (void)testFrameForPosition
{
    STAssertEquals(CGRectMake(10, 6, 162, 201), [layout frameForPosition:0], @"Frame should be correct");
    STAssertEquals(CGRectMake(182, 6, 162, 201), [layout frameForPosition:1], @"Frame should be correct");
}
@end
