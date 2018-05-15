//
//  OCSideMenuObj.h
//  eComerceApp
//
//  Created by TarekIssa on 5/18/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCBaseDataObj.h"

@class OCImageDataObj;

@interface OCSideMenuObj : OCBaseDataObj

@property (nonatomic, retain) UIColor* color;
@property (nonatomic, retain) UIColor* separatorColor;
@property (nonatomic, retain) NSArray* menuListArray;
@property (nonatomic, retain) OCImageDataObj *footerImage;

@end
