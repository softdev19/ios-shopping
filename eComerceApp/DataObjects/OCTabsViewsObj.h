//
//  OCTabsViewsObj.h
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCBaseDataObj.h"

@class OCImageDataObj;

@interface OCTabsViewsObj : OCBaseDataObj {
    
}


@property (nonatomic, retain) OCImageDataObj* imageDO;
@property (nonatomic, retain) NSArray* tabsDOArray;
@property (nonatomic, assign) int selectedTabIndex;
@property (nonatomic, retain) UIColor* color;


@end
