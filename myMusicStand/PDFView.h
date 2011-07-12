//
//  PDFView.h
//  myMusicStand
//
//  This class is used to display a page of a pdfDocument
//
//  Created by Steven Solomon on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFView : UIView

// PDF page number to be displayed from the document
@property (nonatomic, assign) int pageNumber;

- (id)initWithFrame:(CGRect)frame andPDFDocument:(CGPDFDocumentRef)pdf;

@end
