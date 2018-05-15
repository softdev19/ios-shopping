//
//  OCWebPageViewController.m
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCWebPageViewController.h"
#import "JASidePanelController.h"
//#import "OCCartButton.h"
#import "OCLauncherCounterManager.h"
#import "OCCartWebViewController.h"
#import "OCWebviewWithFiltering.h"



@interface OCWebPageViewController () <WKUIDelegate, UIAlertViewDelegate, OCWebviewWithFilteringProtocol, OCDraggableWebviewProtocol> {
    NSString *initialHtmlStr;
}

@property (nonatomic, weak) UIViewController *popupViewController;

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, assign) BOOL isMainPage;
@property (nonatomic, strong) OCWebviewWithFiltering *webview;

@end

@implementation OCWebPageViewController

+ (void)initialize {
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Mozilla/5.0 (iPhone; CPU iPhone OS 9_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13C75 Version/9.0 Safari/601.1 originalconcepts/1.0", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

- (void)dealloc
{
    NSLog(@"Deallocated");

    [self.webview stopLoading];
    
    self.webview.navigationDelegate = nil;
    self.webview.scrollView.delegate = nil;
    
    [self.webview removeFromSuperview];
}

- (id)initWithRequest:(NSURLRequest *)request configuration:(WKWebViewConfiguration *)configuration
{
    self = [self init];
    if (self) {
        self.webview = [[OCWebviewWithFiltering alloc] initWithFrame:CGRectZero configuration:configuration];
        self.request = request;
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPageUrl:(NSURL *)pageUrl
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.request = [[NSURLRequest alloc] initWithURL:pageUrl];
        [self setup];
        [self loadWebview];
    }
    return self;
}

- (id)initMainPageWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPageUrl:(NSURL *)pageUrl
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.request = [[NSURLRequest alloc] initWithURL:pageUrl];;
        self.isMainPage = YES;
        [self setup];
        [self loadWebview];
    }
    return self;
}

- (id)initWithPageUrl:(NSURL *)pageUrl {
    self = [super init];
    if (self) {
        // Custom initialization
        self.request = [[NSURLRequest alloc] initWithURL:pageUrl];
        [self setup];
        [self loadWebview];
    }
    return self;

}

- (void)setup {
    if (!self.webview) {
        self.webview = [[OCWebviewWithFiltering alloc] init];
    }
    self.webview.backgroundColor = [UIColor clearColor];
    self.webview.url = self.request.URL;
    self.webview.filterDelegate = self;
    self.webview.dragableDelegate = self;
    self.webview.UIDelegate = self;
    self.webview.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.webview];
}

- (void)loadWebview {
    if (self.isMainPage) {
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:self.request.URL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];

//        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:self.url];
        [self adjustUserAgent:req];

        [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            initialHtmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Done");
            
            // etc
            if (self.isViewLoaded) {
                [self.webview loadHTMLString:initialHtmlStr baseURL:nil];
            }
        }];
    }
}

- (void)adjustUserAgent:(NSMutableURLRequest *)request {
//    NSString *_userAgent = [self.webview stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
//    if ([_userAgent rangeOfString:@"originalconcepts"].location == NSNotFound) {
//        NSString *nweUserAgent = [NSString stringWithFormat:@"%@ Version/9.0 Safari/601.1 originalconcepts/1.0", _userAgent];
////        [request setValue:[NSString stringWithFormat:@"%@ Safari/528.16", [request valueForHTTPHeaderField:@"User-Agent"]] forHTTPHeaderField:@"User_Agent"];
//
//        // override user agent set?
//        if (nweUserAgent)
//        {
////            [request setValue:nweUserAgent forHTTPHeaderField:@"User-Agent"];
//        }
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isMainPage) {
        if (initialHtmlStr != nil) {
            [self.webview loadHTMLString:initialHtmlStr baseURL:nil];
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:OCShowLoad object:nil];
        
        NSMutableURLRequest *urlRequest = [self.request mutableCopy];
        urlRequest.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        urlRequest.timeoutInterval = 60.0;
        
        [self adjustUserAgent:urlRequest];
        
        [self.webview loadRequest:urlRequest];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGRect frame = self.webview.frame;
    frame.origin = CGPointZero;
    frame.size = self.view.frame.size;
    self.webview.frame = frame;
}

#pragma mark - WKUIDelegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView stopLoading];
        OCWebPageViewController *controller = [[OCWebPageViewController alloc] initWithRequest:navigationAction.request configuration:configuration];
        [controller setupNavigationInnerWithBackButton];
        [self.navigationController pushViewController:controller animated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:OCHideLoad object:nil];
        self.popupViewController = controller;
        return controller.webview;
    }
    return nil;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    } else {
        [self performSelector:@selector(showCart) withObject:nil afterDelay:0.6];
    }
}

- (void)showCart {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCGoToCart object:nil];
}

- (void)reloadWebview {
    if (!self.webview.isLoading) {
        [self.webview reload];
    }
}

- (void)setDoNotCheckRedirects:(BOOL)DoNotCheckRedirects {
    _DoNotCheckRedirects = DoNotCheckRedirects;
    [self.webview setDoNotCheckRedirects:YES];
}

#pragma mark - OCWebviewWithFilteringProtocol

-(void)willStartFiltering {
    if (self.popupViewController) {
        [[NSNotificationCenter defaultCenter] postNotificationName:OCShowLoad object:nil];
        [self.navigationController popToViewController:self animated:NO];
    }
}

-(void)cartWedgeCounterDetected:(int)counter {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCCartUpdated object:[NSNumber numberWithInt:counter]];
}

-(void)pageStopedLoading {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCHideLoad object:nil];
}

-(void)pageisLoading {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCShowLoad object:nil];
}

-(void)screenNavigationDetectedWithUrl:(NSURL *)url {
    OCWebPageViewController* webpageViewController = [[OCWebPageViewController alloc] initWithNibName:@"OCWebPageViewController" bundle:nil andPageUrl:url];
    
    [webpageViewController setupCartButtonOnRight];
    [webpageViewController setupNavigationInnerWithBackButton];
    [self.navigationController pushViewController:webpageViewController animated:YES];
}

-(void)pageDidFinishLoading:(NSError *)error {
    if (self.updateLaunchCounter) {
        [[OCLauncherCounterManager sharedInstance] decreaseCounter];
    }
}

-(void)didPressedButtonCart {
    OCNavigationObj *navObj = [[OCPlistParser sharedOCPlistParser] getNavigationObject];
    OCCartWebViewController  *webpageViewController = [[OCCartWebViewController alloc] initWithPageUrl:navObj.rightButton.url];
    [webpageViewController setupNavigationForMenuSideStyle];
    
    UINavigationController *navCont = [[UINavigationController alloc] initWithRootViewController:webpageViewController];
    navCont.view.backgroundColor = [UIColor whiteColor];
    
    [self.topViewController presentViewController:navCont animated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:OCShowLoad object:nil];
    }];
}

- (UIViewController *)topViewController
{
    UIViewController *controller = self.navigationController;
    while (controller.presentedViewController) {
        controller = controller.presentedViewController;
    }
    return controller;
}

@end
