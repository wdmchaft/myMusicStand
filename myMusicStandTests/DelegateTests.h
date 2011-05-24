//
//  SetupTests.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "CoreDataTest.h"

@class myMusicStandAppDelegate, File, FileTableController;
@interface DelegateTests : CoreDataTest {
    myMusicStandAppDelegate *appDelegate;
    FileTableController *rootController;
    File *file;
}

@end
