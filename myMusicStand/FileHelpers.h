/*
 *  FileHelpers.h
 *  Homepwner
 *
 *  Created by Steve Solomon on 1/29/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

typedef enum {
    FileDiffTypeNew = 1,
    FileDiffTypeStale
} FileDiffType;

NSArray *filesDiffWithFileslistAndKnownFiles(NSArray *filesInDirectory, NSArray *knownFiles, FileDiffType type);
