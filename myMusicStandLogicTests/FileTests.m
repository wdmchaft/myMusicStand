//
//  FileTests.m
//  PDFPrototyping
//
//  Created by Steve Solomon on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileTests.h"
#import "File.h"

@implementation FileTests

- (void)setUp
{
    [super setUp];
    file = [File fileWithContext:context];
    [file setFilename:@"File1.pdf"];
    file2 = [File fileWithContext:context];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testFileSettingFilename
{
    STAssertEqualObjects(@"File1.pdf", [file filename], @"The filename property should be set");
}

- (void)testLearningFileWithSameNameAreEqual
{
    NSString *filename = @"File1.pdf";
    [file2 setFilename:filename];
    
    // Test comparing filenames
    STAssertEqualObjects([file filename], [file2 filename], @"Both files should be equal");
}

- (void)testFileForFileWithSameName
{
    STAssertTrue(FilenameAvailable == [context checkAvailabilityOfFilename:@"File2.pdf"],
                 @"The filename should be available");
    STAssertTrue(FilenameNotAvailable == [context checkAvailabilityOfFilename:@"File1.pdf"],
                 @"The filename should be available");
    
}

- (void)testFileSettingAlias
{
    // Verify file alias property
    [file setAlias:@"a cool title"];
    STAssertEquals(@"a cool title", [file alias], @"The file's title should be set");
}

- (void)testDefaultAliasIsFilename
{
    // Default filename and alias are the same
    STAssertEqualObjects([file filename], [file alias], 
                         @"The alias should be the filename if it is not set");
    
    // Test that Filename doesn't trample the alias if it has been set.
    [file setAlias:@"A cooler name"];
    [file setFilename:@"File1.pdf"];
    
    // Verify file alias has changed and filename hasn't overwritten the change
    STAssertFalse([[file filename] isEqual:[file alias]], 
                  @"The filename and alias shouldn't be equal");
}
@end
