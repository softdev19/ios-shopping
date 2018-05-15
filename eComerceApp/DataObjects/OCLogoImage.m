//
//  OCLogoImage.m
//  eComerceApp
//
//  Created by TarekIssa on 5/18/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCLogoImage.h"
#import "OCImageDataObj.h"

@implementation OCLogoImage

- (void)setAttributesFromDictionary:(NSDictionary *)dictionary {
    [super setAttributesFromDictionary:dictionary];
    self.image = [[OCImageDataObj alloc] initWithDictionary:[dictionary objectOrNilForKey:@"LogoImage"]];
    
}

@end
