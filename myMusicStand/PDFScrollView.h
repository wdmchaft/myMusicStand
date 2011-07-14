//
//  PDFScrollView.h
//  myMusicStand
//
//  Created by Steven Solomon on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFScrollView : UIScrollView<UIScrollViewDelegate>

// PDF page number to be displayed from the document
@property (nonatomic, assign) int pageNumber;

// Designated Initializer
- (id)initWithFrame:(CGRect)frame andPDFDocument:(CGPDFDocumentRef)pdf;

@end
