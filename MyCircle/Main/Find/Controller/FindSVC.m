//
//  FindSVC.m
//  MyCircle
//
//  Created by and on 16/1/27.
//  Copyright © 2016年 and. All rights reserved.
//

#import "FindSVC.h"
#import "XFPageView.h"

@interface FindSVC () <UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tv;
@property (nonatomic, strong) XFPageView *pageView;
@end

@implementation FindSVC

//http://7xo6u7.com1.z0.glb.clouddn.com/1234.jpg
//http://7xo6u7.com1.z0.glb.clouddn.com/1235.jpg

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat height = 200;
    //_pageView = [[LKPageView alloc] initWithURLStringArray:@[@"http://7xo6u7.com1.z0.glb.clouddn.com/1234.jpg",@"http://7xo6u7.com1.z0.glb.clouddn.com/1235.jpg"] andFrame:CGRectMake(0, 64, self.view.frame.size.width, height)];
    _pageView = [[XFPageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, height)];
    //_pageView.frame = CGRectMake(0, 64, self.view.frame.size.width, height);
    [_pageView setImagesArr:@[@"Action_Moments",@"Action_Moments",@"Action_Moments"]];
    
    _tv = [[UITableView alloc] initWithFrame:CGRectMake(0, height + 64, self.view.frame.size.width, self.view.frame.size.height - height) style:(UITableViewStyleGrouped)];
    _tv.delegate = self;
    _tv.dataSource = self;
    [self.view addSubview:_tv];
    //_tv.tableHeaderView = _pageView;
    [self.view addSubview:_pageView];
    //[_pageView startPlay];

    [_tv registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}


#pragma mark -- tableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = @"测试";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height= 200;
    CGFloat y = scrollView.contentOffset.y;
    NSLog(@"--y = %f",y);
    if (y < -64) {
        [_pageView setFrame: CGRectMake(-50, 64, self.view.frame.size.width + (-y-64), 300)];
        
    }else {
        _pageView.frame = CGRectMake(0, 64, self.view.frame.size.width + 0, 200);

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
