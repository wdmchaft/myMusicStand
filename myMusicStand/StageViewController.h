//
//  StageViewController.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class BlockTableController;
@interface StageViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)tabIndexChanged:(UISegmentedControl *)sender;
- (IBAction)showActionItems:(UIBarButtonItem *)sender;
- (void)setEmailButtonEnabled:(BOOL)enabled;
- (void)displayEmailWith:(NSArray *)attachmentURLs;
- (void)slideStandDown;
- (void)slideStandUp;
@end
