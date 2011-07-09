//
//  SetupTests.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DelegateTests.h"
#import "myMusicStandAppDelegate.h"
#import "FileTableController.h"
#import "SetlistTableController.h"
#import "OCMock/OCMock.h"
#import "File.h"

@implementation DelegateTests

- (void)setUp
{
    [super setUp];
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Make appDelegate use our testing context 
    // instead of setting up it's own
    [appDelegate setManagedObjectContext:context];
    
    // Create file in our context 
    file = [File fileWithContext:context];
    [file setFilename:@"File1.pdf"];
    
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testAppDelegate 
{
    STAssertNotNil(appDelegate, @"UIApplication failed to find the AppDelegate");
}

- (void)testFileSharingOn
{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];

    STAssertEquals(YES, [[dict valueForKey:@"UIFileSharingEnabled"] boolValue], 
                   @"File sharing should be turned on");
}

- (void)testKnownFiles
{
    NSArray *expectedKnownFiles = [NSArray arrayWithObjects:@"File1.pdf", nil];
    STAssertEqualObjects(expectedKnownFiles, [appDelegate knownFileNames], 
                         @"The known files should return the files created");
}


@end
