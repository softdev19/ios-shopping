//
//  OCSocialObj.m
//  eComerceApp
//
//  Created by TarekIssa on 8/18/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCSocialObj.h"

@implementation OCSocialObj


-(void)setAttributesFromDictionary:(NSDictionary *)dictionary {
    [super setAttributesFromDictionary:dictionary];
    self.title = [dictionary objectOrNilForKey:@"Title"];
    self.SocialPageUrl = [NSURL URLWithString:[dictionary objectOrNilForKey:@"URL"]];
    
}

@end
