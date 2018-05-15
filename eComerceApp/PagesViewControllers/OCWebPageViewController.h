//
//  OCWebPageViewController.h
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCNavigationButtonsViewController.h"

#import <WebKit/WebKit.h>

@interface OCWebPageViewController : OCNavigationButtonsViewController

- (id)initWithRequest:(NSURLRequest *)request configuration:(WKWebViewConfiguration *)configuration;

- (id)initWithPageUrl:(NSURL *)pageUrl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPageUrl:(NSURL *)pageUrl;

- (id)initMainPageWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPageUrl:(NSURL *)pageUrl;

//@property (nonatomic, assign) BOOL isCartPage;
@property (nonatomic, assign) BOOL DoNotCheckRedirects;
@property (nonatomic, assign) BOOL updateLaunchCounter;
@property (strong, nonatomic, readonly) UIViewController *topViewController;

- (void)reloadWebview;

@end
