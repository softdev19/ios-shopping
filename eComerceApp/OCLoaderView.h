//
//  OCLoaderView.h
//  eComerceApp
//
//  Created by Tarek Issa on 03/12/2015.
//  Copyright © 2015 Tvinci. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OCLoaderViewProtocol <NSObject>

- (void)tabsTappedAtIndex:(NSInteger)index;

@end



@interface OCLoaderView : UIView

+ (OCLoaderView *)showLoaderOnTarget:(UIView *)targetView andDelegate:(id<OCLoaderViewProtocol>)delegate;

+ (void)removeLoaderFromTarget:(UIView *)targetView;


- (void)removeLoader;
- (void)startLoading;
- (void)stopLoading;

@property (weak) id <OCLoaderViewProtocol> delegate;

@end
