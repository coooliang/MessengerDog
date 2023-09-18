//
//  InfoPlugin.m
//  J2NativeDemo
//
//  Created by chenliang on 2018/5/8.
//  Copyright © 2018年 zhsq. All rights reserved.
//

#import "InfoPlugin.h"

@implementation InfoPlugin {
    UIView *_keyboard;
}

#pragma mark - plugin methods

@Public(InfoPlugin,hello)
- (void)hello {
    if (self.message) {
        [self toSuccessCallback];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(test) userInfo:nil repeats:NO];
    }
}

@Public(InfoPlugin,world)
- (void)world {
    NSLog(@"world params = %@",self.message);
    [self gc];
}

@Singleton(InfoPlugin,keyboard)
- (void)keyboard {
    [_keyboard removeFromSuperview];
    _keyboard = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 300, 300)];
    _keyboard.backgroundColor = [UIColor blueColor];
    [self.wkWebView addSubview:_keyboard];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 100, 40)];
    [button setTitle:@"button" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [_keyboard addSubview:button];

    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(50, 110, 100, 40)];
    [close setTitle:@"close" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [_keyboard addSubview:close];
}

#pragma mark - click action
- (void)click {
    NSLog(@"click");
//    NSString *js = @"document.getElementById('test').value = '666';";
//    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
    [self toSuccessCallbackAsObject:@"123321"];
}
- (void)close {
    [_keyboard removeFromSuperview];
    [self gc];
}

- (void)test {
    [self toSuccessCallback]; // 成功回调
}

#pragma mark - private methods
- (int)privateMethod1:(NSString *)jsonString {
    return 0;
}

- (NSString *)privateMethod2:(NSString *)jsonString a:(NSString *)a {
    return @"";
}

- (void)privateMethod3:(NSString *)jsonString {
}

- (NSArray *)publishMethods {
    return @[@"hello", @"world"];
}

@end
