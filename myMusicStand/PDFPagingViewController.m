    //
//  PDFPagingViewController.m
//  PDFPrototyping
//
//  Created by Steve Solomon on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFPagingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "PagingScrollViewController.h"
#import "PDFScrollView.h"

@implementation PDFPagingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self init];
}

- (id)init 
{
	return [self initWithPDFURLArray:nil];
}

- (id)initWithPDFURLArray:(NSArray *)pdfs
{
	self = [super init];
	
	if (self)
	{
		pdfsToDisplay = [pdfs retain];
		
		// Loop through each URL and each page in url and add page to array
		pages = [[NSMutableDictionary alloc] init];
		documents = [[NSMutableArray alloc] init];
		NSNumber *absoluteNum = [NSNumber numberWithInt:0];
		
		for (NSURL *url in pdfsToDisplay)
		{
			// Create pdf doc from url
			CGPDFDocumentRef document = CGPDFDocumentCreateWithURL((CFURLRef)url);
			// Having one instance of NSValue represent the document
			// Will make it easier to rebuild this structure later
			NSValue *valueForDoc = [NSValue valueWithPointer:document];
			[documents addObject:valueForDoc];
			// Index of the value we added to the document array
			NSNumber *indexForDocument = 
				[NSNumber numberWithInt:[documents count] - 1];
						
			// Find out number of pages in 
			int numPages = CGPDFDocumentGetNumberOfPages(document);
			
			// For each page
			for (int i = 0; i < numPages; i++)
			{
				// Increment absolute page number
				absoluteNum = [NSNumber numberWithInt:[absoluteNum intValue] + 1];
				// Dictionary containing relative page num and pdf url
				NSMutableDictionary *dictionay = [NSMutableDictionary dictionary];
				// Values for inner dictionary
				// index of document in documents array
				[dictionay setObject:indexForDocument
							  forKey:@"PDFDocIndex"];
				NSNumber *relativeNum = [NSNumber numberWithInt:i];
				[dictionay setObject:relativeNum forKey:@"RelativePageNumber"];
				
				// Add new entry for absolute page number
				[pages setObject:dictionay forKey:absoluteNum];
				
			}
			
			// Clean up document
			// we don't want to release the document because we will do it later
			//CGPDFDocumentRelease(document);
			
		}
		
		// Set Parent's Datasource to ourself
		[self setDataSource:self];
		
		[self setHidesBottomBarWhenPushed:YES];
	}
	
	return self;
}


- (void)viewDidLoad
{
	[super viewDidLoad];
	// Disable scrolling, so we can't scroll up and down
	[pagingScrollView setDirectionalLockEnabled:YES];
	
	// Hide navigation and tab bar
	[[self navigationController] setNavigationBarHidden:YES
                                               animated:NO];
	
	// Gesture recognizer to show nav bar
	tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
														 action:@selector(toggleNavBar:)];
	
	// Add recognizer 
	[pagingScrollView addGestureRecognizer:tapGesture];
	
    
    actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                         target:self
                                                                         action:@selector(showActions:)];
    [[self navigationItem] setRightBarButtonItem:actionItem];
    /*
	// If we can print set our item action button
	if ([UIPrintInteractionController isPrintingAvailable])
	{
		printItem = 
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
														  target:self
														  action:@selector(printPDF:)];
		[[self navigationItem] setRightBarButtonItem:printItem];
	}
	// Load the print controller
	printController = [UIPrintInteractionController sharedPrintController];
		*/
    // Make the navigation bar clear
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    [navBar setBackgroundColor:[UIColor blackColor]];
    [navBar setTranslucent:YES];

}


- (void)showActions:(id)sender
{
    NSString *emailButtonText = @"Email as PDF";
    if ([pdfsToDisplay count] > 1)
    {
        emailButtonText = @"Email as PDFs";
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:emailButtonText, @"Print", nil];
    [actionSheet showFromBarButtonItem:sender
                              animated:YES];
}

