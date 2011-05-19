//
//  TimestampEntityTests.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimestampEntityTests.h"
#import "File.h"

@implementation TimestampEntityTests

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

- (void)testFileCreationOrder
{
    File *file = [File fileWithContext:context];
    File *file2 = [File fileWithContext:context];
    File *file5 = [File fileWithContext:context];
    File *file3 = [File fileWithContext:context];
    File *file4 = [File fileWithContext:context];
    NSArray *files = [NSArray arrayWithObjects:file, file2, file5, file3, file4, nil];
    STAssertEqualObjects(files, [context allEntity:@"File"],
                         @"The files should be in the order they were created");
}

@end
