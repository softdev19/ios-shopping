//
//  OCNavigationController.h
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OCTabObj;

@interface OCNavigationController : UINavigationController {
    
}


- (instancetype)initWith:(OCTabObj *)tabObj isDefaultScreen:(BOOL)isDefaultScreen;


@end
