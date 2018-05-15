//
//  OCImageDataObj.m
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCImageDataObj.h"

@implementation OCImageDataObj

-(void)setAttributesFromDictionary:(NSDictionary *)dictionary {
    [super setAttributesFromDictionary:dictionary];
    
    self.imageFileName = [dictionary objectOrNilForKey:@"ImageName"];
//    self.trancparency  = [[dictionary objectOrNilForKey:@"Transparency"] floatValue];
}

@end
