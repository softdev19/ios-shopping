//
//  NSDictionary+NSNullAvoidance.m
//  tvinci-ios-framework
//
//  Created by Avraham Shukron on 5/8/12.
//  Copyright (c) 2012 Quickode. All rights reserved.
//

#import "NSDictionary+NSNullAvoidance.h"
#import "NSArray+NSNullAvoidance.h"

@implementation NSDictionary (NSNullAvoidance)
-(id) objectOrNilForKey:(id)aKey
{
    id objectForKey = [self objectForKey:aKey];
    if ([objectForKey isEqual:[NSNull null]])
    {
        objectForKey = nil;
    }
    return objectForKey;
}

-(NSDictionary *) dictionaryByRemovingNSNulls
{
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:self];
    for (id key in [self allKeys])
    {
        id object = [temp objectForKey:key];
        if ([object isEqual:[NSNull null]])
        {
            // Strip NSNull
            [temp removeObjectForKey:key];
        }
        else if ([object isKindOfClass:[NSDictionary class]])
        {
            // Recursively strip any inner dictionaries from NSNulls
            object = [object dictionaryByRemovingNSNulls];
            [temp setObject:object forKey:key];
        }
        else if ([object isKindOfClass:[NSArray class]]) 
        {
            NSArray *newArray = [((NSArray *)object) arrayByRemovingNSNulls];
            [temp setObject:newArray forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:temp];
}



@end

@implementation NSMutableDictionary (NSNullAvoidance)
-(void) setObjectOrNil : (id) object forKey : (id) key
{
    if (object != nil)
    {
        [self setObject:object forKey:key];
    }
}


-(void) setObjectOrNSNull:(id)object forKey:(id)key
{
    if (object != nil)
    {
        [self setObject:object forKey:key];
    }
    else
    {
         [self setObject:[NSNull null] forKey:key];
    }
}
@end
