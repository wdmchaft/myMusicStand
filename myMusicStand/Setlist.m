//
//  Setlist.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Setlist.h"
#import "File.h"
#import "OrderedFile.h"

@implementation Setlist
@dynamic orderedFiles;

- (void)addOrderedFilesObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"orderedFiles" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"orderedFiles"] addObject:value];
    [self didChangeValueForKey:@"orderedFiles" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeOrderedFilesObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"orderedFiles" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"orderedFiles"] removeObject:value];
    [self didChangeValueForKey:@"orderedFiles" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addOrderedFiles:(NSSet *)value {    
    [self willChangeValueForKey:@"orderedFiles" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"orderedFiles"] unionSet:value];
    [self didChangeValueForKey:@"orderedFiles" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeOrderedFiles:(NSSet *)value {
    [self willChangeValueForKey:@"orderedFiles" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"orderedFiles"] minusSet:value];
    [self didChangeValueForKey:@"orderedFiles" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

+ (Setlist *)setlistWithContext:(NSManagedObjectContext *)moc
{
    Setlist *set =  [NSEntityDescription insertNewObjectForEntityForName:@"Setlist"
                                                  inManagedObjectContext:moc];
    [set setTimestamp:[NSDate date]];
    return set;
}

- (void)removeFileAtIndex:(NSInteger)index inContext:(NSManagedObjectContext *)moc
{
    NSArray *files = [self orderedFilesInOrder];
    
    // Remove the file at the index
    OrderedFile *file = [files objectAtIndex:index];
    [self removeOrderedFilesObject:file];
    [moc deleteObject:file];
    
    for (int i = (int)index; i < [files count]; i++)
    {
        OrderedFile *currentFile = [files objectAtIndex:index];
        int currentIndex = [[currentFile index] intValue];
        int newIndex = currentIndex - 1; // increment
        [currentFile setIndex:[NSNumber numberWithInteger:newIndex]];
    }
    
}

- (void)insertFile:(File *)afile forIndex:(NSInteger)index inContext:(NSManagedObjectContext *)moc
{
    // Get the current orderedFiles in the setlist
    NSArray *files = [self orderedFilesInOrder];
    
    if (index > [files count])
    {
        @throw @"Illegal insert: the index is not valid";
    }
    
    // Create a new orderedFile and assign the index
    OrderedFile *orderedFile = [OrderedFile orderedFileWithContext:moc];
    [orderedFile setIndex:[NSNumber numberWithInteger:index]];
    
    // Loop through the ordered files starting at the index we are inserting into
    // and add 1 to each index to make room
    for (int i = (int)index; i < [files count]; i++)
    {
        OrderedFile *currentFile = [files objectAtIndex:index];
        int currentIndex = [[currentFile index] intValue];
        int newIndex = currentIndex + 1; // increment
        [currentFile setIndex:[NSNumber numberWithInt:newIndex]];
    }
    
    // Set relationships
    [orderedFile setFile:afile];
    [afile addOrderedFilesObject:orderedFile];
    [self addOrderedFilesObject:orderedFile];
}

// Return orderedFiles sorted by index
- (NSArray *)orderedFilesInOrder
{
    NSArray *files = [[self orderedFiles] allObjects];
    // Sort files based on index
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    return [files sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];   
}

- (NSArray *)filesInOrder
{
    NSMutableArray *filesInOrder = [[NSMutableArray alloc] init];
    NSArray *files = [self orderedFilesInOrder];
    
    for (OrderedFile *ordFile in files)
    {
        // Add the file that is represented by the ordering entity to the array
        [filesInOrder addObject:[ordFile file]];
    }
    
    return [filesInOrder autorelease];
}

@end
