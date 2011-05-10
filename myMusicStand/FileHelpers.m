/*
 *  FileHelpers.m
 *  Homepwner
 *
 *  Created by Steve Solomon on 1/29/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "FileHelpers.h"

NSArray *filesDiffWithFileslistAndKnownFiles(NSArray *filesInDirectory, NSArray *knownFiles, FileDiffType type)
{
    // Results of diff operation
    NSSet *resultsSet = nil;
    
    // Mutable Sets to use to generate diffs
    NSMutableSet *diffKnownSet = [[[NSSet setWithArray:knownFiles] mutableCopy] autorelease];
    NSMutableSet *diffActualFilesSet = [[[NSSet setWithArray:filesInDirectory] mutableCopy] autorelease];
    // Immutable Sets to use to diff against
    NSSet *actualFilesSet = [NSSet setWithArray:filesInDirectory];
    NSSet *knownFilesSet = [NSSet setWithArray:knownFiles];
    
    // Descriptor to sort results array
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@""
                                                           ascending:NO 
                                                            selector:@selector(caseInsensitiveCompare:)];
    NSArray *descriptors = [NSArray arrayWithObject:sort];
    
    if (type == FileDiffTypeNew)
    {
        [diffActualFilesSet minusSet:knownFilesSet];
        resultsSet = diffActualFilesSet;
    }
    else if (type == FileDiffTypeStale)
    {
        [diffKnownSet minusSet:actualFilesSet];
        resultsSet = diffKnownSet;
    }    

    
    return [[resultsSet allObjects] sortedArrayUsingDescriptors:descriptors];
}
