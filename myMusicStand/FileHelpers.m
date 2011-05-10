/*
 *  FileHelpers.m
 *  Homepwner
 *
 *  Created by Steve Solomon on 1/29/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "FileHelpers.h"

NSString *pathInDocumentDirectory(NSString *fileName)
{
	// Get the list of document directories in sandbox
	NSArray *documentDirectories = 
		NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
											NSUserDomainMask, 
											YES);
	// Get one and only document directory from that list
	NSString *documentDirectory = [documentDirectories objectAtIndex:0];
	
	// Append passed in file name to that directory, return it
	return [documentDirectory stringByAppendingPathComponent:fileName];
}

NSArray *filesInDirectory(NSString *path)
{
    if ([@"Another Fake Directory" isEqual:path])
    {
        return [NSArray arrayWithObjects:@"New File.pdf", @"Second File.pdf", nil];
    }
    return [NSArray arrayWithObject:@"New File.pdf"];
    
}

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

// Increment the fileName in a way like OSX does with copy
NSString *incrementFileName(NSString *fileName)
{
    
    // Get extension and filename without extension
    NSString *extension = [fileName pathExtension];
    NSString *fileNameNoExtension = [fileName stringByDeletingPathExtension];
    
    // Split the parts of the file name around blank space
    NSMutableArray *parts = [[fileNameNoExtension componentsSeparatedByString:@" "] mutableCopy];
    
    // Since this is a copy the file should be 
    int copyNumber = 2;
    NSNumber *tempNum; // might hold the current number
    
    // We have more than 
    if ([parts count] > 1)
    {
        // Check to see if the last component is a number
        NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
        
        tempNum = [formatter numberFromString:[parts lastObject]];
        
        // If it was a number 
        if (tempNum)
        {
            copyNumber = [tempNum intValue] + 1;
        }
    }
    
    NSString *fileNumberString = [NSString stringWithFormat:@"%d", copyNumber];
    
    
    if (tempNum)
    {
        // Replace the old number with a new one
        [parts replaceObjectAtIndex:(NSUInteger)([parts count] - 1) 
                         withObject:fileNumberString];
    }
    else 
    {
        [parts addObject:fileNumberString];
    }

    // Glue parts and extension into a new string
    NSString *newFileName = 
        [[parts componentsJoinedByString:@" "] stringByAppendingFormat:@".%@", extension];
    
    [parts release];
    
    return newFileName;
    
}