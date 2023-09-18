//// 
//  UrlPlugin.m
//  Js2NativeDemo
//  Created by coooliang on 2023/5/19
//

#import "UrlPlugin.h"

@implementation UrlPlugin

@Singleton(UrlPlugin,nextStepJson)
- (void)nextStepJson {
    NSLog(@"nextStepJson message = %@",self.message);
}

@end
