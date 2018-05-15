//
//  NSArray+NSNullAvoidance.m
//  TvinciSDK
//
//  Created by Avraham Shukron on 9/2/12.
//  Copyright (c) 2012 Quickode. All rights reserved.
//

#import "NSArray+NSNullAvoidance.h"
#import "NSDictionary+NSNullAvoidance.h"

@implementation NSArray (NSNullAvoidance)
-(NSArray *) arrayByRemovingNSNulls
{
    NSMutableArray *temp = [NSMutableArray array];
    for (id object in self)
    {
        if ([object isEqual:[NSNull null]])
        {
            // Ignore NSNulls.
            continue;
        }
        else if ([object isKindOfClass:[NSDictionary class]]) 
        {
            // Strip dictionary
            NSDictionary *newDictionary = [((NSDictionary *)object) dictionaryByRemovingNSNulls];
            [temp addObject:newDictionary];
        }
        else if ([object isKindOfClass:[NSArray class]]) 
        {
            // Strip array
            NSArray *newArray = [object arrayByRemovingNSNulls];
            [temp addObject:newArray];
        }
        else 
        {
            [temp addObject:object];
        }
    }
    return [NSArray arrayWithArray:temp];
}
@end
