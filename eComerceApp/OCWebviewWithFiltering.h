//
//  OCWebviewWithFiltering.h
//  eComerceApp
//
//  Created by Tarek Issa on 03/12/2015.
//  Copyright © 2015 Tvinci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCDraggableWebview.h"

@protocol OCWebviewWithFilteringProtocol <NSObject>

@optional

- (void)willStartFiltering;
- (void)screenNavigationDetectedWithUrl:(NSURL *)url;
- (void)pageDidFinishLoading:(NSError *)error;
- (void)pageisLoading;
- (void)pageStopedLoading;
- (void)cartWedgeCounterDetected:(int)counter;
- (void)didPressedButtonCart;

@end


@interface OCWebviewWithFiltering : OCDraggableWebview

@property (nonatomic, assign) BOOL DoNotCheckRedirects;
@property (nonatomic, strong) NSURL* url;
@property (nonatomic, weak) id <OCWebviewWithFilteringProtocol>filterDelegate;

@end
