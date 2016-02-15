//
//  FriendVC.m
//  MyCircle
//
//  Created by and on 15/12/31.
//  Copyright © 2015年 and. All rights reserved.
//

#import "FriendVC.h"
#import "AppMacro.h"

#import "AFHTTPRequestOperationManager+URLData.h"
#import "BaseModel.h"
#import "XFAPI.h"
#import "XFAppContext.h"

#import "FriendModel.h"
#import <UIImageView+WebCache.h>
#import "UtilsMacro.h"

#import "FriendCell.h"
#import <SWTableViewCell/SWTableViewCell.h>

#import "ChatVC.h"
#import "EditContentVC.h"
@interface FriendVC () <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>

@property (strong, nonatomic) UITableView *friendTV;
@property (strong, nonatomic) NSMutableArray *fDataArray;

@end

@implementation FriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"mes_friends", @"mes_");
    _fDataArray = [NSMutableArray array];
    [self initView];
    [self initData];
}

- (void)leftBarButtonAction:(id )sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction:)];
    
    _friendTV = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    _friendTV.delegate = self;
    _friendTV.dataSource = self;
    [self.view addSubview:_friendTV];
    
    //右侧索引
    //索引字体颜色
    _friendTV.sectionIndexColor = UIColorFromRGB(51, 51, 51);
    //未选中时背景色
    _friendTV.sectionIndexBackgroundColor = [UIColor clearColor];
    //选中时背景色
    _friendTV.sectionIndexTrackingBackgroundColor = HexColor(0xFBF7ED);
    
    [_friendTV registerClass:[FriendCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)initData {
    __weak typeof (self) weakSelf = self;
    [AFHTTPRequestOperationManager postWithURLString:[XFAPI getFrinds] parameters:@{@"uid":[XFAppContext sharedContext].uid} success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel) {
        if (![baseModel.code isEqual:@"200"]) {
            [weakSelf showToast:baseModel.s_description];
            return ;
        }
        
        [weakSelf getFriendsHandle:responseDict];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel) {
        [weakSelf showToast:@"网络错误"];
    }];
}

- (void)getFriendsHandle:(NSDictionary *)response {
    for (NSDictionary *dict in (NSArray *)response) {
        FriendModel *model = [[FriendModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [_fDataArray addObject:model];
    }
    //获取朋友数据后，根据首字母排序
    
    if (_fDataArray.count == 0) {
        [self showXFToastWithText:@"当前无好友" image:[UIImage imageNamed:@"operationbox"]];
    }else {
        [self.friendTV reloadData];
    }
}




#pragma mark -- tableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREEN_CURRETWIDTH(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SCREEN_CURRETWIDTH(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_CURRETWIDTH(110);
}

//右边索引 字节数(如果不实现 就不显示右侧索引)
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return @[@"A",@"B"];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"A";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    FriendModel *model = _fDataArray[indexPath.row];
    [cell setFriendModel:model];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideRightButtons];
    FriendModel *model = _fDataArray[indexPath.row];
    NSLog(@"nick = %@",model.nickname);
    
    ChatVC *chat = [[ChatVC alloc] initWithConversationType:(ConversationType_PRIVATE) targetId:model.friendid];
    //[self.navigationController popViewControllerAnimated:NO];
    [self.navigationController pushViewController:chat animated:YES];
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    
    NSLog(@"%@-%ld",title,index);
    
//    __weak typeof (self) weakSelf = self;
//    if ([self.view viewWithTag:1222]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            ((UILabel *)[weakSelf.view viewWithTag:1222]).text = title;
//        });
//    }else {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_CURRETWIDTH(90), SCREEN_CURRETWIDTH(90))];
//            label.layer.masksToBounds = YES;
//            label.layer.cornerRadius = SCREEN_CURRETWIDTH(45);
//            label.tag = 1222;
//            label.text = title;
//            label.backgroundColor = [UIColor lightGrayColor];
//            label.textColor = [UIColor whiteColor];
//            label.font = [UIFont systemFontOfSize:24.0f];
//            label.textAlignment = NSTextAlignmentCenter;
//            [weakSelf.view insertSubview:label aboveSubview:weakSelf.friendTV];
//            label.center = weakSelf.view.center;
//        });
//
//    }
//    for(NSString *character in _dataSource)
//    {
//        if([character isEqualToString:title])
//        {
//            return count;
//        }
//        count ++;
//    }
    return 0;
}

#pragma mark -- SWTableViewCell
//点击选项按钮事件
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    [self hideRightButtons];
    switch (index) {//左边第几个
        case 0:
        {
//            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"修改备注" message:nil delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
//            [alertTest show];
            
            [cell hideUtilityButtonsAnimated:YES];
            NSIndexPath *cellIndexPath = [self.friendTV indexPathForCell:cell];
            FriendModel *model = _fDataArray[cellIndexPath.row];
            EditContentVC *edit = [[EditContentVC alloc] init];
            edit.conTitle = @"修改昵称";
            edit.content = model.markname;
            __weak typeof (self) weakSelf = self;
            edit.contentBlock = ^(NSString *name) {
                if ([name isEqualToString:model.markname]) {
                    NSLog(@"未修改");
                }else {
                    [weakSelf editContent:name indexPath:cellIndexPath fid:model.fid];
                }
            };
            [self.navigationController pushViewController:edit animated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.friendTV indexPathForCell:cell];
            FriendModel *model = _fDataArray[cellIndexPath.row];
            [self deleteFriend:model.fid indexPath:cellIndexPath];
            break;
        }
        default:
            break;
    }
}

//遍历所有cell,隐藏所有右滑按钮
- (void)hideRightButtons {
    for (int i = 0; i < self.friendTV.numberOfSections; i ++) {
        for (int j = 0; j < [self.friendTV numberOfRowsInSection:i]; j ++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:j inSection:i];
            SWTableViewCell *cell = [self.friendTV cellForRowAtIndexPath:index];
            if (!cell.isUtilityButtonsHidden) {
                [cell hideUtilityButtonsAnimated:YES];
            }
        }
    }
}

- (void)editContent:(NSString *)content indexPath:(NSIndexPath *)indexPath fid:(NSString *)fid{
    __weak typeof (self) weakSelf = self;
    [AFHTTPRequestOperationManager postWithURLString:[XFAPI upmarkname] parameters:@{@"markname":content,@"fid":fid} success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel) {
        if (![baseModel.code isEqual:@"200"]) {
            [weakSelf showToast:baseModel.s_description];
            return ;
        }
        FriendModel *model = weakSelf.fDataArray[indexPath.row];
        model.markname = content;
        //刷新点击的单元格
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.friendTV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel) {
        [weakSelf showToast:@"网络错误"];
    }];
}

- (void)deleteFriend:(NSString *)fid indexPath:(NSIndexPath *)indexPath {
    __weak typeof (self) weakSelf = self;
    [AFHTTPRequestOperationManager postWithURLString:[XFAPI deleteFriend] parameters:@{@"fid":fid} success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel) {
        if (![baseModel.code isEqual:@"200"]) {
            [weakSelf showToast:baseModel.s_description];
            return ;
        }
        //移除列表中对应
        [weakSelf.fDataArray removeObjectAtIndex:indexPath.row];
        [weakSelf.friendTV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [weakSelf showToast:@"删除成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel) {
        [weakSelf showToast:@"网络错误"];
    }];
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
