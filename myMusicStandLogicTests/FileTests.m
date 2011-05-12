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
    STAssertEqualObjects([file filename], [file2 filename], @"Both files should be equal");
}

- (void)testLearningFilesArrayEqual
{
    [file2 setFilename:@"aFile2.pdf"];
    
    NSArray *array1 = [NSArray arrayWithObjects:file, file2, nil];
    NSArray *array2 = [NSArray arrayWithObjects:file, file2, nil];
    STAssertEqualObjects(array1, array2, @"The file arrays should be equal");
    NSArray *array3 = [NSArray arrayWithObjects:file, nil];
    STAssertFalse([array2 isEqual:array3], @"The file arrays shouldn't be equal");
    NSArray *array4 = [NSArray arrayWithObjects:file2, nil];
    STAssertFalse([array3 isEqual:array4], @"The file arrays shouldn't be equal");
}

- (void)testFileForFileWithSameName
{
    STAssertTrue(FilenameAvailable == [context checkAvailabilityOfFilename:@"File2.pdf"],
                 @"The filename should be available");
    STAssertTrue(FilenameNotAvailable == [context checkAvailabilityOfFilename:@"File1.pdf"],
                 @"The filename should be available");
    
}

- (void)testFileCreationOrder
{
    File *file5 = [File fileWithContext:context];
    File *file3 = [File fileWithContext:context];
    File *file4 = [File fileWithContext:context];
    NSArray *files = [NSArray arrayWithObjects:file, file2, file5, file3, file4, nil];
    STAssertEqualObjects(files, [context allEntity:@"File"],
                         @"The files should be in the order they were created");
}

- (void)testFileSettingTitle
{
    [file setAlias:@"a cool title"];
    STAssertEquals(@"a cool title", [file alias], @"The file's title should be set");
}

- (void)testDefaultAliasIsFilename
{
    STAssertEqualObjects([file filename], [file alias], 
                         @"The alias should be the filename if it is not set");
}
@end
