//
//  OCButtonObj.h
//  eComerceApp
//
//  Created by TarekIssa on 5/18/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCBaseDataObj.h"
#import "OCCartTotalObj.h"

@class OCImageDataObj;
@class OCCartTotalObj;
@interface OCButtonObj : OCBaseDataObj {
    
}

@property (nonatomic, retain) OCCartTotalObj *cartTotal;
@property (nonatomic, retain) OCImageDataObj *image;
@property (nonatomic, retain) NSURL *url;

@end
