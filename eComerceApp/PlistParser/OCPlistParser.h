//
//  OCPlistParser.h
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OCTabsViewsObj;
@class OCHomePageObj;
@class OCNavigationObj;
@class OCSideMenuObj;
@class OCSearchObj;
@class OCMenuDataObj;

@interface OCPlistParser : NSObject

typedef enum _OCPlatformType {
    OCPlatformTypeMagento = 0,
    OCPlatformTypeWordpress
} OCPlatformType;



+ (OCPlistParser*)sharedOCPlistParser;

- (OCTabsViewsObj *)getTabsObject;
- (OCHomePageObj *)getHomePageObject;
- (OCNavigationObj *)getNavigationObject;
- (OCSideMenuObj *)getSideMenuObj;
- (OCSearchObj *)getSearchObj;
- (OCSearchObj *)getAlertObj;
- (NSString *)NCRN;
- (UIColor *)getLoaderColor;

@property (nonatomic, assign) OCPlatformType platform;

@end
