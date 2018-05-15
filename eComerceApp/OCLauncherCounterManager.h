//
//  OCLauncherCounterManager.h
//  eComerceApp
//
//  Created by Tarek Issa on 30/11/2015.
//  Copyright © 2015 Tvinci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCLauncherCounterManager : NSObject

+ (instancetype)sharedInstance;

- (void)resetCounter;
- (void)increaseCounter;
- (void)decreaseCounter;


@end
