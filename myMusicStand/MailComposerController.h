//
//  MailComposerController.h
//  myMusicStand
//
//  Created by Steven Solomon on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@class StageViewController;
@interface MailComposerController : NSObject <MFMailComposeViewControllerDelegate>


- (id)initWithStageViewController:(StageViewController *)aDelegate;

- (void)displayEmailWith:(NSArray *)attachmentURLs;

@end
