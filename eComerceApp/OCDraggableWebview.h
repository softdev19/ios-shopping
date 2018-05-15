//
//  OCDraggableWebview.h
//  eComerceApp
//
//  Created by Tarek Issa on 03/12/2015.
//  Copyright © 2015 Tvinci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol OCDraggableWebviewProtocol <NSObject>

- (void)cartWedgeCounterDetected:(int)counter;

@end

@interface OCDraggableWebview : WKWebView <UIScrollViewDelegate>

@property (nonatomic, weak) id <OCDraggableWebviewProtocol>dragableDelegate;

@end

@interface WKWebView (UIScrollViewDelegate) <UIScrollViewDelegate>

@end
