//
//  PDFScrollView.m
//  myMusicStand
//
//  Created by Steven Solomon on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFScrollView.h"
#import "PDFView.h"

@implementation PDFScrollView
{
    PDFView *pdfView;
    int pageNumber;
}

@synthesize pageNumber;

- (id)initWithFrame:(CGRect)frame andPDFDocument:(CGPDFDocumentRef)pdf 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Create pdfView as a subview to allow for zooming and scrolling
        pdfView = [[PDFView alloc] initWithFrame:[self bounds] 
                                  andPDFDocument:pdf];
        [self addSubview:pdfView];
        
        // Make us delegate
        [self setDelegate:self];
        
        // Enable zooming
        [self setMinimumZoomScale:1.0];
        [self setMaximumZoomScale:2.0];
        
        // Get rid of scroll indicators
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        
    }
    
    return self;
}

#pragma mark UIScrollView Delegate Methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return pdfView;
}

#pragma mark Setters
- (void)setPageNumber:(int)newPageNumber
{
    // set our page number properties
    pageNumber = newPageNumber;
    [pdfView setPageNumber:newPageNumber];
    // ask our subview to redraw new page
    [pdfView setNeedsDisplay];
    [self setZoomScale:1.0]; // reset our zoom scale for the new page
}

@end
