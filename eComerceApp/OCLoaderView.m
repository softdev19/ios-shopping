//
//  OCLoaderView.m
//  eComerceApp
//
//  Created by Tarek Issa on 03/12/2015.
//  Copyright © 2015 Tvinci. All rights reserved.
//

#import "OCLoaderView.h"
#import "MMMaterialDesignSpinner.h"


#define Spinner_Width 30

@interface OCLoaderView ()

@property (strong, nonatomic) MMMaterialDesignSpinner *spinnerView;;

@end

@implementation OCLoaderView

-(instancetype)init {
    
    self = [super init];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        //        self.modalPresentationStyle = UIModalPresentationCustom;
        [self addSpinner];
    }
    return self;
}

- (void)addSpinner {
    _spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, Spinner_Width, Spinner_Width)];
    
    _spinnerView.tintColor = [[OCPlistParser sharedOCPlistParser] getLoaderColor];
    _spinnerView.lineWidth = 2;
    _spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
    _spinnerView.userInteractionEnabled = NO;
    _spinnerView.hidesWhenStopped = YES;
    [_spinnerView stopAnimating];
//    _spinnerView.alpha = 0.0;
    [_spinnerView startAnimating];
    [self addSubview:_spinnerView];
    
//    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        _spinnerView.alpha = 1.0;
//    } completion:^(BOOL finished) {
//        
//    }];
    

}

-(void)layoutSubviews {
    [super layoutSubviews];
    _spinnerView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0 + 30);

}


+ (OCLoaderView *)showLoaderOnTarget:(UIView *)targetView andDelegate:(id<OCLoaderViewProtocol>)delegate {
    OCLoaderView* loader =[[OCLoaderView alloc] init];
    loader.delegate = delegate;
    
    CGRect frame = targetView.frame;
    frame.origin = CGPointZero;
    [targetView setFrame:frame];
    
    [targetView addSubview:loader];
    
    [loader startLoading];
    return loader;
}

- (void)removeLoader {
    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

- (void)startLoading {
    [_spinnerView startAnimating];
}

- (void)stopLoading {
    [_spinnerView stopAnimating];
}

+ (void)removeLoaderFromTarget:(UIView *)targetView {
    for (UIView *subview in targetView.subviews) {
        if ([subview isKindOfClass:[OCLoaderView class]]) {
            [((OCLoaderView*)subview) removeLoader];
            return ;
        }
    }
}

@end
