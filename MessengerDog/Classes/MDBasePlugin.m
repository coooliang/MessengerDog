//
//  CLBasePlugin.m
//
//  Created by chenliang on 2018/7/17.
//

#import "MDBasePlugin.h"
#import <WebKit/WebKit.h>

typedef enum : NSUInteger {
    MDFailCallbackType = 0,
    MDSuccessCallbackType,
    MDGCCallbackType
} MDCallBackType;
@implementation MDBasePlugin


- (void)toSuccessCallback {
    [self callback:MDSuccessCallbackType msg:nil];
}
- (void)toSuccessCallbackAsObject:(id)obj {
    [self callback:MDSuccessCallbackType msg:obj];
}

- (void)toFailCallback {
    [self callback:MDFailCallbackType msg:nil];
}
- (void)toFailCallbackAsObject:(id)obj {
    [self callback:MDFailCallbackType msg:obj];
}

- (void)callback:(MDCallBackType)type msg:(id)msg {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:@{@"callbackId": _callbackId}];
    [result setObject:[NSString stringWithFormat:@"%d",type] forKey:@"callbackType"];
    if (msg) [result setObject:msg forKey:@"message"];
    if(injectJSType == ScanMDAnnotationType && (_autoGC || type == MDGCCallbackType)){
        [[NSNotificationCenter defaultCenter]postNotificationName:MD_GC_PLUGIN_NOTIFICATION object:self.callbackId];
        [result setObject:@"1" forKey:@"gc"];
    }
    if (self.wkWebView) {
        NSString *js = [NSString stringWithFormat:@"if(window.%@ && %@.callbackFromNative){%@.callbackFromNative(%@);}", MDConfig.mdJs2native, MDConfig.mdJs2native, MDConfig.mdJs2native, [result md_toJsonString]];
        if(MDConfig.mdEnableLog)MDLog(@"callbackFromNative js = %@", js);
        [self.wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError *_Nullable error) {
            if (error) {
                MDLog(@"error = %@", error);
            }
        }];
    }
}

- (void)gc {
    [self callback:MDGCCallbackType msg:nil];
}

- (void)dealloc {
    if(MDConfig.mdEnableLog)MDLog(@"%@ dealloc",[self class]);
}

@end
