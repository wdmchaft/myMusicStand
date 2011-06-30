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

/*
 *  Load the pdf document from the NSData we are passed in contents param
 */
- (BOOL)loadFromContents:(id)contents 
                  ofType:(NSString *)typeName 
                   error:(NSError **)outError
{
    
    // create a data provider for pdf using NSData and toll free bridging
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)contents);
    // create pdf document from provider
    document = CGPDFDocumentCreateWithProvider(provider);
    CGDataProviderRelease(provider);
    
    // Check if we failed to open document
    if (document == nil)
    {
        return DOCUMENT_FAILED_TO_OPEN;
    }
    
    return DOCUMENT_HAS_OPENED;
    
}

- (void)dealloc
{
    CGPDFDocumentRelease(document);
    [super dealloc];
}


@end
