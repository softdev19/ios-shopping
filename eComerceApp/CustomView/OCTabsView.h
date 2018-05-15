//
//  OCTabsView.h
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OCTabsViewsObj;


@protocol OCTabsProtocol <NSObject>

- (void)tabsTappedAtIndex:(NSInteger)index;

@end


@interface OCTabsView : UIView {
    
}

- (void)setupTabsWith:(OCTabsViewsObj *)tabs;
- (void)setDefaultSelectedTab;
- (void)setSelectedTab:(NSUInteger)tab;

@property (weak) id <OCTabsProtocol> delegate;

@end
