//
//  OCNavigationButtonsViewController.m
//  eComerceApp
//
//  Created by Tarek Issa on 30/11/2015.
//  Copyright © 2015 Tvinci. All rights reserved.
//

#import "OCNavigationButtonsViewController.h"
#import "OCCartButton.h"
#import "AppDelegate.h"
#import "OCSearchViewController.h"
#import "OCSearchObj.h"
#import "OCCartButton.h"

#define ImageInset 0

@interface OCNavigationButtonsViewController ()

@end

@implementation OCNavigationButtonsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)setupBackButton {
    
    if (!self.navigationItem.leftBarButtonItem) {
        UIBarButtonItem *buttonItem =  [self getBackItemWithSelector:@selector(backButtonTapped:)];
        self.navigationItem.leftBarButtonItem = buttonItem;
    }
}

- (void)setupCartButtonOnRight {
    
    if (!self.navigationItem.rightBarButtonItem) {
        UIBarButtonItem *cartButton =  [self getCartButton];
        UIBarButtonItem *searchButton = [self getSearchItem];
        cartButton.tintColor = [UIColor clearColor];
//        self.navigationItem.rightBarButtonItem = cartButton;
        searchButton.imageInsets = UIEdgeInsetsMake(0, 3*ImageInset, 0, -3*ImageInset);
        
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:cartButton, searchButton, nil]];
    }
}

- (void)setupCartButtonAndSearchOnRight {
    
    if (!self.navigationItem.rightBarButtonItem) {
        UIBarButtonItem *cartButton =  [self getCartButton];
        
        UIBarButtonItem *searchButton = [self getSearchItem];
        
        searchButton.imageInsets = UIEdgeInsetsMake(0, 3*ImageInset, 0, -3*ImageInset);

        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:cartButton, searchButton, nil]];

        
//        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 128, 64)];
//        [toolBar setBackgroundColor:[UIColor redColor]];
//        
//        //  Create cart button
//        OCCartButton *cartButton = [[OCCartButton alloc] init];
//        [cartButton removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
//        [cartButton addTarget:self action:@selector(cartButtonPressedd:) forControlEvents:UIControlEventTouchUpInside];
//        //  Positioning for cart button
//        [cartButton sizeToFit];
//        cartButton.center = CGPointMake(0, toolBar.frame.size.height/2.0);
//        CGRect frame = cartButton.frame;
//        NSLog(@"[cartButton imageForState:UIControlStateNormal].size.width: %f", [cartButton imageForState:UIControlStateNormal].size.width);
//        frame.size.width = [cartButton imageForState:UIControlStateNormal].size.width;
//        frame.origin.x = toolBar.frame.size.width - frame.size.width;
//        cartButton.frame = frame;
//        [cartButton setBackgroundColor:[UIColor greenColor]];
//        [toolBar addSubview:cartButton];
//        
//        //  Create search button
//        OCSearchObj* searchObj = [[OCPlistParser sharedOCPlistParser] getSearchObj];
//        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        UIImage *image = [[UIImage imageNamed:searchObj.image.imageFileName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        [searchButton setImage:image forState:UIControlStateNormal];
//        [searchButton removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
//        [searchButton addTarget:self action:@selector(searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        //  Positioning for search button
//        [searchButton sizeToFit];
//        searchButton.center = CGPointMake(0, toolBar.frame.size.height/2.0);
//        frame = searchButton.frame;
//        frame.origin.x = cartButton.frame.origin.x - frame.size.width;
//        searchButton.frame = frame;
//        [searchButton setBackgroundColor:[UIColor blueColor]];
//        [toolBar addSubview:searchButton];


        
        
//        UIBarButtonItem* barbutton = [[UIBarButtonItem alloc] initWithCustomView:toolBar];
//        [self.navigationItem setRightBarButtonItem:barbutton];
//        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//
//        spacer.width = 0;
//        
//        UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        
//        spacer2.width = -40;

        
//        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:spacer,cartButton, searchButton, nil]];
        

    }
    [self setupLogo];
    [self setupMenuButtonOnLeft];
}

- (void)setupMenuButtonOnLeft {
    UIBarButtonItem *buttonItem =[self getMenuItem];
    self.navigationItem.leftBarButtonItem = buttonItem;
}

- (void)menuButtonTapped:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCShowSideMenu object:nil];
}

- (void)backButtonTapped:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCHideLoad object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cartButtonPressedd:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCGoToCart object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Navigation Setups


- (void)setupNavigationForMenuSideStyle {
    [self setupLogo];
    [self setupClose];
}

- (void)setupMainWebScreenStyle {
    [self setupCartButtonOnRight];
    [self setupLogo];
    [self setupMenuButtonOnLeft];
}

- (void)setupNavigationInnerWithBackButton {
    
    [self setupBackButton];
    [self setupLogo];
}

- (void)setupBackButtonForCartPage {
    
    if (!self.navigationItem.leftBarButtonItem) {
        
        UIBarButtonItem *buttonItem =  [self getBackItemWithSelector:@selector(backFromCart)];
        self.navigationItem.leftBarButtonItem = buttonItem;
    }
}

