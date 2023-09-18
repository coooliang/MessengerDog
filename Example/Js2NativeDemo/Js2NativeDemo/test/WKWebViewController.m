//
//  WKWebViewController.m
//  Js2NativeDemo
//
//  Created by chenliang on 2018/8/20.
//  Copyright © 2018年 chenl. All rights reserved.
//

#import "MDPluginFilter.h"
#import "WKWebViewController.h"
#import <Availability.h>
#import <WebKit/WebKit.h>

#import "MessengerDog.h"

@interface WKWebViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@end

@implementation WKWebViewController {
    WKWebView *_webView;
    MDPluginFilter *_urlFilter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _urlFilter = [[MDPluginFilter alloc] init];
    if (@available(iOS 8.0, *)) {
        // Build Phases --> Link Binary With Libraries --> add WebKit.framework
        MDConfig.mdEnableLog = YES;
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:[MDInjectJS js] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        WKUserContentController *userContent = [[WKUserContentController alloc] init];
        [userContent addUserScript:userScript];
        [userContent addScriptMessageHandler:self name:MDConfig.mdScriptMessageName];
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContent;
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        if (@available(iOS 16.4, *))_webView.inspectable = YES;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [self.view addSubview:_webView];

        NSString *path = [[NSBundle mainBundle] bundlePath];
        path = [path stringByAppendingPathComponent:@"index.html"];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20]];
    }
}

#pragma mark - WKNavigationDelegate
// 在发送请求之前，决定是否跳转 1
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = navigationAction.request.URL.absoluteString;
    if ([_urlFilter mapping:url webView:webView viewController:self]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([MDConfig.mdScriptMessageName isEqualToString:message.name]) {
        [_urlFilter mapping:message.body webView:_webView viewController:self];
    }
}

#pragma mark - WKWebView WKUIDelegate
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
}
@end
