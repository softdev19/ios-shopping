//
//  OCTransparretViewController.m
//  eComerceApp
//
//  Created by Tarek Issa on 02/12/2015.
//  Copyright © 2015 Tvinci. All rights reserved.
//

#import "OCTransparretViewController.h"

@interface OCTransparretViewController ()

@property (nonatomic, strong) UIVisualEffectView *bluredEffectView;

@end


@implementation OCTransparretViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.view.backgroundColor = [UIColor clearColor];
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
    
}

-(instancetype)init {
    self = [super init];
    if(self){
        self.view.backgroundColor = [UIColor clearColor];
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.alpha = 0.0;
//    [self addDarknerView];
    [self addBlurEffect];
    
    self.bluredEffectView.alpha = 1.0;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.alpha = 1.0;
                     } completion:^(BOOL finished) {
                     }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBlurEffect {
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    self.bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.bluredEffectView.userInteractionEnabled = NO;

    [self.view addSubview:self.bluredEffectView];
    [self.view sendSubviewToBack:self.bluredEffectView];
    
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.bluredEffectView.frame = frame;
}

- (void)makeClearBackground {
    self.view.alpha = 0.0;
}


@end
