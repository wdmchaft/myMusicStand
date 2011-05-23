//
//  PagingScrollViewController.h
//  PDFPrototyping
//
//  Created by Steve Solomon on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
	PagingScrollViewDataSource
 
	This protocol allows a level of abstraction over the paging scheme which will 
	allow us to duplicate paging functionality simply. The dataSource has two required
	methods for conformers. numberOfPagesInPagingScrollView which gives us the number 
	of pages we must display, and pagingScrollView:pageForIndex: returns us the 
	ReusuablePageView conformer to display for some index.
 */
@protocol PagingScrollViewDataSource

// Gets the number of pages we need to display
-(NSUInteger)numberOfPagesInPagingScrollView;
// Asks for setup of page for a given index
-(UIView *)pagingScrollView:(UIScrollView *)scrollView 
               pageForIndex:(NSUInteger)index;

@optional

// Allows us to know if some view should be placed in a UIScrollView default is NO
-(BOOL)shouldPlaceViewInScrollViewAtIndex:(NSUInteger)index;

@end


/*
	This class allows us to duplicate paging functionality without needing 
	to know about the UIView subclasses we will display.
 */


@interface PagingScrollViewController : UIViewController <UIScrollViewDelegate>
{
	// Allows us to recycle pages
	NSMutableSet *reusablePages;
	// Overall Paging scrollview 
	UIScrollView *pagingScrollView;
	// Our dataSource so that we know what do display
	id<PagingScrollViewDataSource> dataSource;
	// the number of pages we will display based on what our dataSource tells us
	int numberOfPages;
	NSMutableSet *visiblePages;
	
}

@property(nonatomic, assign) id<PagingScrollViewDataSource> dataSource;
@property(nonatomic, retain) UIScrollView *pagingScrollView;

// Add page to reusable queue
- (void)enqueueReusablePage:(UIView *)page;
// Get page from reusuable queue
- (UIView *)dequeueReusablePage;
// Layout pages and add/remove them if needed
- (void)tilePages;
// Get the rect we will display our pagingScrollView in
- (CGRect)frameForPagingScrollView;
// Frame for some page
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
// Page for some frame
- (UIView *)getPageForFrame:(CGRect)frame;
- (void)setupPageForIndex:(NSUInteger)index;


@end

