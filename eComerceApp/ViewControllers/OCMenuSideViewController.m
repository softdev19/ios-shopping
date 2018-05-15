//
//  OCMenuSideViewController.m
//  eComerceApp
//
//  Created by TarekIssa on 5/18/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCMenuSideViewController.h"
#import "OCSideMenuCell.h"
#import "OCSideMenuRowObj.h"
#import "OCWebPageViewController.h"
#import "OCTabarController.h"
#import "AppDelegate.h"

#define font     [UIFont systemFontOfSize:16]

@interface OCMenuSideViewController () <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, retain) NSArray* dataSource;
@property (weak, nonatomic) IBOutlet UIImageView *footerImage;

@end

@implementation OCMenuSideViewController


+(void)initialize {
    
    OCNavigationObj* navObj = [[OCPlistParser sharedOCPlistParser] getNavigationObject];

    if (navObj.imageDO != nil) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:navObj.imageDO.imageFileName] forBarMetrics:UIBarMetricsDefault];

    }else{
        if (navObj.color != nil) {
            [[UINavigationBar appearance] setBarTintColor:navObj.color];
            [[UINavigationBar appearance] setTranslucent:YES];
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    OCSideMenuObj* sideObj = [[OCPlistParser sharedOCPlistParser] getSideMenuObj];
    self.tableview.separatorColor = sideObj.separatorColor;
    self.dataSource = sideObj.menuListArray;
    self.view.backgroundColor = sideObj.color;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableview.separatorInset = UIEdgeInsetsZero;   //  UIEdgeInsetsMake(0, 0, 0, 0);
//    [self.tableview setTableFooterView:[[UIView alloc] init]];
    self.tableview.separatorInset = [self getSeparatorInsets];
    [self.footerImage setImage:[UIImage imageNamed:sideObj.footerImage.imageFileName]];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.footerImage sizeToFit];
    
    CGRect frame = self.footerImage.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height - 8;
    self.footerImage.frame = frame;
    
    CGPoint center = self.footerImage.center;
    center.x = self.tableview.frame.size.width / 2.0;
    self.footerImage.center = center;
    
    
    frame = self.tableview.frame;
    frame.size.height = self.view.frame.size.height - frame.size.height;
    frame.origin = CGPointZero;
    self.tableview.frame = frame;
}

- (UIEdgeInsets)getSeparatorInsets {
    int maxWidth = [self getSeparatorWidth];
    float inset = (self.tableview.frame.size.width - maxWidth) / 2.0;
    return UIEdgeInsetsMake(0, inset - 5, 0, inset - 5);
}

- (int)getSeparatorWidth {
    int max = 0;
    for (int i=0; i < self.dataSource.count; i++){

        OCSideMenuRowObj *obj = self.dataSource[i];
        int newMax = [self maximumWidthOfText:obj.title];
        
        if (newMax > max) {
            max = newMax;
        }
    }
    return max;
}

- (int)maximumWidthOfText:(NSString *)text {

    CGSize maximumSize = CGSizeMake(300, 9999);

    
    CGRect myStringSize = [text boundingRectWithSize:maximumSize
                       options:NSStringDrawingUsesLineFragmentOrigin
                    attributes:@{NSFontAttributeName: font}
                       context:nil];
    
    
//    CGSize myStringSize = [text sizeWithFont:font
//                               constrainedToSize:maximumSize
//                                   lineBreakMode:NSLineBreakByWordWrapping];
    return myStringSize.size.width;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OCSideMenuRowObj * obj = ((OCSideMenuRowObj *) self.dataSource[indexPath.row]);
    NSLog(@"Selected Url: %@", obj.url);
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    
    OCWebPageViewController* webpageViewController = [[OCWebPageViewController alloc] initWithNibName:@"OCWebPageViewController" bundle:nil andPageUrl:obj.url];

    UINavigationController* navCont = [[UINavigationController alloc] initWithRootViewController:webpageViewController];
    [webpageViewController setupNavigationForMenuSideStyle];
    navCont.view.backgroundColor =[ UIColor whiteColor];
    
    [window.rootViewController presentViewController:navCont animated:YES completion:nil];

}


#pragma mark - UITableViewDataSource


- (void)homeButtonTapped:(id)sender {
    NSLog(@"homeButtonTapped");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (OCSideMenuCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"OCSideMenuCell";
    
    OCSideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[OCSideMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.titleLabel setFont:font];
        cell.separatorInset = [self getSeparatorInsets];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.titleLabel.text = ((OCSideMenuRowObj *) self.dataSource[indexPath.row]).title;
    cell.titleLabel.textColor =((OCSideMenuRowObj *) self.dataSource[indexPath.row]).color;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // To "clear" the footer view
    return [UIView new];
}

@end
