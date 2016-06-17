//
//  PlayImgClickWebViewVC.m
//  DaDiJinRong
//
//  Created by and on 15/5/4.
//  Copyright (c) 2015年 and. All rights reserved.
//

#import "XFWebViewVC.h"

//适配iOS8.0以上
#import <WebKit/WebKit.h>
//适配iOS8.0以下
#import "WebViewJavascriptBridge.h"
#import "D3Generator.h"
#import "NSObject+D3.h"


//#import "UMSocial.h"
//UIWebView进度条
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "MiscTool.h"

@interface XFWebViewVC ()<WKScriptMessageHandler
,WKNavigationDelegate, WKUIDelegate
,UIWebViewDelegate //UIWebView代理
//, UMSocialUIDelegate // 友盟代理
, NJKWebViewProgressDelegate //UIWebView进度条代理
>
{
    NJKWebViewProgressView *_progressView; //WebView进度条
    NJKWebViewProgress *_progressProxy;
    
    //nav
    UIBarButtonItem *leftBtn;
    UIBarButtonItem *leftCloseBtn;
    UIButton *nav_share;

    UILabel *titleLabel;
    
    BOOL _firstLoad;
    
}
@property (weak, nonatomic) id webView;
@property(nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation XFWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavgitionBar];
    
    [self initData];
    [self initView];
}

#pragma mark - initNav
- (void)initNavgitionBar {
    
    leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBtnAction)];
    //添加左按钮
    leftCloseBtn = [[UIBarButtonItem alloc]
                                   initWithTitle:@"关闭"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                     action:@selector(leftCloseBtnAction)];
    [leftCloseBtn setAccessibilityElementsHidden:YES];
    [self.navigationItem setLeftBarButtonItems:@[leftBtn, leftCloseBtn]];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pc_edit_big"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBtnAction)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
}
//nav Action
- (void)leftBtnAction {

    if (ios8) {
        if (((WKWebView *)_webView).canGoBack) {
            [(WKWebView *)_webView goBack];
        } else {
            [self leftCloseBtnAction];
        }
    }else {
        if (((UIWebView *)_webView).canGoBack) {
            [(UIWebView *)_webView goBack];
        } else {
            [self leftCloseBtnAction];
        }
    }
    
    //判断是否显示关闭按钮
    if (ios8) {
        if (((WKWebView *)_webView).canGoBack) {
            [leftCloseBtn setAccessibilityElementsHidden:NO];
        } else {
            [leftCloseBtn setAccessibilityElementsHidden:YES];
        }
    }else {
        if (((UIWebView *)_webView).canGoBack) {
            [leftCloseBtn setAccessibilityElementsHidden:NO];
        } else {
            [leftCloseBtn setAccessibilityElementsHidden:YES];
        }
    }
}

- (void)leftCloseBtnAction {
    if ([self.navigationController.viewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightBtnAction {
    //分享
    
}

#pragma mark - init views and data
- (void)initData
{
    _firstLoad = YES;
}

- (void)initView
{
    NSLog(@"url = %@",_url);
    
    NSString *newURL = _url;
    //在网页接口后添加system（ios系统版本），iOS8以上为system=8, 否则为 system=7
    NSRange range = [newURL rangeOfString:@"?"];
    if (range.length > 0) {
        if (ios8) {
            newURL = [NSString stringWithFormat:@"%@&s=8", newURL];
        }else {
            newURL = [NSString stringWithFormat:@"%@&s=7", newURL];
        }
    }else {
        if (ios8) {
            newURL = [NSString stringWithFormat:@"%@?s=8", newURL];
        }else {
            newURL = [NSString stringWithFormat:@"%@?s=7", newURL];
        }
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:newURL]];
    if (ios8) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        // web内容处理池
        config.processPool = [[WKProcessPool alloc] init];
        
        config.userContentController = [[WKUserContentController alloc] init];
        [config.userContentController addScriptMessageHandler:self name:@"AppModel"];
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        [webView loadRequest:request];
        webView.navigationDelegate = self;
        [self.view addSubview:webView];
        [webView addObserver:self forKeyPath:@"loading" options:(NSKeyValueObservingOptionNew) context:nil];
        [webView addObserver:self forKeyPath:@"title" options:(NSKeyValueObservingOptionNew) context:nil];
        [webView addObserver:self forKeyPath:@"estimatedProgress" options:(NSKeyValueObservingOptionNew) context:nil];
        _webView = webView;
    }else {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [webView loadRequest:request];
        webView.delegate = self;
        webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
        _webView = webView;
        
        WebViewJavascriptBridge *bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"ObjC received message from JS: %@", data);
            responseCallback(@"报告: IOS收到！！！");
            
            [D3Generator createViewControllerWithDictAndPush:data];
        }];
        _bridge = bridge;
    }
    
    //添加导航栏下方的进度条
    CGFloat progressBarHeight = 2.0f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, 0, navigationBarBounds.size.width, progressBarHeight);
    if (ios8) {
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.progressColor = webProgressColor;
        _progressView.progress = 0;
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:_progressView];
    }else {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        ((UIWebView *)_webView).delegate = _progressProxy;
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.progressColor = webProgressColor;
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:_progressView];
    }
}

