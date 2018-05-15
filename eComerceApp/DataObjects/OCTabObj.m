//
//  OCTabObj.m
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCTabObj.h"
#import "OCSocialObj.h"

@implementation OCTabObj


-(void)setAttributesFromDictionary:(NSDictionary *)dictionary {
    [super setAttributesFromDictionary:dictionary];
    
    self.type = [self typeFromInt:[[dictionary objectOrNilForKey:@"TabType"] intValue]];
    self.isReload = [self typeFromInt:[[dictionary objectOrNilForKey:@"isReload"] boolValue]];
    self.iconOff = [[OCImageDataObj alloc] initWithDictionary:[dictionary objectOrNilForKey:@"IconOff"]];
    self.iconOn = [[OCImageDataObj alloc] initWithDictionary:[dictionary objectOrNilForKey:@"IconOn"]];
    self.categoryUrl = [dictionary objectOrNilForKey:@"categoryUrl"];
    self.categoryId = [dictionary objectOrNilForKey:@"CategoryId"];

    [self setupPageLayoutFromDictionary:dictionary];
}


- (OCTabType)typeFromInt:(int)type {
    if (type < 0 || type >= OCTabType_UnAvailable) {
        return OCTabType_Unknown;
    }
    return type;
}

- (void)setupPageLayoutFromDictionary:(NSDictionary *)dictionary {
    switch (self.type) {
        case OCTabType_Webview:
        case OCTabType_Menu:
            self.pageUrl =  [NSURL URLWithString:[dictionary objectOrNilForKey:@"PageUrl"]];
            break;
        case OCTabType_MultiWebPage:
            self.categories = [[OCMenuDataObj alloc] initWithJSONArray:[dictionary objectOrNilForKey:@"ContentList"]];
            break;
            
        case OCTabType_WebviewWithWidget:
            
            break;
            
        case OCTabType_MenuWithWidget:
            
            break;
        
        case OCTabType_Social:
            [self setupSocialFromArray:[dictionary objectOrNilForKey:@"ContentList"]];
            break;
        

        default:
            break;
    }

}

- (void)setupSocialFromArray:(NSArray *)array {
    
    NSMutableArray* mutArr = [NSMutableArray array];
    
    for (int i = 0; i < array.count; i++) {
        NSDictionary* dict = array[i];
        OCSocialObj* socialDO = [[OCSocialObj alloc] initWithDictionary:dict];
        [mutArr addObject:socialDO];
    }
    self.listArray = [NSArray arrayWithArray:mutArr];
}

@end
