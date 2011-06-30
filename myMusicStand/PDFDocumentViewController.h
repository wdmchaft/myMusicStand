//
//  PDFDocumentViewController.h
//  myMusicStand
//
//  Created by Steve Solomon on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDFDocument;
@interface PDFDocumentViewController : UIViewController
{
    PDFDocument *document;
}

@property (nonatomic, readonly) PDFDocument *document;

// Designated initializer
- (id)initWithURL:(NSURL *)url;
@end
