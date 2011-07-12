//
//  PDFHelpers.m
//  myMusicStand
//
//  Created by Steven Solomon on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFHelpers.h"

UIImage *imageForPDFAtURLForSize(NSURL *url, CGFloat width, CGFloat height)
{
    // Get pdf page 
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL((__bridge CFURLRef)url);
    
    // get the image for the document
    UIImage *image = imageForPDFDocumentInSizeWithQuality(document, width, height, kCGInterpolationHigh);
    
    CGPDFDocumentRelease(document);
    
    return image;

}

UIImage *imageForPDFDocumentInSize(CGPDFDocumentRef document, CGFloat width, CGFloat height)
{
    return imageForPDFDocumentInSizeWithQuality(document, width, height, kCGInterpolationHigh);
}
   
UIImage *imageForPDFPageInDocumentWithSizeAndQuality(CGPDFDocumentRef document, size_t pageNumber, 
                                                     CGFloat width, CGFloat height, CGInterpolationQuality quality)
{
    CGPDFPageRef pdfPage = CGPDFDocumentGetPage(document, pageNumber);
    
    // generate thumbnail data for thumbnail by determine the size of the PDF page
    CGRect pageRect = CGPDFPageGetBoxRect(pdfPage, kCGPDFMediaBox);
    
    // Get scales for height and width
    CGFloat pdfScaleForWidth = width / pageRect.size.width;
    CGFloat pdfScaleForHeight = height / pageRect.size.height;
    CGFloat pdfScale = pdfScaleForWidth;
    
    // if pdfScaleForWidth is larger then we should use scale for height
    if (pdfScaleForWidth > pdfScaleForHeight) {
        pdfScale = pdfScaleForHeight;
    }
    
    pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
    
    UIGraphicsBeginImageContext(pageRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // First fill the background with white.
    CGContextSetRGBFillColor(ctx, 1.0,1.0,1.0,1.0);
    CGContextFillRect(ctx,pageRect);
    
    CGContextSaveGState(ctx);
    CGContextSetInterpolationQuality(ctx, quality);
    
    // Flip the ctx so that the PDF page is rendered
    // right side up.
    CGContextTranslateCTM(ctx, 0.0, pageRect.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    // Scale the ctx so that the PDF page is rendered 
    // at the correct size for width and height
    CGContextScaleCTM(ctx, pdfScale,pdfScale);	
    CGContextDrawPDFPage(ctx, pdfPage);
    CGContextRestoreGState(ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;

}

UIImage *imageForPDFDocumentInSizeWithQuality(CGPDFDocumentRef document, CGFloat width, CGFloat height, CGInterpolationQuality quality)
{    
    return imageForPDFPageInDocumentWithSizeAndQuality(document, 1, width, height, quality);
}