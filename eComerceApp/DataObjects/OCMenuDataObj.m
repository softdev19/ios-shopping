//
//  OCMenuDataObj.m
//  eComerceApp
//
//  Created by TarekIssa on 5/20/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCMenuDataObj.h"

@implementation OCMenuDataObj

- (id)initWithJSONArray:(NSArray *)jsonArr {
    if (self = [self init])
    {
        [self setJSONArray:jsonArr];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [self init])
    {
        [self setDictionary:dict];
    }
    return self;
}

- (void)setDictionary:(NSDictionary *)dict {
    
    NSDictionary *dataDict = [dict objectOrNilForKey:@"data"];
    if (dataDict != nil && [dataDict objectOrNilForKey:@"link"]) {
        self.url = [NSURL URLWithString:[dataDict objectOrNilForKey:@"link"]];
        self.title = [NSString stringWithString:[dataDict objectOrNilForKey:@"name"]];
        self.categoryId = (long)[[dataDict objectOrNilForKey:@"id"] longLongValue];
    } else  if (dataDict != nil && [dataDict objectOrNilForKey:@"URL"]) {
        self.url = [NSURL URLWithString:[dataDict objectOrNilForKey:@"URL"]];
        self.title = [NSString stringWithString:[dataDict objectOrNilForKey:@"Title"]];
        self.categoryId = (long)[[dataDict objectOrNilForKey:@"ID"] longLongValue];
    }


    NSArray *arr = [dict objectOrNilForKey:@"children"];
    NSArray *subLinks = [dict objectOrNilForKey:@"SubLinks"];
    
    if ((arr) && (arr.count > 0)) {
        NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSDictionary *subObj in arr) {
            OCMenuDataObj *menu = [[OCMenuDataObj alloc] initWithDictionary:subObj];
            [mutArr addObject:menu];
        }
        self.subDirArr = [NSArray arrayWithArray:mutArr];
    } else  if (subLinks.count > 0) {
        NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSDictionary *subObj in subLinks) {
            OCMenuDataObj *menu = [[OCMenuDataObj alloc] initWithDictionary:subObj];
            [mutArr addObject:menu];
        }
        self.subDirArr = [NSArray arrayWithArray:mutArr];
    }
}

- (void)setJSONArray:(NSArray *)jsonArr {
    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:jsonArr.count];
//    self.title = [NSString stringWithString:[dict objectOrNilForKey:@"name"]];
    
    for (NSDictionary *subObj in jsonArr) {
        OCMenuDataObj *menu = [[OCMenuDataObj alloc] initWithDictionary:subObj];
        [mutArr addObject:menu];
    }
    self.subDirArr = [NSArray arrayWithArray:mutArr];
}


@end
