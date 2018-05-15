//
//  OCTabarController.h
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCTabarController : UITabBarController


- (void)tabsTappedAtIndex:(NSInteger)index;
- (void)pressDefaultTab;
- (void)pressTab:(NSUInteger)tab;
- (void)showTabWithParameters:(NSURLQueryItem *)parameters AtIndex:(NSInteger)index;

@end
