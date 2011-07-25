//
//  FileImporter.h
//  myMusicStand
//
//  This class handles importing a file added to 
//  the application inbox as a result of another app 
//  trying to open a type we support
//  
//  Created by Steven Solomon on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileImporter : NSObject

// copy url from inbox to documents
- (void)importFileAtURL:(NSURL *)url withFileManger:(NSFileManager *)fileManger;
// create a dest url in our documents directory from inbox
- (NSURL *)createDocumentURLfromSrcURL:(NSURL *)srcURL;
@end
