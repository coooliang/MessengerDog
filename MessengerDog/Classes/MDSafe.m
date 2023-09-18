//// 
//  MDSafeString.m
//  MessengerDog
//  Created by coooliang on 2023/6/8
//

#import "MDSafe.h"

@implementation MDSafe

+ (NSString *)stringSafe:(NSString *)str {
    id obj = str;
    if (obj == nil || [obj isEqual:[NSNull null]] || [@"null"isEqualToString:obj] || [@"<null>"isEqualToString:obj] || [@"(null)"isEqualToString:obj]) {
        return @"";
    }else{
        return [NSString stringWithFormat:@"%@",obj];
    }
}

+ (BOOL)isSafeArray:(NSArray *)array {
    if(array && [array isKindOfClass:[NSArray class]] && array.count > 0){
        return YES;
    }
    return NO;
}

+ (BOOL)isSafeDictionary:(NSDictionary *)dict {
    if(dict && [dict isKindOfClass:[NSDictionary class]] && dict.count > 0){
        return YES;
    }
    return NO;
}
@end
