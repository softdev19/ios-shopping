//
//  OCMenuDataObj.h
//  eComerceApp
//
//  Created by TarekIssa on 5/20/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCBaseDataObj.h"

@interface OCMenuDataObj : NSObject


@property (nonatomic ,strong) NSURL* url;
@property (nonatomic ,strong) NSString* title;
@property (nonatomic ,assign) long categoryId;
@property (nonatomic ,strong) NSArray* subDirArr;

- (id)initWithDictionary:(NSDictionary *)dict;
- (id)initWithJSONArray:(NSArray *)jsonArr;

@end
