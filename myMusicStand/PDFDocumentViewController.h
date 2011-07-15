//
//  PDFDocumentViewController.h
//  myMusicStand
//
//  This class is used to handle displaying a PDFDocument across
//  a scrollable interface
//  
//  Created by Steve Solomon on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDFDocument, PDFView;
@interface PDFDocumentViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, readonly) PDFDocument *document;

// Designated initializer, which creates the document from the url passed
// and loads view setup from nib
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil URL:(NSURL *)url;

@end
