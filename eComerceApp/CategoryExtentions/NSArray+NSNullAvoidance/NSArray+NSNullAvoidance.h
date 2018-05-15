//
//  NSArray+NSNullAvoidance.h
//  TvinciSDK
//
//  Created by Avraham Shukron on 9/2/12.
//  Copyright (c) 2012 Quickode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NSNullAvoidance)
-(NSArray *) arrayByRemovingNSNulls;
@end
