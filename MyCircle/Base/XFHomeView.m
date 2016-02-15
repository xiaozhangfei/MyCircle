//
//  HoView.m
//  MyCircle
//
//  Created by and on 15/12/17.
//  Copyright © 2015年 and. All rights reserved.
//

#import "XFHomeView.h"
#import "HomeIconTitleView.h"
#import "AppDelegate.h"
#define  windowWidth ([UIScreen mainScreen].bounds.size.width)
#define  windowHight ([UIScreen mainScreen].bounds.size.height)

static const NSTimeInterval kAnimationDuration = 0.25f;
static XFHomeView *__homeView = nil;

@interface XFHomeView ()
{
    UIView          *_boardWindow;               //底部window
    UIView          *_boardView;                 //底部view
    UIImageView     *_homeImageView;            //漂浮的menu按钮
    
    NSArray         *_titleArray;               //展开的标题数组
    NSArray         *_iconArray;                //图片背景
    
    BOOL            _showMenu;                   //menu是否展开
    BOOL            _showAnimation;              //animation动画展示
    
    CGRect          _moveWindowRect;             //移动后window.frame

}

@end

@implementation XFHomeView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _iconArray = nil;
    _titleArray = nil;
    _boardWindow = nil;
    _boardView = nil;
    _homeImageView = nil;
}

- (id)initWithHomeViewWithTitleArray:(NSArray *)titleArray iconArray:(NSArray *)iconArray {
    if (self = [super init]) {
        if (iconArray) {
            _iconArray = iconArray;
            _titleArray = titleArray;
        }
        _showMenu = NO;
        _showAnimation = NO;
        
        CGFloat homeWidth = 60;
        //初始化背景window
        _boardWindow = [[UIView alloc] initWithFrame:CGRectMake(0, 200, homeWidth, homeWidth)];
        _boardWindow.backgroundColor = [UIColor clearColor];
        //_boardWindow.windowLevel = 3000;
        _boardWindow.clipsToBounds = YES;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_boardWindow];
        
        //初始化背景view
        _boardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, homeWidth, homeWidth)];
        _boardView.backgroundColor = [UIColor lightGrayColor];
        [_boardWindow addSubview:_boardView];
        
        //初始化漂浮menu
        _homeImageView = [[UIImageView alloc]init];
        [self setImageNameWithMove:NO];
        [_homeImageView setUserInteractionEnabled:YES];
        [_homeImageView setFrame:CGRectMake(0, 0, homeWidth, homeWidth)];
        [_boardView addSubview:_homeImageView];
        
        //手势
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImgV:)];
        [_homeImageView addGestureRecognizer:panGestureRecognizer];
        
        UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImgV:)];
        [_homeImageView addGestureRecognizer:tapGestureRecognizer];
        
    }
    return self;
}

#pragma mark -

+ (XFHomeView *)defaultSetHomeTouchViewWithTitleArray:(NSArray *)titleArray iconArray:(NSArray *)iconArray {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        __homeView = [[XFHomeView alloc] initWithHomeViewWithTitleArray:titleArray iconArray:iconArray ];
    });
    return __homeView;
}

#pragma mark - GestureRecognizer
#pragma mark UIPanGestureRecognizer
- (void)panImgV:(UIPanGestureRecognizer*)panGestureRecognizer
{
    //判断是否展开
    if (_showMenu) {
        return;
    }
    UIView *moveView = panGestureRecognizer.view.superview.superview;//homeImageView->boardView->boardWindow
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:moveView.superview];
        //控制上下边界
        if (moveView.center.y + translation.y <= moveView.frame.size.height / 2) {
            [moveView setCenter:(CGPoint){moveView.center.x + translation.x, moveView.frame.size.height / 2}];
        }else if (moveView.center.y + translation.y >= windowHight - moveView.frame.size.height / 2){
            [moveView setCenter:(CGPoint){moveView.center.x + translation.x, windowHight - moveView.frame.size.height / 2}];

        }else {
            [moveView setCenter:(CGPoint){moveView.center.x + translation.x, moveView.center.y + translation.y}];
        }
        [panGestureRecognizer setTranslation:CGPointZero inView:moveView.superview];
        [self setImageNameWithMove:YES];
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //将window靠边
        CGRect newRect = moveView.frame;
        CGPoint newCenter = moveView.center;
        if (newCenter.x <= windowWidth / 2) {
            newRect.origin.x = 0;
        }else {
            newRect.origin.x = windowWidth - newRect.size.width;
        }
        [moveView setFrame:newRect];//设置新的frame
        _moveWindowRect = newRect;

        [self setImageNameWithMove:NO];
    }
}

