//
//  ChatVC.m
//  MyCircle
//
//  Created by and on 15/12/31.
//  Copyright © 2015年 and. All rights reserved.
//

#import "ChatVC.h"
#import "XFAppContext.h"
#import "XFAPI.h"
#import "UtilsMacro.h"
#import "AppDelegate.h"
#import "AppMacro.h"
#import "UIView+Ext.h"

#import "WebVC.h"
@interface ChatVC ()

@end

@implementation ChatVC

- (void)leftBarButtonAction:(id )sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置对应的导航条的返回
    
//    self.enableUnreadMessageIcon = YES;
    self.enableNewComingMessageIcon = YES;
//    self.displayConversationTypeArray = @[@(ConversationType_PRIVATE)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction:)];
    
    [self setMessageAvatarStyle:RC_USER_AVATAR_RECTANGLE];
    //.enableMessageAttachUserInfo = YES;
    self.title = self.cTitle;
    if (ISEMPTY(self.cTitle)) {
        RCUserInfo *user = [((AppDelegate *)[UIApplication sharedApplication].delegate) getUserInfoWithUid:self.targetId];
        self.title = user.name;
    }
}

//- (void)leftBarButtonItemPressed:(id)sender {
//    [super leftBarButtonItemPressed:sender];
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent {
    
    
    //[super willSendMessage:messageCotent];
    messageCotent.senderUserInfo.name = [XFAppContext sharedContext].nickname;
    messageCotent.senderUserInfo.portraitUri = [XFAPI image_url:[XFAppContext sharedContext].portrait];
    
    return messageCotent;
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.messageTimeLabel.backgroundColor = UIColorFromRGB(215, 215, 215);
    if (cell.messageDirection == MessageDirection_SEND) {
        if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
            RCTextMessageCell *textCell = (RCTextMessageCell *)cell;
            //      自定义气泡图片的适配
            UIImage *image = textCell.bubbleBackgroundView.image;
            //textCell.bubbleBackgroundView.image = [UIImage imageNamed:@"chat_to_bg_1"];
            textCell.bubbleBackgroundView.image=[[UIImage imageNamed:@"chat_to_bg_1"] resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8,image.size.height * 0.2, image.size.width * 0.2)];
            //      更改字体的颜色
            //textCell.textLabel.textColor=[UIColor redColor];
            //textCell.textLabel.backgroundColor = HexColor(0xA8EC68);
            
            [[textCell viewWithTag:1400] removeFromSuperview];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(textCell.bubbleBackgroundView.frame) - SCREEN_CURRETWIDTH(20), CGRectGetMaxY(textCell.bubbleBackgroundView.frame) - SCREEN_CURRETWIDTH(30), SCREEN_CURRETWIDTH(50), SCREEN_CURRETWIDTH(40))];
            img.image = [UIImage imageNamed:@"chat_pendant"];
            img.tag = 1400;
            [[textCell.bubbleBackgroundView superview] addSubview:img];
        }
    }else {
        if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
            RCTextMessageCell *textCell=(RCTextMessageCell *)cell;
            [[textCell viewWithTag:1400] removeFromSuperview];
        }
    }
   
    
}
//点击网址
- (void)didTapUrlInMessageCell:(NSString *)url model:(RCMessageModel *)model {
    WebVC *web = [[WebVC alloc] init];
    web.url = url;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}
//点击电话号码
- (void)didTapPhoneNumberInMessageCell:(NSString *)phoneNumber model:(RCMessageModel *)model {
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNumber]]];
    [self.view addSubview:callWebview];
    
}

- (void)didTapCellPortrait:(NSString *)userId {
    NSLog(@"点击头像--");
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
