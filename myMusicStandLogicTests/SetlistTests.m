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

- (void)testInsertFilesAtOrderedIndex
{
    // insert files into setlist
    [set insertFile:file forIndex:0 inContext:context];
    [set insertFile:file2 forIndex:0 inContext:context];
    [set insertFile:file forIndex:1 inContext:context];
    [set insertFile:file2 forIndex:1 inContext:context];
    NSArray *files = [NSArray arrayWithObjects:file2, file2, file, file, nil];
    
    // Verify files are in correct order
    STAssertEqualObjects(files, [set filesInOrder], @"The files should be in the correct order");
}

- (void)testRemovingOrderedFileAtIndex
{
    // Insert files 
    [set insertFile:file forIndex:0 inContext:context];
    [set insertFile:file2 forIndex:1 inContext:context];
    
    // Remove first file
    [set removeFileAtIndex:0 inContext:context];
    NSArray *files = [NSArray arrayWithObject:file2];
    
    // Verify removal
    STAssertEqualObjects(files, [set filesInOrder], @"The files should show that file at index 0 has been removed");
}

- (void)testRemovalOfDeletedFileFromAllSets
{
    // Create a second setlist
    Setlist *set2 = [Setlist setlistWithContext:context];
    
    // Insert the same file in both setlists
    [set insertFile:file forIndex:0 inContext:context];
    [set2 insertFile:file forIndex:0 inContext:context];
    
    // delete the file and save the change 
    [context deleteObject:file];
    [context save:nil];
    
    // Get the files back from the setlist
    NSArray *files = [set filesInOrder];
    NSArray *files2 = [set2 filesInOrder];
    
    // Verify both setlists don't have the file
    STAssertFalse([files containsObject:file] && [files2 containsObject:file], 
                  @"The files in the second and first setlist shouldn't contain the deleted file");
    
}

- (void)testRemoveOrderedFileDoesntRemoveFile
{
    // Insert file into postion 0
    [set insertFile:file forIndex:0 inContext:context];
    // Remove that file
    [set removeFileAtIndex:0 inContext:context];
    
    // Verify file still exists after removal from setlist
    STAssertNotNil(file, @"File should still exist, after a OrderedFile related to it was removed");
}

- (void)testInsertRemoveFileTrickyTest
{
    // A series of operations to guarentee that the ordering system works
    // Here we are trying to stress the system, almost like having a two year old pound on it
    // below we state the expected state after eache pair of opperations 
    
    [set insertFile:file forIndex:0 inContext:context];
    [set insertFile:file forIndex:0 inContext:context];
    // state: {file, file}

    [set removeFileAtIndex:1 inContext:context];
    [set insertFile:file2 forIndex:1 inContext:context];
    // state: {file, file2}

    [set removeFileAtIndex:0 inContext:context];
    [set insertFile:file forIndex:0 inContext:context];
    // state: {file, file2}
    
    [set removeFileAtIndex:0 inContext:context];
    [set insertFile:file forIndex:0 inContext:context];
    // state: {file, file2}
    
    [set insertFile:file forIndex:0 inContext:context];
    // state: {file, file, file2}
    
    [set removeFileAtIndex:1 inContext:context];
    // state: {file, file2}

    NSArray *files = [NSArray arrayWithObjects:file, file2, nil];
    
    // make sure files are in correct order
    STAssertEqualObjects(files, [set filesInOrder], @"The files should be in the correct order");
}

- (void)testOrderedFileRemovedFromFileRelationship
{
    // implicitly creates an orderedFile
    [set insertFile:file forIndex:0 inContext:context];
    [set removeFileAtIndex:0 inContext:context];
    [context save:nil];
    
    // verify the ordered file behind the scenes is gone
    STAssertNil([[file orderedFiles] anyObject], 
                @"The file should be invalid now that it was removed");
}

- (void)testRemovingFileAtIllegalIndex
{
    // Make sure we can't remove from non existent indeces
    STAssertThrows([set removeFileAtIndex:0 inContext:context], @"An illegal index exception should be thrown");
}

- (void)testInsertFileAtIllegalIndex
{
    // Make sure we can't insert to non existent indeces
    STAssertThrows([set insertFile:file forIndex:1 inContext:context], @"An illegal index exception should be thrown");
}

@end
