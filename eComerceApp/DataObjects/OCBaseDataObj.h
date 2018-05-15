//
//  OCBaseDataObj.h
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+NSNullAvoidance.h"

@interface OCBaseDataObj : NSObject {
    
}


-(id) initWithDictionary:(NSDictionary *)dictionary ;
-(void) setAttributesFromDictionary:(NSDictionary *)dictionary;
- (UIColor *)getColorFromDictionaryObj:(NSDictionary *)dict;

@end
