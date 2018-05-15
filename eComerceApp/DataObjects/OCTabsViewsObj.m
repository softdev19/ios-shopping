//
//  OCTabsViewsObj.m
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCTabsViewsObj.h"
#import "OCImageDataObj.h"
#import "OCTabObj.h"

@implementation OCTabsViewsObj

-(id) initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [self init])
    {
        [self setAttributesFromDictionary:dictionary];
    }
    return self;
}

-(void)setAttributesFromDictionary:(NSDictionary *)dictionary {
    [super setAttributesFromDictionary:dictionary];

    NSDictionary *imageDict = [dictionary objectOrNilForKey:@"BackgroundImage"];
    if (imageDict != nil) {
        self.imageDO    = [[OCImageDataObj alloc] initWithDictionary:imageDict];
    }
    self.color      = [self getColorFromDictionaryObj:[dictionary objectOrNilForKey:@"BgColor"]];

    self.selectedTabIndex = [[dictionary objectOrNilForKey:@"DeafaultTab"] intValue];
    [self setTabsAttributesFromTabsArray:[dictionary objectOrNilForKey:@"TabsObjectsArray"]];
    
}

- (void)setTabsAttributesFromTabsArray:(NSArray *)tabsArr {
    NSMutableArray* mutArr = [NSMutableArray arrayWithCapacity:tabsArr.count];
    
    for (int i = 0; i < tabsArr.count; i++) {
        NSDictionary* dic = tabsArr[i];
        OCTabObj* tabDO = [[OCTabObj alloc] initWithDictionary:dic];
        if (tabDO) {
            [mutArr addObject:tabDO];
        }
    }
    self.tabsDOArray = [NSArray arrayWithArray:mutArr];
}

@end