- (void)setupLogo {
    
    OCNavigationObj* navObj = [[OCPlistParser sharedOCPlistParser] getNavigationObject];
    
    if (!self.navigationItem.titleView) {
        UIButton* logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        logoButton.adjustsImageWhenHighlighted = NO;
        UIImage* image = [UIImage imageNamed:navObj.logo.image.imageFileName];
        [logoButton setImage:image forState:UIControlStateNormal];
        [logoButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        [logoButton sizeToFit];
        logoButton.frame = CGRectMake(0, 0, logoButton.frame.size.width, logoButton.frame.size.height);
        self.navigationItem.titleView = logoButton;
    }
}

- (void)setupClose {
    if (!self.navigationItem.rightBarButtonItem) {
        UIBarButtonItem *buttonItem = [self getCloseItem];
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
}


#pragma mark - Selectors
- (void)searchButtonPressed:(id)sender {
    NSLog(@"searchButtonPressed");
    
    OCSearchViewController *searchViewController = [[OCSearchViewController alloc] init];
    
    UINavigationController *navigantionController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
//    navigantionController.viewControllers = @[ searchViewController ];
    
    navigantionController.navigationBar.translucent = YES;
    navigantionController.navigationBar.tintColor = [UIColor whiteColor];
    navigantionController.modalPresentationStyle = UIModalPresentationCustom;
    
    [navigantionController setNavigationBarHidden:YES animated:NO];
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:navigantionController animated:NO completion:nil];
}

- (void)closeButtonTapped:(id)sender {
    NSLog(@"closeButtonTapped");
    [[NSNotificationCenter defaultCenter] postNotificationName:OCGoToHome object:nil];
}

- (void)backFromCart {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCHideLoad object:nil];
}


- (void)dismissViewControlle:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:OCHideLoad object:nil];
    }];
}


#pragma mark - UIBarButtonItems

- (UIBarButtonItem *)getBackItemWithSelector:(SEL)selector {
    OCNavigationObj* navObj = [[OCPlistParser sharedOCPlistParser] getNavigationObject];
    UIImage *image = [[UIImage imageNamed:navObj.backButton.image.imageFileName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:selector];
    buttonItem.imageInsets = UIEdgeInsetsMake(0, -ImageInset, 0, ImageInset);
    
    return buttonItem;
}

//- (UIBarButtonItem *)getCartItem {
//    OCNavigationObj* navObj = [[OCPlistParser sharedOCPlistParser] getNavigationObject];
//    UIImage *image = [[UIImage imageNamed:navObj.rightButton.image.imageFileName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    
//    UIBarButtonItem *cartButton = [[UIBarButtonItem alloc] initWithImage:image
//                                                                   style:UIBarButtonItemStylePlain
//                                                                  target:self
//                                                                  action:@selector(cartButtonPressedd:)];
//    cartButton.imageInsets = UIEdgeInsetsMake(0, -ImageInset, 0, ImageInset);
//    
//    return cartButton;
//}

- (UIBarButtonItem *)getCartButton {
    
    OCCartButton *cartButton = [[OCCartButton alloc] init];

    [cartButton removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
    [cartButton addTarget:self action:@selector(cartButtonPressedd:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cartButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:cartButton];
    [cartButton sizeToFit];
    cartButton.contentEdgeInsets = UIEdgeInsetsMake(0, ImageInset, 0, -ImageInset);

    float x = cartButton.frame.size.width;
//    [cartButton setBackgroundColor:[UIColor redColor]];

    return cartButtonBarItem;
}

- (UIBarButtonItem *)getCloseItem {

    OCNavigationObj* navObj = [[OCPlistParser sharedOCPlistParser] getNavigationObject];
    UIImage *image = [[UIImage imageNamed:navObj.closeButton.image.imageFileName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(dismissViewControlle:)];
    buttonItem.imageInsets = UIEdgeInsetsMake(0, -ImageInset, 0, ImageInset);
    return buttonItem;
}

- (UIBarButtonItem *)getSearchItem {
    
    OCSearchObj* searchObj = [[OCPlistParser sharedOCPlistParser] getSearchObj];
    
    UIImage *image = [[UIImage imageNamed:searchObj.image.imageFileName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(searchButtonPressed:)];
    searchButton.imageInsets = UIEdgeInsetsMake(0, ImageInset, 0, -ImageInset);

    return searchButton;
}

- (UIBarButtonItem *)getMenuItem {
    
    OCNavigationObj* navObj = [[OCPlistParser sharedOCPlistParser] getNavigationObject];
    UIImage *image = [[UIImage imageNamed:navObj.leftButton.image.imageFileName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(menuButtonTapped:)];
    buttonItem.imageInsets = UIEdgeInsetsMake(0, -ImageInset, 0, ImageInset);
    
    return buttonItem;
}


//#pragma - Mark UINavigationControllerDelegate
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    
//    NSLog(@"willShowViewController");
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ocShowBar" object:nil];
//}
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    
//    NSLog(@"didShowViewController");
//}

@end
