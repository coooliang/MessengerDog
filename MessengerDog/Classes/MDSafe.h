//// 
//  MDSafeString.h
//  MessengerDog
//  Created by coooliang on 2023/6/8
//

#import <Foundation/Foundation.h>


@interface MDSafe : NSObject

+ (NSString *)stringSafe:(NSString *)str;

+ (BOOL)isSafeArray:(NSArray *)array;

+ (BOOL)isSafeDictionary:(NSDictionary *)dict;

@end

