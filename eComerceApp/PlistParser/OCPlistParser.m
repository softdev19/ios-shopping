//
//  OCPlistParser.m
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCPlistParser.h"
#import "SynthesizeSingleton.h"
#import "OCTabsViewsObj.h"
#import "OCHomePageObj.h"
#import "OCNavigationObj.h"
#import "OCSideMenuObj.h"
#import "OCSearchObj.h"
#import "OCAlertObj.h"

@interface OCPlistParser () {
    
}


@property (nonatomic, retain) NSDictionary* plist;
@end

@implementation OCPlistParser


#pragma mark - Singlton
SYNTHESIZE_SINGLETON_FOR_CLASS(OCPlistParser);


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadConfigurationPlist];
    }
    return self;
}

- (void)loadConfigurationPlist {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"AppConfigurations" ofType:@"plist"];
    
    //Since your plist's root is a dictionary else you should form NSArray from contents of plist
    self.plist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

- (OCTabsViewsObj *)getTabsObject {
    return [[OCTabsViewsObj alloc] initWithDictionary:[self.plist objectForKey:@"Tabs"]];
}

- (OCHomePageObj *)getHomePageObject {
    return [[OCHomePageObj alloc] initWithDictionary:[self.plist objectForKey:@"MainUrl"]];
}

- (OCNavigationObj *)getNavigationObject {
    return [[OCNavigationObj alloc] initWithDictionary:[self.plist objectForKey:@"Navigation"]];
}

- (OCSideMenuObj *)getSideMenuObj {
    return [[OCSideMenuObj alloc] initWithDictionary:[self.plist objectForKey:@"SideMenu"]];
}

- (OCSearchObj *)getSearchObj {
    return [[OCSearchObj alloc] initWithDictionary:[self.plist objectForKey:@"SearchBar"]];
}

- (OCAlertObj *)getAlertObj {
    return [[OCAlertObj alloc] initWithDictionary:[self.plist objectForKey:@"ALERT"]];
}

-(OCPlatformType)platform {
    return [[self.plist objectForKey:@"Platform"] intValue];
}

-(NSString *)NCRN {
    return [self.plist objectForKey:@"NCRN"];
}

- (UIColor *)getLoaderColor {
    return [self getColorFromDictionaryObj:[self.plist objectForKey:@"LoaderColor"]];

}

- (UIColor *)getColorFromDictionaryObj:(NSDictionary *)dict {
    
    float R = [[dict objectOrNilForKey:@"R"] floatValue];
    float G = [[dict objectOrNilForKey:@"G"] floatValue];
    float B = [[dict objectOrNilForKey:@"B"] floatValue];
    float alpha = [[dict objectOrNilForKey:@"opacity"] floatValue];
    
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:alpha];
}

@end
