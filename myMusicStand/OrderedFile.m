//
//  OrderedFile.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OrderedFile.h"
#import "Setlist.h"


@implementation OrderedFile
@dynamic index;
@dynamic file;
@dynamic setlist;

+ (OrderedFile *)orderedFileWithContext:(NSManagedObjectContext *)moc
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"OrderedFile"
                                         inManagedObjectContext:moc];
}
@end
