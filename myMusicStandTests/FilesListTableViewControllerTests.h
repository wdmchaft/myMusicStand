//
//  FilesListControllerTest.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "CoreDataTest.h"

@class FileTableController;
@interface FilesListTableViewControllerTests : CoreDataTest {
    id mockContext;
    FileTableController *controller;
    NSIndexPath *indexPath;
}

@end
