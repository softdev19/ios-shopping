//
//  OCTabObj.h
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCBaseDataObj.h"
#import "OCMenuDataObj.h"
#import "OCImageDataObj.h"

typedef enum {
    OCTabType_Unknown = 0,
    OCTabType_Webview,
    OCTabType_Menu,
    OCTabType_Social,
    OCTabType_MultiWebPage,
    OCTabType_WebviewWithWidget,
    OCTabType_MenuWithWidget,
    OCTabType_UnAvailable

} OCTabType;



@interface OCTabObj : OCBaseDataObj {
    
}


@property (nonatomic, assign) OCTabType type;
@property (nonatomic, retain) OCImageDataObj* iconOn;
@property (nonatomic, retain) OCImageDataObj* iconOff;
@property (nonatomic, retain) NSString* categoryUrl;
@property (nonatomic, retain) OCMenuDataObj *categories;
@property (nonatomic, assign) BOOL isWidget;
@property (nonatomic, assign) BOOL isReload;
@property (nonatomic, assign) NSString* categoryId;
@property (nonatomic, retain) NSURL* pageUrl;
@property (nonatomic, retain) NSArray* listArray;



@end
