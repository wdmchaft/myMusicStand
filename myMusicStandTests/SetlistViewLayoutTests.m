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
    __block BOOL wasCompleted; // used to make sure completion on insertion is called
    
    SetlistViewLayout *layout; // SUT
    UIView *thumbnail; // thumbnail to be used in testing
    id mockScrollView; // mocking fixture
    
}

- (void)setUp
{
    [super setUp];
    wasCompleted = NO;
    
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
    
    [mockScrollView verify];
}

- (void)testCompletionForInsert
{
    __weak id weakSelf = self;
    
    // insert the thumbnail with completion
    [layout insertThumbnail:thumbnail completion:^{
        SetlistViewLayoutTests *strongSelf = weakSelf;
        if (strongSelf)
        {
            wasCompleted = YES;
        }
    }];
    
    STAssertEquals(YES, wasCompleted, @"Completion block should have been called");
}
@end
