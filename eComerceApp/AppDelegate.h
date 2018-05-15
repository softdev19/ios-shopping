//
//  AppDelegate.h
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JASidePanelController;
@class MMMaterialDesignSpinner;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JASidePanelController *viewController;
@property (strong, nonatomic) MMMaterialDesignSpinner *activitiIndicator;
@property (strong, nonatomic) UIViewController *activitiIndicatorController;

@end