- (void)pushVCWithData:(NSDictionary *)dict {
    UIViewController *vc = [D3Generator createViewControllerWithDict:dict];
    if (!vc) {
        return;
    }
//    if ([[vc class] isEqual:[ProductsVC class]]) {
//        ProductsVC *pv = (ProductsVC *)vc;
//        pv.isFromMySSJHViewController = YES;
//        [[NSUserDefaults standardUserDefaults] setObject:@(XFPageTagDingfujin) forKey:notiForProJumpPage];
//    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [((UIWebView *)_webView) stringByEvaluatingJavaScriptFromString:@"document.title"];

//    if (((UIWebView *)_webView).canGoBack) {
//        nav_close.hidden = NO;
//    } else {
//        nav_close.hidden = YES;
//    }
}
#pragma mark -- UIWebView delegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [MiscTool showNetworkActivityIndicator];
    // HUD
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MiscTool hideNetworkActivityIndicatorVisible];
//    [self hideHUD];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MiscTool hideNetworkActivityIndicatorVisible];
//    [self hideHUD];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (_isShowWxService) {
        if (_firstLoad) {
            _firstLoad = NO;
        } else {
            [_webView stopLoading];
            [self dealPasteAndOpenURL];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark -- WKWebView delegate

//1.1.1 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"页面开始加载...");
    if (_isShowWxService) {
        if (_firstLoad) {
            _firstLoad = NO;
        } else {
            [_webView stopLoading];
            [self dealPasteAndOpenURL];
            return;
        }
    }
    [MiscTool showNetworkActivityIndicator];
    
}

- (void)dealPasteAndOpenURL {
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    [paste setStrings:@[@"dadijinrong"]];
//    [self showToastWithTitle:nil detail:@"贷你盈微信号已复制成功"];
    [self performSelector:@selector(openURLs) withObject:self afterDelay:1.5];
}

- (void)openURLs {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
}

//1.1.2 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"内容开始返回...");
}

//1.1.3 页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"页面加载完成...");
    [MiscTool hideNetworkActivityIndicatorVisible];
}

//1.1.4 页面加载失败时调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"页面加载失败...");
    [MiscTool hideNetworkActivityIndicatorVisible];
}
/**
 *  WKWebView 监控进度
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([[_webView class] isEqual:[WKWebView class]]) {
        if ([keyPath isEqualToString:@"loading"]) {
            NSLog(@"下载ing");
        } else if ([keyPath isEqualToString:@"title"]) {
            self.title = ((WKWebView *)_webView).title;
        } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
            CGFloat progress = ((WKWebView *)_webView).estimatedProgress;
            NSLog(@"progress = %lf",progress);
            _progressView.progress = progress;
        }
        if (!((WKWebView *)_webView).loading) {
            NSLog(@"完毕....");
            [MiscTool hideNetworkActivityIndicatorVisible];
            _progressView.progress = 1.0;
//            if (((UIWebView *)_webView).canGoBack) {
//                nav_close.hidden = NO;
//            } else {
//                nav_close.hidden = YES;
//            }

        }
    }
}
/**
 *  WKWebView 执行监控的js内容
 *
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"-- %@",message.name);
    
    if ([message.name isEqualToString:@"AppModel"]) {
        NSDictionary *data = message.body[@"body"]; //获取js中的数据
        NSLog(@"%@",data[@"className"]);
        NSString *className = data[@"className"];
        NSString *conFrom = data[@"comFrom"];
        UIViewController *vc = [[NSClassFromString(className) alloc] init];
//        if ([className isEqualToString:@"TestViewController"]) {
//            ((TestViewController *)vc).comFrom = conFrom;
//        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- 分享
- (void)shareAction:(UIButton *)sender {
    //NSString *url = [NSString stringWithFormat:@"%@",@"http://www.u22t.com"];
    //链接
    NSString *url = _url;
    if (_shareUrl && ![_shareUrl isEqualToString:@""]) {
        url = _shareUrl;
    }
    //标题
    NSString *title = titleLabel.text;
    if (_shareText && ![_shareText isEqualToString:@""]) {
        title = _shareText;
    }
    //描述
    NSString *shareDesc = titleLabel.text;
    if (_shareDesc && ![_shareDesc isEqualToString:@""]) {
        shareDesc = _shareDesc;
    }
    
    UIImage *image = [UIImage imageNamed:@"input_icon"];
    if (_shareImage) {
        image = _shareImage;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UMeng 统计
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    if (ios8 && _webView) {
        [_webView removeObserver:self forKeyPath:@"loading"];
        [_webView removeObserver:self forKeyPath:@"title"];
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];

    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
