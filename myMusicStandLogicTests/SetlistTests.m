//
//  SetlistTests.m
//  PDFPrototyping
//
//  Created by Steve Solomon on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetlistTests.h"
#import "Setlist.h"
#import "OrderedFile.h"
#import "File.h"

@implementation SetlistTests

- (void)setUp
{
    [super setUp];
    file = [File fileWithContext:context];
    file2 = [File fileWithContext:context];
    set = [Setlist setlistWithContext:context];
}

- (void)tearDown
{
    // Tear-down code here.
    [context deleteObject:file];
    [context deleteObject:file2];
    [context deleteObject:set];
    [super tearDown];
}

- (void)testSetlistSetup
{
    STAssertTrue([file isKindOfClass:[File class]], @"The file should be a file class");
    STAssertTrue([file2 isKindOfClass:[File class]], @"The file2 should be a file class");
    STAssertTrue([set isKindOfClass:[Setlist class]], @"The setlist should be the setlist class");
}

- (void)testInsertFileAtOrderedIndex
{
    [set insertFile:file forIndex:0 inContext:context];
    [set insertFile:file2 forIndex:0 inContext:context];
    [set insertFile:file forIndex:1 inContext:context];
    [set insertFile:file2 forIndex:1 inContext:context];
    NSArray *files = [NSArray arrayWithObjects:file2, file2, file, file, nil];
    STAssertEqualObjects(files, [set filesInOrder], @"The files should be in the correct order");
}

- (void)testRemovingOrderedFileAtIndex
{
    [set insertFile:file forIndex:0 inContext:context];
    [set insertFile:file2 forIndex:1 inContext:context];
    [set removeFileAtIndex:0 inContext:context];
    NSArray *files = [NSArray arrayWithObject:file2];
    STAssertEqualObjects(files, [set filesInOrder], @"The files should show that file at index 0 has been removed");
}

- (void)testRemovalOfDeletedFileFromAllSets
{
    Setlist *set2 = [Setlist setlistWithContext:context];
    [set insertFile:file forIndex:0 inContext:context];
    [set2 insertFile:file forIndex:0 inContext:context];
    [context deleteObject:file];
    [context save:nil];
    NSArray *files = [set filesInOrder];
    NSArray *files2 = [set2 filesInOrder];
    STAssertFalse([files containsObject:file] && [files2 containsObject:file], 
                  @"The files in the second and first setlist shouldn't contain the deleted file");
    
}

- (void)testRemoveOrderedFileDoesntRemoveFile
{
    [set insertFile:file forIndex:0 inContext:context];
    [set removeFileAtIndex:0 inContext:context];
    STAssertNotNil(file, @"File should still exist, after a OrderedFile related to it was removed");
}

- (void)testInsertRemoveFileTrickyTest
{
    // A series of operations to guarentee that the ordering system works
    [set insertFile:file forIndex:0 inContext:context];
    [set insertFile:file forIndex:0 inContext:context];
    [set removeFileAtIndex:1 inContext:context];
    [set insertFile:file2 forIndex:1 inContext:context];
    [set removeFileAtIndex:0 inContext:context];
    [set insertFile:file forIndex:0 inContext:context];
    [set removeFileAtIndex:0 inContext:context];
    [set insertFile:file forIndex:0 inContext:context];
    [set insertFile:file forIndex:0 inContext:context];
    [set removeFileAtIndex:1 inContext:context];
    NSArray *files = [NSArray arrayWithObjects:file, file2, nil];
    STAssertEqualObjects(files, [set filesInOrder], @"The files should be in the correct order");
}

- (void)testFileStillExistsAfterOrderedFileRemoval
{
    [set insertFile:file forIndex:0 inContext:context];
    [set removeFileAtIndex:0 inContext:context];
    STAssertNotNil(file, @"File shouldn't be nil");
    STAssertNoThrow([file filename], @"The message should not throw an exception");
}

- (void)testOrderedFileRemovedFromFileRelationship
{
    [set insertFile:file forIndex:0 inContext:context];
    [set removeFileAtIndex:0 inContext:context];
    [context save:nil];
    STAssertNil([[file orderedFiles] anyObject], 
                @"The file should be invalid now that it was removed");
}

- (void)testRemovingFileAtIllegalIndex
{
    STAssertThrows([set removeFileAtIndex:0 inContext:context], @"An illegal index exception should be thrown");
}

- (void)testInsertFileAtIllegalIndex
{
    STAssertThrows([set insertFile:file forIndex:1 inContext:context], @"An illegal index exception should be thrown");
}

- (void)testSetlistCreationOrder
{
    Setlist *set3 = [Setlist setlistWithContext:context];
    Setlist *set5 = [Setlist setlistWithContext:context];
    Setlist *set4 = [Setlist setlistWithContext:context];
    Setlist *set2 = [Setlist setlistWithContext:context];
    NSArray *sets = [NSArray arrayWithObjects:set, set3, set5, set4, set2, nil];
    STAssertEqualObjects(sets, [context allEntity:@"Setlist"],
                         @"The setlists should be in the order they were created");
}
@end
