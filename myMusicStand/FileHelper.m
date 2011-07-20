/*
 *  FileHelpers.m
 *  Homepwner
 *
 *  Created by Steve Solomon on 1/29/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "FileHelper.h"

@implementation FileHelper

+ (NSArray *)diffForType:(FileDiffType)type forFilesInDir:(NSArray *)filesInDirectory andKnownFiles:(NSArray *)knownFiles
{
    // Results of diff operation
    NSSet *resultsSet = nil;
    
    // Mutable Sets to use to generate diffs
    NSMutableSet *diffKnownSet = [[NSSet setWithArray:knownFiles] mutableCopy];
    NSMutableSet *diffActualFilesSet = [[NSSet setWithArray:filesInDirectory] mutableCopy];
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
        
        // Create mutable copy of results
        NSMutableSet *mutableResultsSet = [resultsSet mutableCopy];
        
        // Check if the strings returned have anything that isn't a pdf
        for (NSString *fileName in resultsSet)
        {
            // if it isn't a pdf remove it from the list
            if (![fileName hasSuffix:@".pdf"])
            {
                [mutableResultsSet removeObject:fileName];
            }
        }
        
        // create an immutable copy that will only contain the pdfs type
        resultsSet = [mutableResultsSet copy];
        
    }
    else if (type == FileDiffTypeStale)
    {
        [diffKnownSet minusSet:actualFilesSet];
        resultsSet = diffKnownSet;
    }    
    
    
    return [[resultsSet allObjects] sortedArrayUsingDescriptors:descriptors];
}
@end

