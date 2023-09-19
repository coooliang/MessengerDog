//
//  MDURLFilter.h
//
//  Created by chenliang on 2018/7/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface MDPluginFilter : NSObject

- (BOOL)mapping:(NSString *)url webView:(WKWebView *)webView viewController:(UIViewController *)viewController;

@end
