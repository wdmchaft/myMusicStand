//
//  PDFHelpers.h
//  myMusicStand
//
//  Series of Helper functions dealing with PDF documents
//  
//  Created by Steven Solomon on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

UIImage *imageForPDFAtURLForSize(NSURL *url, CGFloat width, CGFloat height);

// Render pdf page with interpolationQuality of high
UIImage *imageForPDFDocumentInSize(CGPDFDocumentRef document, CGFloat width, CGFloat height);

UIImage *imageForPDFDocumentInSizeWithQuality(CGPDFDocumentRef document, CGFloat width, CGFloat height, CGInterpolationQuality quality);

// Render a specific page in a pdf document
UIImage *imageForPDFPageInDocumentWithSizeAndQuality(CGPDFDocumentRef document, size_t pageNumber, 
                                                     CGFloat width, CGFloat height, CGInterpolationQuality quality);