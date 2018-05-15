//
//  NSDictionary+NSNullAvoidance.h
//  tvinci-ios-framework
//
//  Created by Avraham Shukron on 5/8/12.
//  Copyright (c) 2012 Quickode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSNullAvoidance)
-(id) objectOrNilForKey:(id)aKey;
-(NSDictionary *) dictionaryByRemovingNSNulls;
@end

@interface NSMutableDictionary (NSNullAvoidance)
-(void) setObjectOrNil : (id) object forKey : (id) key;
-(void) setObjectOrNSNull:(id)object forKey:(id)key;
@end
