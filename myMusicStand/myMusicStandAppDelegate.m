//
//  myMusicStandAppDelegate.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "myMusicStandAppDelegate.h"
#import "File.h"
#import "FileHelpers.h"

static myMusicStandAppDelegate *sharedInstance;

@implementation myMusicStandAppDelegate


@synthesize window=_window;

@synthesize bottomOfStand;

@synthesize managedObjectContext=__managedObjectContext;

@synthesize managedObjectModel=__managedObjectModel;

@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

- (id)init 
{
	if (sharedInstance)
	{
		NSLog(@"Error: You are creating a second AppController");
	}
	
	[super init];
	sharedInstance = self;
	
	/*
	 Class privateClass = NSClassFromString(@"NSSQLCore");
	 // You will get a compiler warning here, ignore it
	 [privateClass setDebugDefault:YES];*/
	return self;
}

+ (myMusicStandAppDelegate *)sharedInstance
{
	return sharedInstance;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // First find any new files and add them to the context
    [self updateContextForDocumentDirectoryChanges:[NSFileManager defaultManager]];

    // Set navigationController's navBar to hidden
    [[navController navigationBar] setHidden:YES];
        
    // Add rootController's view to window
    [[self window] addSubview:[navController view]];
    
    // Bring navBar to the front of the window
    [[self window] bringSubviewToFront:bottomOfStand];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self updateContextForDocumentDirectoryChanges:[NSFileManager defaultManager]];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)dealloc
{
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [super dealloc];
}

- (void)awakeFromNib
{
    /*
     Typically you should set up the Core Data stack here, usually by passing the managed object context to the first view controller.
     self.<#View controller#>.managedObjectContext = self.managedObjectContext;
    */
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"myMusicStand" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

- (NSURL *)libraryDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory 
                                                   inDomains:NSUserDomainMask] lastObject];
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self libraryDirectory] URLByAppendingPathComponent:@"myMusicStand.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

- (NSArray *)knownFileNames
{
    
    NSArray *files = [[self managedObjectContext] allEntity:@"File"];
    NSMutableArray *fileNames = [[[NSMutableArray alloc] init] autorelease];    
 
    // Loop through all the known files and build up an array of filenames
    for (File *file in files)
    {
        [fileNames addObject:[file filename]];
    }
    
    // return an immutable copy of the filenames array 
    return [[fileNames copy] autorelease];
}

- (void)updateContextForDocumentDirectoryChanges:(NSFileManager *)fm
{
    // Get the context to add new files to
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Diff for new files
    NSString *docsPath = [[self applicationDocumentsDirectory] path];
    NSArray *directoryContents = [fm contentsOfDirectoryAtPath:docsPath error:nil];
    NSArray *knownFiles = [self knownFileNames];
    NSArray *newFiles = filesDiffWithFileslistAndKnownFiles(directoryContents, knownFiles, FileDiffTypeNew);
    NSArray *staleFiles = filesDiffWithFileslistAndKnownFiles(directoryContents, knownFiles, FileDiffTypeStale);
    
    // Loop through the new file names and add them
    for (NSString *newFile in newFiles)
    {
        [[File fileWithContext:context] setFilename:newFile];
    }
    
    // Fetch the file that has the name we want to delete
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"File" inManagedObjectContext:context]];
    
    // Loop through the stale file names and remove them
    for (NSString *staleFile in staleFiles)
    {
        
        // Predicate for request
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"filename == %@", staleFile];
        [request setPredicate:predicate];
        
        // Execute the request
        NSArray *results = [context executeFetchRequest:request error:nil];
        
        // we have one result
        File *file = [results objectAtIndex:0];
        
        // remove the result from the context
        [context deleteObject:file];
        
    }
  
    // Call delegate method to save changes
    [self saveContext];
}



#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
