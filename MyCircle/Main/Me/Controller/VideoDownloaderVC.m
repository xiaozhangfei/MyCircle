//
//  VideoDownloaderVC.m
//  MyCircle
//
//  Created by and on 15/12/14.
//  Copyright © 2015年 and. All rights reserved.
//

#import "VideoDownloaderVC.h"
#import "MQLResumeManager.h"

#import "XFAPI.h"
@interface VideoDownloaderVC ()

@property (nonatomic, strong) MQLResumeManager *manager;

@property (nonatomic, strong) UIImageView *imageWithBlock;
@property (nonatomic, strong) NSString *targetPath;

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *lab;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation VideoDownloaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)initView {
    self.title = @"断点下载";
    
    //设置对应的导航条的返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction:)];
    
    _imageWithBlock = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, 200)];
    [self.view addSubview:_imageWithBlock];
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
    _progressView.progress = 0;
    _progressView.frame = CGRectMake(20, 300, _imageWithBlock.frame.size.width, 2);
    [self.view addSubview:_progressView];
    
    _lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 320, _imageWithBlock.frame.size.width, 40)];
    _lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lab];
    
    UIButton *requestBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    requestBtn.frame = CGRectMake(20, 380, 100, 40);
    [requestBtn setTitle:@"请求" forState:(UIControlStateNormal)];
    [requestBtn addTarget:self action:@selector(requestBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:requestBtn];
    
    UIButton *cancenlBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    cancenlBtn.frame = CGRectMake(100, 380, 100, 40);
    [cancenlBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancenlBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:cancenlBtn];
    
    _deleteBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _deleteBtn.frame = CGRectMake(20, 450, 100, 40);
    [_deleteBtn setTitle:@"删除文件" forState:(UIControlStateNormal)];
    [_deleteBtn addTarget:self action:@selector(delBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _deleteBtn.hidden = YES;
    [self.view addSubview:_deleteBtn];
    
}

- (void)initData {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    NSArray *ar = [self getAllFileNames:@"image"];
    NSLog(@"%@",ar);
}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//获取Documents目录下dirName文件夹下的文件列表
- (NSArray *) getAllFileNames:(NSString *)dirName
{
    // 获得此程序的沙盒路径
    NSArray *patchs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // 获取Documents路径
    // [patchs objectAtIndex:0]
    NSString *documentsDirectory = [patchs objectAtIndex:0];
    NSString *fileDirectory = [documentsDirectory stringByAppendingPathComponent:dirName];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:fileDirectory error:nil];
    return files;
}

- (void)requestBtnAction:(UIButton *)sender {
    //1.准备
    if (self.manager) {
        
        [self cancelBtnAction:nil];
    }
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    // 判断文件夹是否存在，如果不存在，则创建
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *createPath = [NSString stringWithFormat:@"%@/image",documentsDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        //[fileManager createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileDir is exists.");
    }
    self.targetPath = [documentsDirectory stringByAppendingPathComponent:@"image/11.png"];
    
    NSURL *url = [NSURL URLWithString:[XFAPI image_url:@"08a72a89ed1c1ceb8974792025d2e4e8"]];
    __weak typeof (self) weakSelf = self;
    self.manager = [MQLResumeManager resumeManagerWithURL:url targetPath:self.targetPath success:^{
        
        NSLog(@"success");
        weakSelf.imageWithBlock.image = [UIImage imageWithContentsOfFile:weakSelf.targetPath];
        weakSelf.deleteBtn.hidden = NO;
        [weakSelf initData];
    } failure:^(NSError *error) {
        
        NSLog(@"failure");
        
    } progress:^(long long totalReceivedContentLength, long long totalContentLength) {
        
        float percent = 1.0 * totalReceivedContentLength / totalContentLength;
        NSString *strPersent = [[NSString alloc]initWithFormat:@"%.f", percent *100];
        weakSelf.progressView.progress = percent;
        weakSelf.lab.text = [NSString stringWithFormat:@"已下载%@%%", strPersent];
    }];
    
    //2.启动
    [self.manager start];
}
- (void)cancelBtnAction:(id )sender {
    [self.manager cancel];
    self.manager = nil;
}
- (void)delBtnAction:(UIButton *)sender {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    [manager removeItemAtPath:self.targetPath error:&error];
    
    if (error == nil) {
        
        self.imageWithBlock.image = [UIImage imageWithContentsOfFile:self.targetPath];
        self.progressView.progress = 0;
        self.lab.text = nil;
        
        self.deleteBtn.hidden = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
