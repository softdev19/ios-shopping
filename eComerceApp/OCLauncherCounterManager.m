//
//  OCLauncherCounterManager.m
//  eComerceApp
//
//  Created by Tarek Issa on 30/11/2015.
//  Copyright © 2015 Tvinci. All rights reserved.
//

#import "OCLauncherCounterManager.h"

@interface OCLauncherCounterManager () {
    int counter;
}

@end


@implementation OCLauncherCounterManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static OCLauncherCounterManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[OCLauncherCounterManager alloc] init];
        [sharedInstance resetCounter];
    });
    return sharedInstance;
}

- (void)resetCounter {
    counter = 0;
}

- (void)increaseCounter {
    counter++;
}

- (void)decreaseCounter {
    counter--;
    if (counter <= 0) {
        counter = 0;

        [[NSNotificationCenter defaultCenter] postNotificationName:@"ocDoneLoadingMainPages" object:nil];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        [alert show];
    }
}

@end
