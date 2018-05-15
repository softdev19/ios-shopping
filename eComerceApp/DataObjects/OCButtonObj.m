//
//  OCButtonObj.m
//  eComerceApp
//
//  Created by TarekIssa on 5/18/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCButtonObj.h"
#import "OCImageDataObj.h"

@implementation OCButtonObj

- (void)setAttributesFromDictionary:(NSDictionary *)dictionary {
    [super setAttributesFromDictionary:dictionary];
    NSDictionary* cartDict = [dictionary objectOrNilForKey:@"CartTotalPosition"];
    if (cartDict != nil) {
        self.cartTotal = [[OCCartTotalObj alloc] initWithDictionary:cartDict];
    }
    self.cartTotal = [[OCCartTotalObj alloc] initWithDictionary:[dictionary objectOrNilForKey:@"CartTotalPosition"]];
    self.image = [[OCImageDataObj alloc] initWithDictionary:[dictionary objectOrNilForKey:@"ButtonImage"]];
    self.url = [NSURL URLWithString:[dictionary objectOrNilForKey:@"URL"]];
    
}

@end
