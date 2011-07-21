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

@interface FileDiffer : NSObject {

}
+ (NSArray *)diffForType:(FileDiffType)type forFilesInDir:(NSArray *)files andKnownFiles:(NSArray *)known;
@end