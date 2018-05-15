//
//  OCListContentObj.m
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCListContentObj.h"

@implementation OCListContentObj

-(void)setAttributesFromDictionary:(NSDictionary *)dictionary {
    [super setAttributesFromDictionary:dictionary];
    self.title = [dictionary objectOrNilForKey:@"Title"];
    self.pageUrl = [dictionary objectOrNilForKey:@"URL"];
    
}

@end
