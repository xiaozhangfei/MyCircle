//
//  ChatListVC.m
//  MyCircle
//
//  Created by and on 15/12/31.
//  Copyright © 2015年 and. All rights reserved.
//

#import "ChatListVC.h"
#import "UtilsMacro.h"

#import "ChatVC.h"

#import "FriendVC.h"
@interface ChatListVC ()

@end

@implementation ChatListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"tab_message", @"tab_");
    // Do any additional setup after loading the view.
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    //设置置顶颜色
    self.topCellBackgroundColor = HexColor(0x51B9C7);
    //设置头像圆形
    [self setConversationAvatarStyle:(RC_USER_AVATAR_RECTANGLE)];
    //去除空行的singleLine
    self.conversationListTableView.tableFooterView = [[UIView alloc]init];
    [self initView];
}

- (void)initView {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pc_friend"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonAction:)];

}

- (void)rightBarButtonAction:(UIBarButtonItem *)sender {
    NSLog(@"朋友列表");
    FriendVC *friend = [[FriendVC alloc] init];
    friend.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friend animated:YES];
    //重写navigationBar按钮方法时，开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    ChatVC *chat = [[ChatVC alloc] initWithConversationType:model.conversationType targetId:model.targetId];
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
    
    //重写navigationBar按钮方法时，开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
//    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
//    conversationVC.conversationType = model.conversationType;
//    conversationVC.targetId = model.targetId;
//    conversationVC.title = model.extend[@"nick"];
//    conversationVC.hidesBottomBarWhenPushed = YES;
//    [conversationVC setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
//    [self.navigationController pushViewController:conversationVC animated:YES];
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
