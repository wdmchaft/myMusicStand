//
//  PDFPagingViewController.h
//  PDFPrototyping
//
//  Created by Steve Solomon on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagingScrollViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface PDFPagingViewController : PagingScrollViewController 
<PagingScrollViewDataSource, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> 
{
	NSArray *pdfsToDisplay;
	UITapGestureRecognizer *tapGesture;
	UIBarButtonItem *actionItem;
	UIPrintInteractionController *printController;

	// Mapping of absolute page numbers to a dictionary of relative page num and pdf documents
	NSMutableDictionary *pages; 
	NSMutableArray *documents;
	
}

- (id)initWithPDFURLArray:(NSArray *)pdfs;

@end