#pragma mark - 移动和停止menu图片
- (void)setImageNameWithMove:(BOOL)isMove
{
    if (isMove) {
        [_homeImageView setImage:[UIImage imageNamed:@"message_no"]];
    }else
    {
        [_homeImageView setImage:[UIImage imageNamed:@"message"]];
    }
}

#pragma mark UITapGestureRecognizer
- (void)tapImgV:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if (!_showAnimation) {
        if (_showMenu) {
            [self hideMenuWithIsTapAction:NO view:nil];
        }else
        {
            [self showMenu];
        }
    }
    _showMenu = !_showMenu;
}

- (void)windowTaped:(UITapGestureRecognizer *)gesture{
    [self hideMenuWithIsTapAction:NO view:nil];
    _showMenu = !_showMenu;
}

#pragma mark - ShowMenu
- (void)showMenu
{
    _moveWindowRect = _boardWindow.frame;
    //将boardWindow frame改为全屏，以接收点击其他空白，收回
    _boardWindow.frame = [[UIScreen mainScreen] bounds];
    //修改boardView frame，使其保持在屏幕原位
    _boardView.frame = _moveWindowRect;
    
    _homeImageView.hidden = YES;//隐藏homeImageView
    
    //改变_moveWindowRect，弹出按钮
    //弹出后的_moveWindowRect
    CGRect nowFrame = _boardView.frame;
    CGRect newFrame = CGRectMake(50, 200, 300, 300);
    
    CGFloat ff = 0.15;
    CGRect rect = CGRectMake(nowFrame.origin.x + (newFrame.origin.x - nowFrame.origin.x) * ff,
                             nowFrame.origin.y + (newFrame.origin.y - nowFrame.origin.y) * ff,
                             newFrame.size.width * ff,
                             newFrame.size.height * ff);
    //_homeView.frame = rect;
    CGRect blockRect = CGRectMake(0, 0, 60 * ff, 90 * ff);//每个小块的frame
    //设置新的frame
    _boardView.frame = rect;
    
    CGPoint centerPoint = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    CGFloat radius = (rect.size.height - blockRect.size.height) / 2;
    //各个iconTV均在以radius为半径的圆上
    CGFloat nAngle = 90.0;//当前角度，top点
    CGFloat interAngle = 360.0 / _iconArray.count;
    for (int i = 0; i < _iconArray.count; i ++) {
        CGFloat xOffset = radius * cosf(nAngle * M_PI / 180);
        CGFloat yOffset = - radius * sinf(nAngle * M_PI / 180);
        CGPoint p = CGPointMake(centerPoint.x + xOffset, centerPoint.y + yOffset);
        HomeIconTitleView *iconTV = [[HomeIconTitleView alloc] initWithFrame:blockRect];
        iconTV.imageView.image = [UIImage imageNamed:_iconArray[i]];
        iconTV.label.text = _titleArray[i];
        iconTV.tag = 1900 + i;
        [_boardView addSubview:iconTV];
        iconTV.center = p;
        UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconAction:)];
        [iconTV addGestureRecognizer:tapGestureRecognizer];
        nAngle -= interAngle;//调整角度
    }

    blockRect = CGRectMake(0, 0, 60, 90);
    
    
    [UIView animateWithDuration:2.0f delay:0 usingSpringWithDamping:0.6f initialSpringVelocity:2.0f options:(UIViewAnimationOptionTransitionNone) animations:^{
        _boardView.frame = newFrame;
        CGPoint centerPoint = CGPointMake(newFrame.size.width / 2, newFrame.size.height / 2);
        CGFloat radius = (newFrame.size.height - blockRect.size.height) / 2;
        //各个iconTV均在以radius为半径的圆上
        CGFloat nAngle = 90.0;//当前角度，top点
        CGFloat interAngle = 360.0 / _iconArray.count;
        for (int i = 0; i < _iconArray.count; i ++) {
            CGFloat xOffset = radius * cosf(nAngle * M_PI / 180);
            CGFloat yOffset = - radius * sinf(nAngle * M_PI / 180);
            [_boardView viewWithTag:1900 + i].frame = blockRect;
            CGPoint p = CGPointMake(centerPoint.x + xOffset, centerPoint.y + yOffset);
            [_boardView viewWithTag:1900 + i].center = p;
            nAngle -= interAngle;//调整角度
        }
        _showAnimation = YES;
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *windowTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowTaped:)];
        [_boardWindow addGestureRecognizer:windowTap];
        _showMenu = YES;
        _showAnimation = NO;
    }];
}


