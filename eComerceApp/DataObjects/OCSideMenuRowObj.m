//
//  OCSideMenuRowObj.m
//  eComerceApp
//
//  Created by TarekIssa on 5/18/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCSideMenuRowObj.h"

@implementation OCSideMenuRowObj


-(void)setAttributesFromDictionary:(NSDictionary *)dictionary {
    [super setAttributesFromDictionary:dictionary];
    self.url = [NSURL URLWithString:[dictionary objectOrNilForKey:@"URL"]];
    self.title = [dictionary objectOrNilForKey:@"Title"];
    self.color = [self getColorFromDictionaryObj:[dictionary objectOrNilForKey:@"Color"]];
}

@end
