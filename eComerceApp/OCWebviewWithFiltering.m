//
//  OCWebviewWithFiltering.m
//  eComerceApp
//
//  Created by Tarek Issa on 03/12/2015.
//  Copyright © 2015 Tvinci. All rights reserved.
//

#import "OCWebviewWithFiltering.h"
#import "OCLauncherCounterManager.h"
#import "OCCartWebViewController.h"
#import "OCAlertObj.h"
#import "PlistParser/OCPlistParser.h"

@interface OCWebviewWithFiltering () <WKNavigationDelegate, UIAlertViewDelegate>

@end


@implementation OCWebviewWithFiltering

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.navigationDelegate = self;
    self.scrollView.delegate = self;
}

- (void)adjustUserAgent:(NSURLRequest *)request {
//    if ([request isKindOfClass:[NSMutableURLRequest class]])
//    {
//        NSString *_userAgent = [self stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//        
//        if ([_userAgent rangeOfString:@"originalconcepts"].location == NSNotFound) {
////            NSString *nweUserAgent = [NSString stringWithFormat:@"%@ originalconcepts/1.0", _userAgent];
//            NSString *nweUserAgent = [NSString stringWithFormat:@"%@ Version/9.0 Safari/601.1 originalconcepts/1.0", _userAgent];
//            //  Mozilla/5.0 (iPhone; CPU iPhone OS 9_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13C75 Safari/601.1
//            // override user agent set?
//            if (nweUserAgent)
//            {
////                [request setValue:nweUserAgent forHTTPHeaderField:@"User-Agent"];
//            }
//        }
//    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    WKNavigationType navigationType = navigationAction.navigationType;
    NSURLRequest *request = navigationAction.request;
    
    if ([self.filterDelegate respondsToSelector:@selector(willStartFiltering)]) {
        [self.filterDelegate willStartFiltering];
    }
    [self adjustUserAgent:request];
    
    NSString *myURL = [request.URL absoluteString];
    
    OCAlertObj* alertObj = [[OCPlistParser sharedOCPlistParser] getAlertObj];
    
    if (alertObj.enable) {
        if ([myURL isEqualToString:@"ecom://AddToCartClick"]){
            NSLog(@"Add to Cart : %@", @"OK");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SUCCESS"
                                                            message:alertObj.alertText
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
    if (self.DoNotCheckRedirects) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    if ([self handleRequestUrl:[request.URL absoluteString]]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    if (navigationType == WKNavigationTypeLinkActivated) {
        if ([self samePage:request.URL andSecondUrl:self.url]) {
            [self fireShowLoaderDelegateMethod];
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
        
        
        if (
            [self isDetectedPatterns:
             [NSArray arrayWithObjects:@"remove/item", @"cart/delete/", nil]
                            inString:[[request.URL absoluteString] lowercaseString]]
            ) {
            [self fadeOut];
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
        
        if ([self.filterDelegate respondsToSelector:@selector(screenNavigationDetectedWithUrl:)]) {
            [self.filterDelegate screenNavigationDetectedWithUrl:request.URL];
        }
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;

    }else if (navigationType == WKNavigationTypeFormSubmitted) {
        
        NSArray *patterns = [NSArray arrayWithObjects:
                             @"cart/couponpost",
                             @"contacts/index/post",
                             @"customer/account/loginpost",
                             @"checkout/cart/add",
                             @"ajax/cart/add",
                             @"checkout/cart/updatepost", nil];
        
        if ([self isDetectedPatterns:patterns inString:[[request.URL absoluteString] lowercaseString]]) {
            [self fireShowLoaderDelegateMethod];
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
        
    } else {
        
        NSArray *patterns = [NSArray arrayWithObjects:
//                             @"checkout/onepage/?app=1",
                             @"checkout/onepage",
                             @"checkout/onepage/success",
                             nil];
        
        if ([self isDetectedPatterns:patterns inString:[[request.URL absoluteString] lowercaseString]]) {
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
        
        if ([self isDetectedPattern:@"wishlist/index/cart/item" inString:[[request.URL absoluteString] lowercaseString]]) {
            [self fireShowLoaderDelegateMethod];
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
        
        if ([self isDetectedPattern:@"checkout/onepage" inString:[[request.URL absoluteString] lowercaseString]]) {
            [self stopLoading];
            [self pushCartViewControllerWithStringUrl:[request.URL absoluteString]];
            
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (BOOL)isDetectedPatterns:(NSArray *)patterns inString:(NSString *)string {
    
    for (NSString *pattern in patterns) {
        if ([self isDetectedPattern:pattern inString:string]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isDetectedPattern:(NSString *)pattern inString:(NSString *)string {
    
    if ([[string lowercaseString]  rangeOfString:[pattern lowercaseString]].location != NSNotFound) {
        return YES;
    }
    return NO;
}


- (void)pushCartViewControllerWithStringUrl:(NSString *)strUrl {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCGoToCart object:nil];
}

- (BOOL)samePage:(NSURL *)firstUrl andSecondUrl:(NSURL *)secondUrl {
    if ([[firstUrl relativePath] isEqualToString:[secondUrl relativePath]]) {
        return YES;
    }
    
    return NO;
}

- (NSString *)getBaseUrl:(NSURL *)url {
    NSArray* arr1 = [[url absoluteString] componentsSeparatedByString:@"/?app"];
    NSArray* arr2 = [[arr1 firstObject] componentsSeparatedByString:@"?"];
    
    return [arr2 firstObject];
}

- (BOOL)handleRequestUrl:(NSString *)stringUrl {
    
    NSString* string = [stringUrl lowercaseString];
    
    
    if ([self isDetectedPattern:@"ecom://" inString:string]) {
        if ([self isDetectedPattern:@"?" inString:string]) {
            
            NSArray* subStringsArr = [string componentsSeparatedByString:@"?"];
            for (NSString* address in subStringsArr) {
                [self handleSingleAdress:address];
            }
            return YES;
        }else{
            [self handleSingleAdress:string];
            return YES;
        }
    }
    return NO;
}

- (void)handleSingleAdress:(NSString *)address{
    
    address = [address stringByReplacingOccurrencesOfString:@"ecom://" withString:@""];
    
    if ([self isDetectedPattern:@"connect/" inString:address]) {
        NSArray* arr = [address componentsSeparatedByString:@"connect/"];
        NSNumber* num = [NSNumber numberWithInt:[[arr lastObject] intValue]];
        [[NSNotificationCenter defaultCenter] postNotificationName:OCUserConnecttion object:num];
    }else if ([self isDetectedPattern:@"cart/" inString:address]) {
        
        NSArray* arr = [address componentsSeparatedByString:@"/"];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * num = arr.count == 2 ? [f numberFromString:[arr lastObject]] : [f numberFromString:[arr objectAtIndex:1]];
        
        if ([self isDetectedPattern:@"/inc/success" inString:address]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"התווסף לעגלת הקניות" delegate:self cancelButtonTitle:@"לתשלום" otherButtonTitles:@"המשך בקניה", nil];
            [alert show];
        } else if ([self isDetectedPattern:@"/dec" inString:address]) {
            [self fireHideLoaderDelegateMethod];
        } else if ([self isDetectedPattern:@"/inc/fail" inString:address]) {
            [self fireHideLoaderDelegateMethod];
        } else if (arr.count == 2) {
            [self fireHideLoaderDelegateMethod];
        }
        [self fireUpdateWedgetDelegateMethod:[num intValue]];
    }else if ([self isDetectedPattern:@"pagefinishedloading" inString:address]) {
        
    }else if ([self isDetectedPattern:@"whishlist" inString:address]) {
        
    } else if ([self isDetectedPattern:@"addtocartclick" inString:address]) {
        [self fireShowLoaderDelegateMethod];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [self fireHideLoaderDelegateMethod];

    if (self.DoNotCheckRedirects) {
        [self fadeIn];
    }
    if ([self.filterDelegate respondsToSelector:@selector(pageDidFinishLoading:)]) {
        [self.filterDelegate pageDidFinishLoading:nil];
    }

}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self fireHideLoaderDelegateMethod];

    if ([self.filterDelegate respondsToSelector:@selector(pageDidFinishLoading:)]) {
        [self.filterDelegate pageDidFinishLoading:error];
    }
}


- (void)fadeOut {
    [self fireShowLoaderDelegateMethod];
    self.alpha = 1.0;
    
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)fadeIn {
    [self fireHideLoaderDelegateMethod];

    self.alpha = 0.0;
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 1.0;
    } completion:nil];
}

- (void)fireShowLoaderDelegateMethod {
    if ([self.filterDelegate respondsToSelector:@selector(pageisLoading)]) {
        [self.filterDelegate pageisLoading];
    }
}

- (void)fireHideLoaderDelegateMethod {
    if ([self.filterDelegate respondsToSelector:@selector(pageStopedLoading)]) {
        [self.filterDelegate pageStopedLoading];
    }
}

- (void)fireUpdateWedgetDelegateMethod:(int)counter {
    if ([self.filterDelegate respondsToSelector:@selector(cartWedgeCounterDetected:)]) {
        [self.filterDelegate cartWedgeCounterDetected:counter];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if ([self.filterDelegate respondsToSelector:@selector(didPressedButtonCart)]) {
            [self.filterDelegate didPressedButtonCart];
        }
    } else if (buttonIndex == 1) {
        [self fireHideLoaderDelegateMethod];
    }
}

@end
