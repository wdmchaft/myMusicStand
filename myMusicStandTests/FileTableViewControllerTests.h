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
@interface FileTableViewControllerTests : CoreDataTest {
    id mockContext;
    id mockTableView;
    FileTableController *controller;
    NSIndexPath *indexPath;
}

@end
