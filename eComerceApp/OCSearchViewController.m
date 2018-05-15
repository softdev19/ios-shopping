//
//  OCSearchViewController.m
//  eComerceApp
//
//  Created by Tarek Issa on 02/12/2015.
//  Copyright © 2015 Tvinci. All rights reserved.
//

#import "OCSearchViewController.h"
#import "OCSearchObj.h"
#import <WebKit/WebKit.h>
#import "OCWebviewWithFiltering.h"
#import "OCWebPageViewController.h"
@interface OCSearchViewController () <UISearchBarDelegate, WKNavigationDelegate,UIScrollViewDelegate, OCWebviewWithFilteringProtocol>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) OCWebviewWithFiltering *webview;

@end

@implementation OCSearchViewController

- (void)dealloc
{
    NSLog(@"Deallocated");
    
    [self.webview stopLoading];
    
    self.webview.navigationDelegate = nil;
    self.webview.scrollView.delegate = nil;
    
    [self.webview removeFromSuperview];
}

-(void)viewDidLoad {
    [super viewDidLoad];

    [self addSearchBar];
    [self addWebview];
}

- (void)addWebview {
    self.webview = [[OCWebviewWithFiltering alloc] init];
    self.webview.filterDelegate = self;
    self.webview.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.webview.scrollView.delegate = self;
    self.webview.alpha = 0;
    [self.webview setBackgroundColor:[UIColor clearColor]];
//    self.webview.scrollView.contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height + 20, 0, 0, 0);
    [self.view addSubview:self.webview];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect frame = self.webview.frame;
    frame.origin = CGPointMake(0, self.navigationController.navigationBar.frame.size.height + 20);
    frame.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - frame.origin.y);
    self.webview.frame = frame;
}

- (void)addSearchBar {
    
    UIButton *label = [UIButton buttonWithType:UIButtonTypeCustom];
    [label setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    label.titleLabel.textAlignment = NSTextAlignmentCenter;
    [label setTitle:@"ביטול" forState:UIControlStateNormal];
    [label addTarget:self action:@selector(cancelTapped:) forControlEvents:UIControlEventTouchUpInside];
    label.frame = CGRectMake(0, 0, self.view.frame.size.width * 0.17, _searchBar.frame.size.height);
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:label];
    [cancelButton setTarget:self];
    
    [cancelButton setTintColor:[UIColor blackColor]];

    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 0.72, 44)];
    
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _searchBar.placeholder = @"חיפוש...";

    //    OCSearchObj* searchObj = [[OCPlistParser sharedOCPlistParser] getSearchObj];

    _searchBar.translucent = YES;
    [_searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [_searchBar setBarStyle:UIBarStyleDefault];
    [_searchBar becomeFirstResponder];
    _searchBar.delegate = self;
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc]initWithCustomView:_searchBar];
    searchBarItem.tag = 123;
    [searchBarItem setStyle:UIBarButtonItemStylePlain];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:cancelButton, searchBarItem, nil]];
}

- (void)cancelTapped:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OCHideLoad object:nil];
    [self.webview stopLoading];
    
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
//                         [self makeClearBackground];
                         self.view.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self dismissViewControllerAnimated:NO completion:nil];
                     }
     ];
    [_searchBar resignFirstResponder];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarShouldBeginEditing");
    
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidBeginEditing");
    [searchBar becomeFirstResponder];
    
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text  {
    NSLog(@"shouldChangeTextInRange");
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searchBarSearchButtonClicked");
    [searchBar resignFirstResponder];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchBarCancelButtonClicked");
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"textDidChange");

    if ([searchText isEqualToString:@""]) {
        [self hideWebview];
        return;
    }
    
    [self hideWebview];

    [[NSNotificationCenter defaultCenter] postNotificationName:OCShowLoad object:nil];

    OCSearchObj* searchObj = [[OCPlistParser sharedOCPlistParser] getSearchObj];
    
                    
    NSString *spacesTrimmed = [searchText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSArray *arr = [spacesTrimmed componentsSeparatedByString:@" "];

                    
    NSMutableString *mutStr = [NSMutableString stringWithString:searchObj.searchUrlStr];

    for (int i=0; i < arr.count; i++) {
        
        NSString *str = arr[i];

        if ((i+1) == arr.count) {
            [mutStr appendString:str];
        } else {
            [mutStr appendString:[NSString stringWithFormat:@"%@+", str]];
        }
    }
    
    [mutStr appendString:@"&app=1"];
    NSString *fullSearch = [mutStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *fullSearchUrl =  [NSURL URLWithString:fullSearch];

    [self.webview stopLoading];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:fullSearchUrl];
    [self.webview loadRequest:request];
    NSLog(@"fullSearchUrl: %@", fullSearchUrl);
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar endEditing:YES];
}
#pragma mark - UIWebViewDelegate


-(void)pageDidFinishLoading:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCHideLoad object:nil];
    [self showWebview];
}
- (void)hideWebview {
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.webview.alpha = 0.0;
                     } completion:nil];
}


- (void)showWebview {
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.webview.alpha = 1.0;
                     } completion:nil];
}

-(void)screenNavigationDetectedWithUrl:(NSURL *)url {
    
    OCWebPageViewController* webpageViewController = [[OCWebPageViewController alloc] initWithNibName:@"OCWebPageViewController" bundle:nil andPageUrl:url];
    
    [webpageViewController setupCartButtonOnRight];
    [webpageViewController setupNavigationInnerWithBackButton];
    [self.navigationController pushViewController:webpageViewController animated:YES];
}

@end
