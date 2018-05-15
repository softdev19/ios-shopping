//
//  OCCartTotalObj.m
//  eComerceApp
//
//  Created by jcb on 4/7/16.
//  Copyright © 2016 Tvinci. All rights reserved.
//

#import "OCCartTotalObj.h"

@implementation OCCartTotalObj

-(void)setAttributesFromDictionary:(NSDictionary *)dictionary {
    [super setAttributesFromDictionary:dictionary];
    
    self.top = [[dictionary objectForKey:@"Top"] floatValue];
    self.left = [[dictionary objectOrNilForKey:@"Left"] floatValue];
    
    self.bgColor = [self getColorFromDictionaryObj:[dictionary objectOrNilForKey:@"CartTotalBgColor"]];
    self.txtColor = [self getColorFromDictionaryObj:[dictionary objectOrNilForKey:@"CartTotalTextColor"]];
}

@end

