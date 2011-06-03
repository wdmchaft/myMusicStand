//
//  SetlistTableControllerTests.m
//  myMusicStand
//
//  Created by Steve Solomon on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetlistTableControllerTests.h"
#import "SetlistTableController.h"
#import <OCMock/OCMock.h>
#import <CoreData/CoreData.h>

@implementation SetlistTableControllerTests

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

- (void)testSetup
{
    id mockContext = [OCMockObject mockForClass:[NSManagedObjectContext class]];
    SetlistTableController *controller = 
        [[SetlistTableController alloc] initWithManagedObjectContext:mockContext];   
    STAssertNotNil(controller, @"Controller should have been setup");
}

- (void)testIllegalSetup
{
    STAssertThrows([[SetlistTableController alloc] init], @"Should be illegal");
}

@end
