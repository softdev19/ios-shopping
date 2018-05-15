//
//  OCLauncherViewController.m
//  eComerceApp
//
//  Created by Tarek Issa on 30/11/2015.
//  Copyright © 2015 Tvinci. All rights reserved.
//

#import "OCLauncherViewController.h"
#import "OCLoaderView.h"

@interface OCLauncherViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *fullScreenImageView;
@property (nonatomic, strong) UIVisualEffectView *bluredEffectView;
@property (nonatomic, strong) OCLoaderView *loaderView;

@end

@implementation OCLauncherViewController

- (void)dealloc
{
    [self.loaderView removeLoader];
}

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
    
    [self addBlurEffect];
    [self setupImage];
    [self performSelector:@selector(showLoader) withObject:nil afterDelay:.1];
}


- (void)setupImage {
    NSString *launchImageName;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([UIScreen mainScreen].bounds.size.height == 480) launchImageName = @"LaunchImage-700@2x.png"; // iPhone 4/4s, 3.5 inch screen
        if ([UIScreen mainScreen].bounds.size.height == 568) launchImageName = @"LaunchImage-700-568h@2x.png"; // iPhone 5/5s, 4.0 inch screen
        if ([UIScreen mainScreen].bounds.size.height == 667) launchImageName = @"LaunchImage-800-667h@2x.png"; // iPhone 6, 4.7 inch screen
        if ([UIScreen mainScreen].bounds.size.height == 736) launchImageName = @"LaunchImage-800-Portrait-736h@3x.png"; // iPhone 6+, 5.5 inch screen
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if ([UIScreen mainScreen].scale == 1) launchImageName = @"LaunchImage-700-Portrait~ipad.png"; // iPad 2
        if ([UIScreen mainScreen].scale == 2) launchImageName = @"LaunchImage-700-Portrait@2x~ipad.png"; // Retina iPads
    }
    [self.fullScreenImageView setImage:[UIImage imageNamed:launchImageName]];
}

- (void)showLoader {
    self.loaderView = [OCLoaderView showLoaderOnTarget:self.view andDelegate:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIView animateWithDuration:0.75
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.bluredEffectView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                     }
     ];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.bluredEffectView.frame = frame;
    
    self.loaderView.frame = frame;
}

- (void)addBlurEffect {
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.bluredEffectView.userInteractionEnabled = NO;
    self.bluredEffectView.alpha = 0.0;
    [self.view addSubview:self.bluredEffectView];
//    [self.view sendSubviewToBack:self.bluredEffectView];
    
}

-(void)dismissAnimated {

    [self.loaderView removeLoader];
    [UIView animateWithDuration:0.65
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.fullScreenImageView.alpha = 0.0;
                         self.bluredEffectView.alpha = 0.2;
                         self.fullScreenImageView.layer.affineTransform = CGAffineTransformMakeScale(10, 10);
                         self.view.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self dismissViewControllerAnimated:NO completion:nil];
                     }
     ];

    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
