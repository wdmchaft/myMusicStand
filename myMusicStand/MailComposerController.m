//
//  MailComposerController.m
//  myMusicStand
//
//  Created by Steven Solomon on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MailComposerController.h"
#import "StageViewController.h"

@implementation MailComposerController
{
    StageViewController *__weak stageController;
}

- (id)initWithStageViewController:(StageViewController *)aDelegate
{
    self = [super init];
    if (self) {
        stageController = aDelegate;
    }
    
    return self;
}

- (void)displayEmailWith:(NSArray *)attachmentURLs
{
    // Handle email account not being setup
    if (![MFMailComposeViewController canSendMail])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email not setup"
                                                        message:@"Please set up an email account in the Mail app,"
                              @" so we can help you share your charts"
                                                       delegate:nil 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    [composer setMailComposeDelegate:self];
    
    // Set up message
    [composer setSubject:@"Checkout out this chart from myMusicStand"];
    
    for (NSURL *url in attachmentURLs)
    {
        NSData *data = [NSData dataWithContentsOfURL:url];
        [composer addAttachmentData:data mimeType:@"pdf" fileName:[url lastPathComponent]];
    }
    
    // Display composer
    [stageController presentModalViewController:composer animated:YES];

}

#pragma mark MFMailComposeDelegate Methods
- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error
{
    // close the composer 
    [controller dismissModalViewControllerAnimated:YES];
}
@end
