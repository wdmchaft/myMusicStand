//
//  myMusicStandAppDelegate.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class FilesListTableViewController;
@interface myMusicStandAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet FilesListTableViewController *rootController;
    NSArray *theFiles;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, readonly) FilesListTableViewController *rootController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSArray *)knownFileNames;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (id)sharedInstance;
- (void)checkForFileDiffs;
@end