#pragma mark -- 视图动画，不太好，重写动画即可
#pragma mark - HideMenu
- (void)hideMenuWithIsTapAction:(BOOL )isTap view:(UIView *)sender
{
    CGRect nowFrame = _boardView.frame;
    CGRect newFrame = _moveWindowRect;

    CGFloat ff = 0.10;
    CGRect cutFrame = CGRectMake(newFrame.origin.x + (nowFrame.origin.x - newFrame.origin.x) * ff,
                                 newFrame.origin.y + (nowFrame.origin.y - newFrame.origin.y) * ff,
                                 nowFrame.size.width * ff,
                                 nowFrame.size.height * ff);
    
    [UIView animateWithDuration:2.0f animations:^{
        CGRect rect = [_boardView viewWithTag:1900].frame;
                    rect.origin.x *= ff;
                    rect.origin.y *= ff;
        rect.size.width *= ff;
        rect.size.height *= ff;
        for (UIView *view in _boardView.subviews) {
            if (view == _homeImageView) {
                continue;
            }

            view.frame = rect;
            //view.center = CGPointMake(rect.origin.x *ff + rect.size.width / 2, rect.origin.y * ff + rect.size.height * 2);
            view.alpha = 0;
        }
        _boardView.frame = cutFrame;

        _showAnimation = YES;
    } completion:^(BOOL finished) {
        //移除所有子view,homeImageView除外
        for (UIView *view in _boardView.subviews) {
            if (view == _homeImageView) {
                continue;
            }
            [view removeFromSuperview];
        }
        //改变boardWindow fram
        _boardWindow.frame = _moveWindowRect;
        //改变boardView fram
        _boardView.alpha = 0;
        _boardView.frame = CGRectMake(0, 0, _moveWindowRect.size.width, _moveWindowRect.size.height);
        //显示homeImageView
        _homeImageView.alpha = 0;
        _homeImageView.hidden = NO;
        [UIView animateWithDuration:0.5f animations:^{
            _homeImageView.alpha = 1;
            _boardView.alpha = 1;
        }];
        
        _showMenu = NO;
        _showAnimation = NO;
        if (isTap) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"xfHomeViewTapNoti" object:[NSNumber numberWithLong:sender.tag]]];
        }
    }];
    
}


#pragma mark -- 各个icon的Action
- (void)iconAction:(UIGestureRecognizer *)sender {
    //[self windowTaped:nil];
    NSLog(@"sender = %@", _titleArray[sender.view.tag - 1900]);
    //发送通知
    [self hideMenuWithIsTapAction:YES view:sender.view];

}
























@end
