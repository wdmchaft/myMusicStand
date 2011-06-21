//
//  PDFViewController.h
//  myMusicStand
//
//  Created by Steve Solomon on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFViewController : UIViewController
{
    CGPDFDocumentRef document;
    NSURL *documentURL;
    NSMutableArray *pages; // holds uiimages for pages in the pdf
}
- (id)initWithURL:(NSURL *)url;
- (UIImage *)imageForPageNumber:(NSUInteger)index;
- (void)addImageForPageNumber:(NSUInteger)index;
@end
