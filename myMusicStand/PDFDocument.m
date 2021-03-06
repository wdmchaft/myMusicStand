//
//  PDFDocument.m
//  myMusicStand
//
//  Created by Steve Solomon on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFDocument.h"
#define DOCUMENT_HAS_OPENED YES
#define DOCUMENT_FAILED_TO_OPEN NO

@implementation PDFDocument
{
    // The backing data for this document
    CGPDFDocumentRef data;
    int numberOfPages;
}

@synthesize data;
@synthesize numberOfPages;

/*
 *  Load the pdf document from the NSData we are passed in contents param
 */
- (BOOL)loadFromContents:(id)contents 
                  ofType:(NSString *)typeName 
                   error:(NSError **)outError
{
    
    // create a data provider for pdf using NSData and toll free bridging
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)contents);
    // create pdf document from provider
    data = CGPDFDocumentCreateWithProvider(provider);
    
    CGDataProviderRelease(provider);
    
    // Check if we failed to open document
    if (data == nil)
    {
        return DOCUMENT_FAILED_TO_OPEN;
    }
    
    // store the number of pages
    numberOfPages = CGPDFDocumentGetNumberOfPages(data);
    
    return DOCUMENT_HAS_OPENED;
    
}

- (void)dealloc
{
    CGPDFDocumentRelease(data);
}


@end
