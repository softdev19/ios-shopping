//
//  OCNavigationBar.m
//  eComerceApp
//
//  Created by Tarek Issa on 02/12/2015.
//  Copyright © 2015 Tvinci. All rights reserved.
//

#import "OCNavigationBar.h"

@implementation OCNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self setBackgroundColor:[UIColor redColor]];
//    }
//    return self;
//}
//
//
//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super initWithCoder:coder];
//    if (self) {
//        [self setBackgroundColor:[UIColor redColor]];
//    }
//    return self;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setBackgroundColor:[UIColor redColor]];
//    }
//    return self;
//}

-(void)layoutSubviews {
    [super layoutSubviews];
    for (UINavigationItem *item in self.items) {
        item.titleView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    }
}

@end
