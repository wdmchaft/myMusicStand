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
@interface myMusicStandAppDelegate : NSObject <UIApplicationDelegate > {
    IBOutlet FilesListTableViewController *rootController;
    IBOutlet UINavigationController *navController;
    IBOutlet UINavigationBar *bottomOfStand;
    NSArray *theFiles;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, readonly) UIViewController *rootController;
@property (nonatomic, readonly) UINavigationBar *bottomOfStand;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSArray *)knownFileNames;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (id)sharedInstance;
- (void)checkForFileDiffs:(NSFileManager *)fmg;
- (IBAction)tabIndexChanged:(UISegmentedControl *)sender;
@end
