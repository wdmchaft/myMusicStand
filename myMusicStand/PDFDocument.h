//
//  PDFDocument.h
//  myMusicStand
//
//  Created by Steve Solomon on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFDocument : UIDocument

@property (nonatomic, readonly) CGPDFDocumentRef data;
@property (nonatomic, readonly) int numberOfPages;
@end
