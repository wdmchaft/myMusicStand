//
//  File.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "File.h"
#import "OrderedFile.h"


@implementation File
@dynamic filename;
@dynamic orderedFiles;
@dynamic alias;

- (void)addOrderedFilesObject:(OrderedFile *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"orderedFiles" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"orderedFiles"] addObject:value];
    [self didChangeValueForKey:@"orderedFiles" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeOrderedFilesObject:(OrderedFile *)value {
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

+ (File *)fileWithContext:(NSManagedObjectContext *)moc
{
    File *file = [NSEntityDescription insertNewObjectForEntityForName:@"File"
                                               inManagedObjectContext:moc];
    [file setTimestamp:[NSDate date]];
    return file;
}

@end

@implementation NSManagedObjectContext (FilenameAvailabilityCheck)

- (FilenameAvailability)checkAvailabilityOfFilename:(NSString *)filename
{
    // Construct a request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // Set target entity
    [request setEntity:[NSEntityDescription entityForName:@"File"
                                   inManagedObjectContext:self]];
    // Setup the predicate
    NSPredicate *predicate = 
    [NSPredicate predicateWithFormat:@"filename == %@", filename];
    [request setPredicate:predicate];
    
    NSArray *results = [self executeFetchRequest:request error:nil];
    
    if ([results count] > 0)
    {
        return FilenameNotAvailable;
    }
    
    return FilenameAvailable;
}
@end
