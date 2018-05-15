//
//  OCNavigationObj.h
//  eComerceApp
//
//  Created by TarekIssa on 5/18/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCBaseDataObj.h"
@class OCButtonObj;
@class OCLogoImage;
@class OCImageDataObj;

@interface OCNavigationObj : OCBaseDataObj {
    
}

@property (nonatomic, retain) OCButtonObj* leftButton;
@property (nonatomic, retain) OCButtonObj* rightButton;
@property (nonatomic, retain) OCButtonObj* closeButton;
@property (nonatomic, retain) OCButtonObj* backButton;
@property (nonatomic, retain) OCLogoImage* logo;
@property (nonatomic, retain) OCImageDataObj* imageDO;
@property (nonatomic, retain) UIColor* color;


@end
