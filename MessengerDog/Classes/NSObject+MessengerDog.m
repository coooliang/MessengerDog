//// 
//  NSObject+MessengerDog.m
//  MessengerDog
//  Created by coooliang on 2023/6/9
//

#import "NSObject+MessengerDog.h"
#import "MDCommon.h"
#import "MDSafe.h"

@implementation NSObject (MessengerDog)

@end

@implementation NSString (MessengerDog)

- (NSDictionary *)md_urlParmas {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *arr = [self componentsSeparatedByString:@"&"];
    if (arr && arr.count > 0) {
        for (NSString *param in arr) {
            NSArray *temp = [param componentsSeparatedByString:@"="];
            if (temp && temp.count == 2) {
                NSString *key = temp.firstObject;
                NSString *value = [temp.lastObject md_filterArgument];
                [params setObject:value forKey:key];
            }
        }
        return params;
    }
    return nil;
}


- (NSDictionary *)md_dictionaryFromJSONString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    return result;
}

- (NSString *)md_filterArgument {
    if([@"undefined" isEqualToString:self] || [self isEqual:[NSNull null]]){
        return @"";
    }else if([self isKindOfClass:[NSString class]]){
        return [self stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    }
    return self;
}

- (NSString *)md_pojo {
    if (self && self.length > 1) {
        return [NSString stringWithFormat:@"%@%@", [[self lowercaseString] substringToIndex:1], [self substringFromIndex:1]];
    }
    return self;
}

- (NSString *)md_trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//去除空格和换行
}

@end

@implementation NSDictionary (MessengerDog)

- (NSString *)md_toJsonString {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return MDSafeString(json);
}

@end

@implementation NSMutableArray (MessengerDog)

- (void)md_uniqueAdd:(NSObject *)obj {
    if(![self containsObject:obj]){
        [self addObject:obj];
    }
}

@end
