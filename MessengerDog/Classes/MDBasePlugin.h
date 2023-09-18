//
//  CLBasePlugin.h
//
//  Created by chenliang on 2018/7/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MessengerDog.h"

@interface MDBasePlugin : NSObject

#pragma mark -
@property(nonatomic, strong) UIViewController *viewController;
@property(nonatomic, strong) WKWebView *wkWebView;
@property(nonatomic, strong) NSString *callbackId;

@property(nonatomic, strong) NSString *execName;

@property(nonatomic, assign) BOOL autoGC;
@property(nonatomic, strong) NSDictionary *message;

#pragma mark -
- (void)toSuccessCallback;
- (void)toFailCallback;

- (void)toSuccessCallbackAsObject:(id)obj;
- (void)toFailCallbackAsObject:(id)obj;

- (void)gc;

@end
