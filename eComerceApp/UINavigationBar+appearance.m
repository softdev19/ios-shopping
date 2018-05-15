//
//  UINavigationBar+appearance.m
//  eComerceApp
//
//  Created by Tarek Issa on 02/12/2015.
//  Copyright © 2015 Tvinci. All rights reserved.
//

#import "UINavigationBar+appearance.h"

@implementation UINavigationBar (appearance)


//-(void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//}

//-(void)layoutSubviews {
//    [super layoutSubviews];
//    NSLog(@"layoutSubviews");
//
//    NSLog(@"----------------");
//    [self printSubviews:self];
//    NSLog(@"----------------");
//}

- (void)printSubviews:(UIView *)view {
    
    NSLog(@"view: %@", view);
    
//    for (UIView *subview in view.subviews) {
//        if ([subview isKindOfClass:[UINavigationBar class]]) {
//            CGRect frame = subview.frame;
//            frame.size.height = 64;
//            subview.frame = frame;
//        }else{
//            [self printSubviews:subview];
//        }
//    }
}

@end
