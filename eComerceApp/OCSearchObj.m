//
//  OCSearchObj.m
//  eComerceApp
//
//  Created by Tarek Issa on 02/12/2015.
//  Copyright © 2015 Tvinci. All rights reserved.
//

#import "OCSearchObj.h"

@implementation OCSearchObj


-(void)setAttributesFromDictionary:(NSDictionary *)dictionary {
    [super setAttributesFromDictionary:dictionary];
    
    self.searchUrlStr = [dictionary objectOrNilForKey:@"searchUrl"];
    self.image = [[OCImageDataObj alloc] initWithDictionary:[dictionary objectOrNilForKey:@"ButtonImage"]];

}

@end
