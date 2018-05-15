//
//  OCAlertObj.m
//  eComerceApp
//
//  Created by jcb on 4/11/16.
//  Copyright © 2016 Tvinci. All rights reserved.
//
#import "OCAlertObj.h"

@implementation OCAlertObj


-(void)setAttributesFromDictionary:(NSDictionary *)dictionary {
    [super setAttributesFromDictionary:dictionary];
    
    self.alertText = [dictionary objectOrNilForKey:@"text"];
    self.enable = [[dictionary objectForKey:@"show"] boolValue];    
}

@end