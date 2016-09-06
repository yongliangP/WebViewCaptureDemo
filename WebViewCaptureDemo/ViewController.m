//
//  ViewController.m
//  WebViewCaptureDemo
//
//  Created by yongliangP on 16/9/6.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
@interface ViewController ()<UIWebViewDelegate,WKNavigationDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString * url = @"http://www.jianshu.com";
    
    WKWebView * wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    
    wkWebView.navigationDelegate = self;
    
    NSMutableURLRequest *re = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [wkWebView loadRequest:re];
    
    [self.view addSubview:wkWebView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"截图分享" style:UIBarButtonItemStylePlain target:self action:@selector(captureView:)];
}


-(void)captureView:(UIBarButtonItem*)item
{
    
    NSString * url = @"http://www.jianshu.com";
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    
    webView.hidden = YES;
    
    NSMutableURLRequest *re2 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:re2];
    
    [self.view addSubview:webView];
    
}


#pragma UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self saveImageToPhotos: [self screenShotWithScrollView:webView.scrollView]];
    
     webView.delegate = nil;
    
    [webView removeFromSuperview];
    
     webView = nil;
    
}


#pragma mark - 保存图片
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


#pragma mark - 保存截图到相册

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    });
    
}

//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL)
    {
        msg = @"保存图片失败" ;
    }else
    {
        msg = @"保存图片成功" ;
    }
    
    NSLog(@"%@",msg);
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
