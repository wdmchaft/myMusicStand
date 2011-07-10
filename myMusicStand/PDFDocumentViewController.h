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
@interface PDFDocumentViewController : UIViewController
{
    // The document we will display
    PDFDocument *document;
    UIImageView *imageView;
    UIView *pdfView;
    UIScrollView *scrollView; // same as view
}

@property (nonatomic, readonly) PDFDocument *document;

// Designated initializer, which creates the document from the url passed
- (id)initWithURL:(NSURL *)url;
// Helper method used as a callback to display the pdf once loaded
- (void)documentStateHasBeenUpdated;
@end
