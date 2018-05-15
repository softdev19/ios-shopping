//
//  OCCartButton.m
//  eComerceApp
//
//  Created by Tarek Issa on 5/22/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCCartButton.h"
#import <QuartzCore/QuartzCore.h>

@interface OCCartButton ()

@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) UIView* wedjetView;
@end

@implementation OCCartButton
static int wedjeNum;


- (void)dealloc
{
    [self unRegisterNotifications];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self setup];
//    }
//    return self;
//}

- (void)setup {
    [self registerNotifications];
    [self addWedge];
//    self.imageView.contentMode = UIViewContentMode

}

- (void)addWedge {
    
    OCNavigationObj* navObj = [[OCPlistParser sharedOCPlistParser] getNavigationObject];
    UIImage *image = [[UIImage imageNamed:navObj.rightButton.image.imageFileName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSLog(@"CartIcon : %@", navObj.rightButton.image.imageFileName);
    [self setImage:image forState:UIControlStateNormal];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;

    self.wedjetView = [[UIView alloc] initWithFrame:CGRectMake(image.size.width * (navObj.rightButton.cartTotal.left/100) - 7, image.size.height * (navObj.rightButton.cartTotal.top/100) - 7, 14, 14)];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    
    self.wedjetView.backgroundColor = navObj.rightButton.cartTotal.bgColor;
    self.wedjetView.layer.cornerRadius = 6;
    self.wedjetView.layer.masksToBounds = YES;
    
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = navObj.rightButton.cartTotal.txtColor;
    self.label.font = [UIFont fontWithName:self.label.font.fontName size:12];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.adjustsFontSizeToFitWidth = YES;
    
    [self.wedjetView addSubview:self.label];
    self.wedjetView.userInteractionEnabled = NO;
    [self addSubview:self.wedjetView];

    [self setBackgroundColor:[UIColor clearColor]];
    [self updateWdedge];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.label sizeToFit];
    if (self.label.frame.size.width < 14) {
        CGRect frame = self.label.frame;
        frame.size = CGSizeMake(14, 14);
        self.label.frame = frame;
    }
    
    CGRect frame = self.wedjetView.frame;
    frame.size = CGSizeMake(self.label.frame.size.width, 14);
    self.wedjetView.frame = frame;

    self.wedjetView.layer.cornerRadius = self.wedjetView.frame.size.height / 2.0;

    self.label.center = CGPointMake(self.wedjetView.frame.size.width / 2.0, self.wedjetView.frame.size.height / 2.0);
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartNumberChanged:) name:OCCartUpdated object:nil];
}

- (void)unRegisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OCCartUpdated object:nil];
}


- (void)cartNumberChanged:(NSNotification *)aNotification {
    NSLog(@"cartNumberChanged");
    
    int cartNum = [aNotification.object intValue];
    wedjeNum = cartNum;
    [self updateWdedge];
    
}

- (void)updateWdedge {

    NSString* str = @"";

    if (wedjeNum <= 0) {
        self.wedjetView.hidden = YES;
    } else {

        str = [NSString stringWithFormat:@"%d", wedjeNum];
        self.wedjetView.hidden = NO;
    }

    self.label.text = str;
}

-(void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    [super setContentEdgeInsets:contentEdgeInsets];
    
    CGRect frame = self.wedjetView.frame;
    frame.origin.x += contentEdgeInsets.left;
    self.wedjetView.frame = frame;
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