#pragma mark Action sheet delegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet 
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) // Email button
    {
        // Check if mail is supported
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil)
        {
            // We must always check whether the current device is configured for sending emails
            if (![mailClass canSendMail])
            {
                // Alert user and cancel when email isn't supported
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Error"
                                                                message:@"Email hasn't been setup on this device"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
            
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            
            [picker setSubject:@"I want to share this via myMusicStand"];
                    
            // Attach all pdfs 
            for (NSURL *url in pdfsToDisplay)
            {            
                NSData *myData = [NSData dataWithContentsOfURL:url];
                [picker addAttachmentData:myData mimeType:@"text/pdf" fileName:[url lastPathComponent]];
            }
            
            // Fill out the email body text
            NSString *emailBody = @"Hey check out this chart i was viewing on myMusicStand!";
            [picker setMessageBody:emailBody isHTML:NO];
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }

    }
    else if (buttonIndex == 1) // Print button
    {
        printController = [UIPrintInteractionController sharedPrintController];
        // Give controller the url for the pdf
        [printController setPrintingItem:pdfsToDisplay];
        
        // Display the controller in the appropriate idiom
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [printController presentFromBarButtonItem:actionItem
                                             animated:YES
                                    completionHandler:nil];
        }
        else 
        {
            [printController presentAnimated:YES 
                           completionHandler:nil];
        }
    }
}

#pragma mark MFMailComposeViewControllerDelegate Methods
- (void)mailComposeController:(MFMailComposeViewController *)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError *)error
{    
    if (result == MFMailComposeResultFailed)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Failed!"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert autorelease];
    }

    [controller dismissModalViewControllerAnimated:YES];
}

- (void)toggleNavBar:(id)sender 
{
   
	UINavigationBar *navBar = [[self navigationController] navigationBar];
	
    
    // Set NavBar hidden as opposite of current value
    [[self navigationController] setNavigationBarHidden:![navBar isHidden] 
                                               animated:YES];
    
   
}

-(NSUInteger)numberOfPagesInPagingScrollView
{
	return [pages count];
}

-(UIView *)pagingScrollView:(UIScrollView *)pagingView pageForIndex:(NSUInteger)index
{
	PDFScrollView *page = (PDFScrollView *)[self dequeueReusablePage];
	
	if (!page)
	{
		page = [[[PDFScrollView alloc] initWithFrame:[self frameForPageAtIndex:0]] autorelease];
		
	}
	
	// Get dictionary for absolute page number
	NSDictionary *dictionary = [pages objectForKey:[NSNumber numberWithInt:index + 1]];
	
	// Get CGPDFDocumentRef from documents array
	NSNumber *docIndex = [dictionary objectForKey:@"PDFDocIndex"];
	int i = [docIndex intValue];
	NSValue *docValue = [documents objectAtIndex:i];
	CGPDFDocumentRef document = [docValue pointerValue];
	
	NSNumber *relativePageNum = [dictionary objectForKey:@"RelativePageNumber"];
	
	// Set the delegate of the page's CALayer to me
	//[[page layer] setDelegate:self];

	PDFScrollView* pdfPage = (PDFScrollView*)page;
	
    NSLog(@"Relative Number: %d", [relativePageNum intValue]);
    // give the PDFScrollView its page
    CGPDFPageRef thePage = CGPDFDocumentGetPage(document, [relativePageNum intValue] + 1);
    [pdfPage setPDFPage:thePage];
	// page in url to draw

	[pdfPage setIndex:[relativePageNum intValue]];

	return page;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
    // Hide the navbar before you go offscreen
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
	[[UIPrintInteractionController sharedPrintController] dismissAnimated:YES]; 
}
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
}
*/



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[[self view] removeGestureRecognizer:tapGesture];
  
}


- (void)dealloc {
	[pdfsToDisplay release];
	[pages release]; 
	[tapGesture release];
	[actionItem release];
    [super dealloc];
}


@end
