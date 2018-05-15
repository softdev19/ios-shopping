//
//  OCMenuPageCell.m
//  eComerceApp
//
//  Created by TarekIssa on 5/20/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCMenuPageCell.h"

@implementation OCMenuPageCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"OCMenuPageCell"
                                                          owner:nil
                                                        options:nil];
    
    if ([arrayOfViews count] < 1){
        return nil;
    }
    
    id obj = [arrayOfViews firstObject];
    
    self = nil;
    self = obj;
    
    return self;
}

@end
