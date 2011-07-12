//
//  PDFView.m
//  myMusicStand
//
//  Created by Steven Solomon on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFView.h"
#import "PDFHelpers.h"

@implementation PDFView
{
    CGPDFDocumentRef document;
    int pageNumber;
}

@synthesize pageNumber;

- (id)initWithFrame:(CGRect)frame andPDFDocument:(CGPDFDocumentRef)pdf 
{
    self = [super initWithFrame:frame];
    if (self) {
        document = CGPDFDocumentRetain(pdf);       
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    @throw @"Illegal instantiation use 'initWithFrame:andPDFDocument:' instead";
}

- (void)dealloc
{
    CGPDFDocumentRelease(document);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);

    // draw image
    UIImage *image = imageForPDFPageInDocumentWithSizeAndQuality(document, 
                                                                 pageNumber, 
                                                                 rect.size.width, 
                                                                 rect.size.height, 
                                                                 kCGInterpolationHigh);
    
    [image drawInRect:rect];
    
    CGContextRestoreGState(ctx);
    
}


@end
