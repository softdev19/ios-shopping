//
//  OCsocialViewController.m
//  eComerceApp
//
//  Created by TarekIssa on 8/18/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCsocialViewController.h"
#import "OCSocialObj.h"
#import "OCWebPageViewController.h"
#import "JASidePanelController.h"

#define Space 10
#define Btn_H 60
#define Btn_W 300

@interface OCsocialViewController ()

@property (nonatomic, retain) NSArray* socialArr;
@property (nonatomic, retain) NSArray* buttonsArray;

@end

@implementation OCsocialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSocialArray:(NSArray *)socialArr {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        self.socialArr = [[NSArray alloc] initWithArray:socialArr];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    NSMutableArray *tempMutArr = [[NSMutableArray alloc] initWithCapacity:self.socialArr.count];
    
    for (int i = 0; i < self.socialArr.count; i++ ){
        OCSocialObj* socialObj = self.socialArr[i];
        [tempMutArr addObject:[self setupButtonFor:socialObj forButtonIndex:i]];
    }
    self.buttonsArray = [NSArray arrayWithArray:tempMutArr];
}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ocShowBar" object:nil];
    [self.view layoutSubviews];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    /*
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    int totalButtonsHeight = (int)self.socialArr.count * 60 + ((int)self.socialArr.count - 1) * Space;
    int defaultYposition = (screenHeight - totalButtonsHeight) / 2;
    
    UIButton* socialBtn = [[UIButton alloc] init];
    
    
    CGRect frame = socialBtn.frame;
    frame.size.height = Btn_H;
    frame.size.width = Btn_W;
    frame.origin.y = defaultYposition + (index * Btn_H) + (index * Space);
    socialBtn.frame = frame;
    
    CGPoint center = socialBtn.center;
    center.x = self.view.center.x;
    socialBtn.center = center;
*/
    int space = 5;
    float allButtonsHeights = 0;
    
    for (UIButton *button in self.buttonsArray) {
        [button sizeToFit];
        allButtonsHeights += button.frame.size.height + space;
    }
    
    float stayrtingYposition = (self.view.frame.size.height - allButtonsHeights) / 2.0;
    
    for (UIButton *button in self.buttonsArray) {

        
        CGPoint center = button.center;
        center.x = self.view.frame.size.width / 2.0;
        button.center = center;
        
        CGRect frame = button.frame;
        frame.origin.y = stayrtingYposition;
        button.frame = frame;
        
        stayrtingYposition += frame.size.height + space;
    }

}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    for (UIView *view in self.buttonsArray) {
        CGPoint center = view.center;
        center.x = self.view.frame.size.width / 2.0;
        view.center = center;
    }
}

- (id)setupButtonFor:(OCSocialObj *)socialObj forButtonIndex:(int)index{
    
    UIButton* socialBtn = [[UIButton alloc] init];
    
    NSString* imageName;
    if ([[socialObj.title lowercaseString] isEqualToString:@"facebook"]) {
        imageName = @"facebook.png";
    }else if ([[socialObj.title lowercaseString] isEqualToString:@"twitter"]) {
        imageName = @"twitter.png";
    }else if ([[socialObj.title lowercaseString] isEqualToString:@"pinterest"]) {
        imageName = @"pinterest.png";
    }else if ([[socialObj.title lowercaseString] isEqualToString:@"youtube"]) {
        imageName = @"youtube.png";
    }else if ([[socialObj.title lowercaseString] isEqualToString:@"instagram"]) {
        imageName = @"instagram.png";
    }else if ([[socialObj.title lowercaseString] isEqualToString:@"googlePlus"]) {
        imageName = @"google-plus.png";
    }
    
    [socialBtn sizeToFit];
    socialBtn.tag = index;
    [socialBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [socialBtn addTarget:self action:@selector(socialButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    socialBtn.backgroundColor = [UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:.6];
    [self.view addSubview:socialBtn];
    return socialBtn;
}

- (void) socialButtonTapped:(id)sender {
    UIButton* button = sender;
    OCWebPageViewController* webpageViewController = [[OCWebPageViewController alloc] initWithNibName:@"OCWebPageViewController" bundle:nil andPageUrl:((OCSocialObj *)self.socialArr[button.tag]).SocialPageUrl];
    webpageViewController.DoNotCheckRedirects = YES;
    [webpageViewController setupCartButtonOnRight];
    [webpageViewController setupNavigationInnerWithBackButton];
    [self.navigationController pushViewController:webpageViewController animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
