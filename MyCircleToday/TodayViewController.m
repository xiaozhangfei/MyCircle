//
//  TodayViewController.m
//  MyCircleToday
//
//  Created by and on 16/2/19.
//  Copyright © 2016年 and. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <AFHTTPRequestOperationManager.h>
//#import "XFAPI.h"
#import "TodayModel.h"
#import <UIImageView+WebCache.h>
@interface TodayViewController () <NCWidgetProviding, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *todayTV;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UILabel *moreLabel;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //使用preferredContentSize设置大小 且只用设置高度就好了
    self.preferredContentSize = CGSizeMake(0, 170);
    
    _dataSource = [NSMutableArray array];
    
    _todayTV = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    [self.view addSubview:_todayTV];
    _todayTV.delegate = self;
    _todayTV.dataSource = self;
    _todayTV.tableFooterView = [self returnFooterView];
    [_todayTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultChaneg:) name:NSUserDefaultsDidChangeNotification object:nil];

    //[self getData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData:^(NCUpdateResult result) {
        if (result == NCUpdateResultNewData) {
            [self resetTableView];
            
        }else if (result == NCUpdateResultFailed) {
            NSLog(@"网络下载出错啦！");
            
        }else if (result == NCUpdateResultNoData) {
            NSLog(@"没有最新数据！");
        }
    }];
}


//- (void)getData11 {
//    __weak typeof(self) weakSelf = self;
//    NSString *urlString = @"http://www.u22t.com/home/index/adcon";
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[[NSOperationQueue alloc] init]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                               
//                               if (error) {
//                                   //handler(NCUpdateResultFailed);
//                                   [weakSelf todayHandle:@{@"code": [NSString stringWithFormat:@"%ld", error.code]}];
//
//                               } else {
//                                   NSDictionary *di = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                                   [weakSelf todayHandle:@{@"code":@"201"}];
//
//                               }
//                           }];
//}
//


- (void)getData:(void (^)(NCUpdateResult result))handler {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFJSONRequestSerializer *serializer = [[AFJSONRequestSerializer alloc] init];
    [serializer setValue:@"1" forHTTPHeaderField:@"UID"];
    [serializer setValue:@"123" forHTTPHeaderField:@"TOKEN"];
    [serializer setValue:@"iOS" forHTTPHeaderField:@"DEVICE"];
    [serializer setValue:@"1.0" forHTTPHeaderField:@"VERSION"];
    manager.requestSerializer = serializer;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __weak typeof (self) weakSelf = self;
    [manager GET:@"http://www.u22t.com/home/index/adcon" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *di = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        [weakSelf todayHandle:di];
        if (weakSelf.dataSource.count == 0) {
            handler(NCUpdateResultNoData);
        }else  {
            handler(NCUpdateResultNewData);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [weakSelf todayHandle:@{@"code": [NSString stringWithFormat:@"%ld", error.code]}];
        handler(NCUpdateResultFailed);

    }];
    
}

- (void)todayHandle:(NSDictionary *)dict {
    if (![dict.allKeys containsObject:@"code"]) {
        return;
    }
    if (![dict[@"code"] isEqualToString:@"200"]) {
        return;
    }
    [_dataSource removeAllObjects];
    NSArray *arr = (NSArray *)dict[@"data"];
    for (NSDictionary *di in arr) {
        TodayModel *m = [[TodayModel alloc] init];
        [m setValuesForKeysWithDictionary:di];
        [_dataSource addObject:m];
    }
    //[self resetTableView];
}

- (void)resetTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.todayTV reloadData];
        CGFloat height = [self.todayTV.dataSource tableView:self.todayTV numberOfRowsInSection:0] * 70 + 50;
        [self setPreferredContentSize:CGSizeMake(self.todayTV.contentSize.width, height)];
    });
}



- (void)userDefaultChaneg:(id)sener
{
    NSUserDefaults * defaultes = [[NSUserDefaults alloc] initWithSuiteName:@"group.MyCircleContainer"];
    NSString * string = [defaultes valueForKey:@"xia"];
    NSLog(@"string = %@",string);
    
    //self.myLable.text = string;
    //打开应用按钮
    NSURL * url = [NSURL URLWithString:@"Today://a=1"];
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        
    }];
}

- (UIView *)returnFooterView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
//    label.text = @"查看更多";
//    label.textColor = [UIColor whiteColor];
//    [view addSubview:label];
    _moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width, 50)];
    _moreLabel.text = @"查看更多";
    _moreLabel.numberOfLines = 2;
    _moreLabel.textColor = [UIColor whiteColor];
    [view addSubview:_moreLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMoreAction:)];
    _moreLabel.userInteractionEnabled = YES;
    [_moreLabel addGestureRecognizer:tap];
    return view;
}

- (void)tapMoreAction:(UIGestureRecognizer *)sender {
    NSURL * url = [NSURL URLWithString:@"Today://a=more"];
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
    TodayModel *model = _dataSource[indexPath.row];
//    cell.textLabel.text = @"岁月友情";
//    cell.detailTextLabel.text = @"来忘掉错队，来怀念过去1232r2341222222222222222222222222222";
//
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://tse1-mm.cn.bing.net/th?id=OIP.Md3ff70fda1a6fd27d07bae462e7f8a81o0&w=146&h=105&c=7&rs=1&qlt=90&pid=3.1&rm=2"] placeholderImage:[UIImage imageNamed:@"Action_Moments@3x"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.cdate;
    
//    if (indexPath.row == 1) {
//        NSUserDefaults *userDefault=[[NSUserDefaults alloc] initWithSuiteName:@"group.MyCircleContainer"];
//        cell.textLabel.text = [userDefault valueForKey:@"xia"];
//        NSLog(@"xx %@",[userDefault valueForKey:@"xia"]);
//        //cell.detailTextLabel.text = [XFAPI baseImageUrl];
//    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSURL * url = [NSURL URLWithString:@"Today://a=1"];
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 当通知中心中extension展示的时候会先回调这一个函数进行数据更新，数据更新完我们需要调用completionHandler通知界面更新。
 
 每次更新完界面，通知中心都会截图一张图保存，目的是为了下次能够更快的展示数据
 */
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    [self getData:^(NCUpdateResult result) {
        
        if (result == NCUpdateResultNewData) {
            [self resetTableView];
        }
        completionHandler(result);
    }];
    //completionHandler(NCUpdateResultNewData);
}

@end
