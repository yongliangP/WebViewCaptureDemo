//
//  ViewController.m
//  WebViewCaptureDemo
//
//  Created by yongliangP on 16/9/6.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"
#import "Util.h"
#define KCapUrl @"http://api.haohaozhu.cn/index.php/Home/Guide/guide_detail?id=00000a702000097p"

@interface ViewController ()<UIWebViewDelegate,WKNavigationDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString * url = KCapUrl;
    
    WKWebView * wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    
    wkWebView.navigationDelegate = self;
    
    NSMutableURLRequest *re = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [wkWebView loadRequest:re];
    
    [self.view addSubview:wkWebView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"截图" style:UIBarButtonItemStylePlain target:self action:@selector(captureView:)];
    
     [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
     [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}


-(void)captureView:(UIBarButtonItem*)item
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.animationType  = MBProgressHUDAnimationZoom;
    hud.mode              = MBProgressHUDModeText;
    hud.detailsLabel.text = @"正在生成截图";
    hud.detailsLabel.font = [UIFont systemFontOfSize:17.0];
    
    [[Util shareUtil] capturePicShareWitchUrl:KCapUrl success:^(UIImage *image, UIImage *thumbImage) {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];

        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"截图成功，是否保存到相册" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            [self saveImageToPhotos: image];
            [self showPromptWithText:@"保存到相册成功" hideAfterdelay:1.5];
        }];
        
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}


- (MBProgressHUD *)showPromptWithText:(NSString *)text hideAfterdelay:(CGFloat)timeInterval
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
  
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.animationType  = MBProgressHUDAnimationZoom;
    hud.mode              = MBProgressHUDModeText;
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:17.0];
    hud.removeFromSuperViewOnHide = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
    return hud;
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
