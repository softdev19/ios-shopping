//
//  OCTabsView.m
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCTabsView.h"
#import "OCTabObj.h"
#import "OCTabsViewsObj.h"
#import "OCImageDataObj.h"
#import "OCTabsViewsObj.h"

@interface OCTabsView()

@property (nonatomic, retain) NSArray *tabsArray;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;

@end

@implementation OCTabsView


- (void)dealloc
{
    [self unRegisterNotifications];
}

- (instancetype)init
{
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"OCTabsView"
                                                          owner:nil
                                                        options:nil];
    
    if ([arrayOfViews count] < 1){
        return nil;
    }
    
    OCTabsView *newView = [arrayOfViews firstObject];
    
    self = nil;
    self = newView;
    [self registerNotifications];

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self init];
    if (self) {
        [self setFrame:frame];
        [self registerNotifications];
    }
    return self;
}

#pragma - Mark Notification Center Handler
- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webViewIsScrolling:) name:@"ocWebviewDragging" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocWebviewEndDragging:) name:@"ocWebviewEndDragging" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocWebviewWillBeginDragging:) name:@"ocWebviewWillBeginDragging" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocShowBar:) name:@"ocShowBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocHideBar:) name:@"ocHideBar" object:nil];

}

- (void)unRegisterNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ocWebviewDragging" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ocWebviewEndDragging" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ocWebviewWillBeginDragging" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ocShowBar" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma - Mark Notification Methods
- (void)ocShowBar:(NSNotification *)aNotification {
    [self showBar];
}

- (void)ocHideBar:(NSNotification *)aNotification {
    [self hideBar];
}

- (void)ocWebviewWillBeginDragging:(NSNotification *)aNotification {

    NSNumber *isDirectionUp = aNotification.object;
    BOOL isUp = [isDirectionUp boolValue];

    if (!isUp) {
        [self showBar];
    }
    
}

- (void)webViewIsScrolling:(NSNotification *)aNotification {
    NSNumber *isDirectionUp = aNotification.object;
    BOOL isUp = [isDirectionUp boolValue];
    
    CGFloat statusBarOffset = [UIApplication sharedApplication].statusBarFrame.size.height - 20;
    
    CGRect frame = self.frame;
    if (!isUp) {
        if ([self isBarHidden]) {
            return;
        }
        if (frame.origin.y > ([UIScreen mainScreen].bounds.size.height - frame.size.height - statusBarOffset)) {
            frame.origin.y --;
        }else{
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height - statusBarOffset;
        }
    }else{
        if (frame.origin.y < ([UIScreen mainScreen].bounds.size.height - statusBarOffset)) {
            frame.origin.y ++;
        }else{
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - statusBarOffset;
        }

    }
    
    self.frame = frame;

}

- (void)ocWebviewEndDragging:(NSNotification *)aNotification {
//    ocWebviewEndDragging
    NSNumber *isDirectionUp = aNotification.object;
    BOOL isUp = [isDirectionUp boolValue];

    if (!isUp) {
        [self showBar];
    }else{
        [self hideBar];
    }
}

#pragma - Mark Show/Hide Bar
- (void)showBar {
    CGRect frame = self.frame;
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height - 20;
    
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height - statusBarHeight;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = frame;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)hideBar {
    CGRect frame = self.frame;

    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = frame;
                     } completion:^(BOOL finished) {
                         
                     }];
    


}

- (BOOL)isBarShown {
    CGRect frame = self.frame;
    return ((frame.origin.y <= ([UIScreen mainScreen].bounds.size.height - frame.size.height)) &&
            (frame.origin.y > ([UIScreen mainScreen].bounds.size.height)));
}

- (BOOL)isBarHidden {
    CGRect frame = self.frame;
    return frame.origin.y == ([UIScreen mainScreen].bounds.size.height);
}


- (void)setupTabsWith:(OCTabsViewsObj *)tabs {
    if (tabs.imageDO != nil) {
        [self setupBacground:tabs.imageDO];
    }else{
        [self.backgroundImage setBackgroundColor:tabs.color];
    }
    
    [self setupTabsWithTabsArray:tabs.tabsDOArray];
    
    [self setDefaultSelectedTab];
}

- (void)setupBacground:(OCImageDataObj *)image {
    UIImage* bgImage = [UIImage imageNamed:image.imageFileName];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = bgImage.size.height;
    CGFloat y = [UIScreen mainScreen].bounds.size.height - height;

    CGRect frame = self.frame;
    frame.size.height = bgImage.size.height;
    self.frame = CGRectMake(0, y, width, height);
    
    [self.backgroundImage setImage:bgImage];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float tabWidth = self.frame.size.width / self.tabsArray.count;

//    for (UIButton* button in self.tabsArray) {
    for (int i=0; i < self.tabsArray.count; i++) {
        UIButton* button = self.tabsArray[i];

        button.frame = CGRectMake(0, 0, tabWidth, tabWidth);
        button.center = CGPointMake((tabWidth / 2.0) + i * tabWidth, self.frame.size.height / 2.0);
        CGRect frame = button.frame;

        button.frame = frame;
        
//        int topBottom = (button.frame.size.height - button.imageView.image.size.height ) / 2;
//        int leftRight = (button.frame.size.width - button.imageView.image.size.width) / 2;
//        
//        button.imageEdgeInsets = UIEdgeInsetsMake(topBottom,leftRight,topBottom,leftRight);

    }
}

- (void)setupTabsWithTabsArray:(NSArray *)array {
    for (UIView* view in self.tabsArray) {
        [view removeFromSuperview];
    }
    self.tabsArray = nil;
    
    NSMutableArray* mutArr = [NSMutableArray array];
    
    for (int i = 0; (i < array.count) && (i < 5); i++) {
        OCTabObj* tabOD = array[i];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage* iconOffImage = [UIImage imageNamed:tabOD.iconOff.imageFileName];
        UIImage* iconOnImage = [UIImage imageNamed:tabOD.iconOn.imageFileName];
//        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        button.contentMode = UIViewContentModeScaleAspectFit;

        [button setBackgroundColor:[UIColor clearColor]];
        
        button.tag = i;
        [button setImage:iconOffImage forState:UIControlStateNormal];
        [button setImage:iconOnImage forState:UIControlStateSelected];
        
//        button.contentMode = UIViewContentModeScaleAspectFit;
//        button.imageView.contentMode = UIViewContentModeCenter;
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;

        
        [button addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.adjustsImageWhenHighlighted = NO;
        [mutArr addObject:button];
        [self addSubview:button];
    }
    
    self.tabsArray = [NSArray arrayWithArray:mutArr];
    [self layoutSubviews];
}

- (void)setDefaultSelectedTab{
    OCTabsViewsObj* tabs = [[OCPlistParser sharedOCPlistParser] getTabsObject];
    [self tabTapped:[self.tabsArray objectAtIndex:tabs.selectedTabIndex]];
}

- (void)setSelectedTab:(NSUInteger)tab {
    if (self.tabsArray.count > tab) {
        [self tabTapped:[self.tabsArray objectAtIndex:tab]];
    }
}

- (void)tabTapped:(UIButton *)tabButton {
    
    
    for (UIButton* btn in self.tabsArray) {
        if (btn != tabButton) {
            btn.selected = NO;
        }
    }
    
//    if (!tabButton.selected) {
        tabButton.selected = YES;
        if ([self.delegate respondsToSelector:@selector(tabsTappedAtIndex:)]) {
            [self.delegate tabsTappedAtIndex:tabButton.tag];
        }
//    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
