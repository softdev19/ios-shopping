//
//  OCBaseDataObj.m
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCBaseDataObj.h"

@interface OCBaseDataObj () {
    
}

- (UIColor *)getColorFromDictionaryObj:(NSDictionary *)dict;

@end

@implementation OCBaseDataObj

-(id) initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [self init])
    {
        [self setAttributesFromDictionary:dictionary];
    }
    return self;
}

-(void) setAttributesFromDictionary:(NSDictionary *)dictionary
{
    // Leave for subclasses to implement
}

- (UIColor *)getColorFromDictionaryObj:(NSDictionary *)dict {

    float R = [[dict objectOrNilForKey:@"R"] floatValue];
    float G = [[dict objectOrNilForKey:@"G"] floatValue];
    float B = [[dict objectOrNilForKey:@"B"] floatValue];
    float alpha = [[dict objectOrNilForKey:@"opacity"] floatValue];

    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:alpha];
}

@end
