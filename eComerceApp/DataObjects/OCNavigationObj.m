//
//  OCNavigationObj.m
//  eComerceApp
//
//  Created by TarekIssa on 5/18/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCNavigationObj.h"
#import "OCButtonObj.h"
#import "OCLogoImage.h"
#import "OCImageDataObj.h"
#import "OCCartTotalObj.h"
@implementation OCNavigationObj


-(void)setAttributesFromDictionary:(NSDictionary *)dictionary {
    [super setAttributesFromDictionary:dictionary];
    self.leftButton = [[OCButtonObj alloc] initWithDictionary:[dictionary objectOrNilForKey:@"LeftButton"]];
    self.rightButton = [[OCButtonObj alloc] initWithDictionary:[dictionary objectOrNilForKey:@"RightButton"]];
    self.closeButton = [[OCButtonObj alloc] initWithDictionary:[dictionary objectOrNilForKey:@"CloseButton"]];
    self.backButton = [[OCButtonObj alloc] initWithDictionary:[dictionary objectOrNilForKey:@"BackButton"]];
    self.logo = [[OCLogoImage alloc] initWithDictionary:[dictionary objectOrNilForKey:@"MiddleLogo"]];

    NSDictionary *imageDict = [dictionary objectOrNilForKey:@"BackgroundImage"];
    if (imageDict != nil) {
        self.imageDO    = [[OCImageDataObj alloc] initWithDictionary:imageDict];
    }
    self.color      = [self getColorFromDictionaryObj:[dictionary objectOrNilForKey:@"BgColor"]];

}


@end
