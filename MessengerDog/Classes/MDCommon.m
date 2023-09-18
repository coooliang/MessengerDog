//// 
//  MDCommon.m
//  Js2NativeDemo
//  Created by coooliang on 2023/5/23
//

#import "MDCommon.h"

@implementation MDCommon

+ (NSString *)joinStrings:(NSString *)str, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableArray *array = [NSMutableArray new];
    va_list args;
    if (str) {
        [array addObject:str];
        va_start(args, str);
        NSString *obj;
        while ((obj = va_arg(args, NSString *))) {
            [array addObject:obj];
        }
        va_end(args);
    }
    return [array componentsJoinedByString:@""];
}

@end
