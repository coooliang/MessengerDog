//// 
//  NSObject+MessengerDog.h
//  MessengerDog
//  Created by coooliang on 2023/6/9
//

#import <Foundation/Foundation.h>

@interface NSObject (MessengerDog)

@end

@interface NSString (MessengerDog)

- (NSDictionary *)md_urlParmas;

- (NSDictionary *)md_dictionaryFromJSONString;

- (NSString *)md_filterArgument;

- (NSString *)md_pojo;

- (NSString *)md_trim;

@end

@interface NSDictionary (MessengerDog)

- (NSString *)md_toJsonString;

@end


@interface NSMutableArray (MessengerDog)

- (void)md_uniqueAdd:(NSObject *)obj;

@end
