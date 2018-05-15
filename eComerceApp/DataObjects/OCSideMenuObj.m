//
//  OCSideMenuObj.m
//  eComerceApp
//
//  Created by TarekIssa on 5/18/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCSideMenuObj.h"
#import "OCSideMenuRowObj.h"
#import "OCImageDataObj.h"

@implementation OCSideMenuObj

-(void)setAttributesFromDictionary:(NSDictionary *)dictionary {
    [super setAttributesFromDictionary:dictionary];
    
    self.color = [self getColorFromDictionaryObj:[dictionary objectOrNilForKey:@"BgColor"]];
    self.separatorColor = [self getColorFromDictionaryObj:[dictionary objectOrNilForKey:@"SeparatorColor"]];
    self.footerImage = [[OCImageDataObj alloc] initWithDictionary:[dictionary objectOrNilForKey:@"FooterImage"]];

    [self setAttributesFromArray:[dictionary objectOrNilForKey:@"MenuArray"]];
}

- (void)setAttributesFromArray:(NSArray *)listArray {

    NSMutableArray* array = [NSMutableArray array];
    
    for (int i = 0; i < listArray.count; i++) {
        NSDictionary* dict = listArray[i];
        OCSideMenuRowObj* sideMenuRowObj = [[OCSideMenuRowObj alloc] initWithDictionary:dict];
        [array addObject:sideMenuRowObj];
    }
    self.menuListArray = [NSArray arrayWithArray:array];

}

@end
