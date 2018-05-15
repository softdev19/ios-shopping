//
//  OCHomePageObj.m
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCHomePageObj.h"

@implementation OCHomePageObj


-(void)setAttributesFromDictionary:(NSDictionary *)dictionary {
    [super setAttributesFromDictionary:dictionary];
    
    self.pageUrl = [NSURL URLWithString:[dictionary objectOrNilForKey:@"URL"]];
}

@end
