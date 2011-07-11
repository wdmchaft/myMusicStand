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
@dynamic thumbnail;

- (void)addOrderedFilesObject:(OrderedFile *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"orderedFiles" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"orderedFiles"] addObject:value];
    [self didChangeValueForKey:@"orderedFiles" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
}

- (void)removeOrderedFilesObject:(OrderedFile *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"orderedFiles" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"orderedFiles"] removeObject:value];
    [self didChangeValueForKey:@"orderedFiles" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
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

- (void)setFilename:(NSString *)newFilename
{
    [self willChangeValueForKey:@"filename"];
    [self setPrimitiveValue:newFilename forKey:@"filename"];
    // if the alias hasn't been set by default we will set it 
    // to the filename
    [self willAccessValueForKey:@"alias"];
    // if the alias is null 
    if (![self valueForKey:@"alias"])
    {
        [self willChangeValueForKey:@"alias"];
        [self setPrimitiveValue:newFilename forKey:@"alias"];
        [self didChangeValueForKey:@"alias"];
    }
    [self didAccessValueForKey:@"alias"];
    [self didChangeValueForKey:@"filename"];
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
