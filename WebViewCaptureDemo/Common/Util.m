//
//  Util.m
//  WebViewCaptureDemo
//
//  Created by yongliangP on 2016/11/14.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import "Util.h"

#define kWindowWidth        [UIScreen mainScreen].bounds.size.width
#define kWindowHeight       [UIScreen mainScreen].bounds.size.height
#define KeyWindow           [[UIApplication sharedApplication].delegate window]

@interface Util ()<UIWebViewDelegate>

{
    CapSuccessBlock _successBlock;//截屏成功的回调
    CapFailureBlock _failureBlock;//截屏失败的回调
}

@end

@implementation Util

static Util * util;

+(instancetype)shareUtil
{
    if (!util)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            util = [[Util alloc] init];
        });
    }
    return util;
}


/** 截屏 */
-(void)capturePicShareWitchUrl:(NSString*)url
                       success:(CapSuccessBlock) successBlock
                       failure:(CapFailureBlock) failureBlock;
{
    _successBlock = successBlock;
    _failureBlock = failureBlock;
    UIWebView * webView = [[UIWebView alloc] initWithFrame:KeyWindow.bounds];
    webView.delegate = self;
    webView.hidden = YES;
    NSMutableURLRequest *re2 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:re2];
    [KeyWindow addSubview:webView];
}


#pragma UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIImage * image = [self screenShotWithScrollView:webView.scrollView];
    UIImage * thumbImage = [self screenThumbShotWithScrollView:webView.scrollView];
    if (_successBlock)
    {
        _successBlock(image,thumbImage);
    }
    
    webView.delegate = nil;
    [webView removeFromSuperview];
    webView = nil;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (_failureBlock)
    {
        _failureBlock(error);
    }
}


//图片
- (UIImage *)screenShotWithScrollView:(UIScrollView *)scrollView
{
    UIImage* image;
    
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, [UIScreen mainScreen].scale);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil)
    {
        return image;
    }
    return nil;
}



// 缩略图图片
- (UIImage *)screenThumbShotWithScrollView:(UIScrollView *)scrollView
{
    UIImage* image;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kWindowWidth, kWindowHeight), NO, [UIScreen mainScreen].scale);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = KeyWindow.bounds;
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil)
    {
        return image;
    }
    return nil;
}


@end
