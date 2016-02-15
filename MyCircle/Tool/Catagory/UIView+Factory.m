//
//  UIView+Factory.m
//  MyCircle
//
//  Created by and on 15/11/3.
//  Copyright © 2015年 and. All rights reserved.
//

#import "UIView+Factory.h"
#ifndef Demo_Macros_h
#define Demo_Macros_h
#ifdef __IPHONE_6_0
#define kTextAlignmentLeft NSTextAlignmentLeft
#define kTextAlignmentCenter NSTextAlignmentCenter
#define kTextAlignmentRight NSTextAlignmentRight
#define kLineBreakModeCharaterWrap NSLineBreakByCharWrapping
#define kLineBreakModeWordWrap NSLineBreakByWordWrapping
#define kLineBreakModeClip NSLineBreakByClipping
#define kLineBreakModeTruncatingHead NSLineBreakByTruncatingHead
#define kLineBreakModeTruncatingMiddle NSLineBreakByTruncatingMiddle
#define kLineBreakModeTruncatingTail NSLineBreakByTruncatingTail
#else
#define kTextAlignmentLeft UITextAlignmentLeft
#define kTextAlignmentCenter UITextAlignmentCenter
#define kTextAlignmentRight UITextAlignmentRight
#define kLineBreakModeCharaterWrap UILineBreakModeCharacterWrap
#define kLineBreakModeWordWrap UILineBreakModeWordWrap
#define kLineBreakModeClip UILineBreakModeClip
#define kLineBreakModeTruncatingHead UILineBreakModeHeadTruncation
#define kLineBreakModeTruncatingMiddle UILineBreakModeMiddleTruncation
#define kLineBreakModeTruncatingTail UILineBreakModeTailTruncation
#endif

#define kMainScreenFrame [[UIScreen mainScreen] bounds]
#define kMainScreenWidth kMainScreenFrame.size.width
#define kMainScreenHeight kMainScreenFrame.size.height-20
#define kApplicationFrame [[UIScreen mainScreen] applicationFrame]
#endif

@implementation UIView (Factory)

#pragma mark Label

+ (id)createLabel
{
    return [UIView createLabel:CGRectZero];
}

+ (id)createLabel:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = kTextAlignmentCenter;
    
#if __has_feature(objc_arc)
    return label;
#else
    return [label autorelease];
#endif
    
}

#pragma mark TextField

+ (id)createTextFiled
{
    return [UIView createTextFiled:UITextBorderStyleRoundedRect];
}

+ (id)createTextFiled:(UITextBorderStyle)style
{
    return [UIView createTextFiled:CGRectZero style:style];
}

+ (id)createTextFiled:(CGRect)frame style:(UITextBorderStyle)style
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.textAlignment = kTextAlignmentCenter;
    textField.textColor = [UIColor blackColor];
    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.borderStyle = style;
    
#if __has_feature(objc_arc)
    return textField;
#else
    return [textField autorelease];
#endif
    
}


#pragma mark Button

+ (id)createButton:(CGRect)frame
{
    return [UIView createButton:frame type:UIButtonTypeRoundedRect];
}

+ (id)createButton:(CGRect)frame
              type:(UIButtonType)type
{
    UIButton *btn = [UIButton buttonWithType:type];
    btn.frame = frame;
    return btn;
}

+ (id)createButton:(CGRect)frame
            target:(id)target
            action:(SEL)action
{
    return [UIView createButton:frame
                         target:target
                         action:action
                     buttonType:UIButtonTypeRoundedRect];
}


+ (id)createButton:(CGRect)frame
            target:(id)target
            action:(SEL)action
        buttonType:(UIButtonType)type
{
    UIButton *btn = [UIButton buttonWithType:type];
    btn.frame = frame;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

//
//#pragma mark TableView
//
//+ (id)createTableView:(id<uitableviewdatasource>)dataSource
//             delegete:(id<uitableviewdelegate>)delegate
//{
//    return [UIView createTableView:CGRectZero
//                        dataSource:dataSource
//                          delegete:delegate
//                             style:UITableViewStyleGrouped];
//}
//
//+ (id)createTableView:(id<uitableviewdatasource>)dataSource
//             delegete:(id<uitableviewdelegate>)delegate
//                style:(UITableViewStyle)style
//{
//    return [UIView createTableView:CGRectZero
//                        dataSource:dataSource
//                          delegete:delegate
//                             style:style];
//}
//
//+ (id)createTableView:(CGRect)frame
//           dataSource:(id<uitableviewdatasource>)dataSource
//             delegete:(id<uitableviewdelegate>)delegate
//{
//    return [UIView createTableView:frame
//                        dataSource:dataSource
//                          delegete:delegate
//                             style:UITableViewStyleGrouped];
//}
//
//
//+ (id)createTableView:(CGRect)frame
//           dataSource:(id<uitableviewdatasource>)dataSource
//             delegete:(id<uitableviewdelegate>)delegate
//                style:(UITableViewStyle)style
//{
//    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
//    tableView.delegate = delegate;
//    tableView.dataSource = dataSource;
//    
//    
//#if __has_feature(objc_arc)
//    return tableView;
//#else
//    return [tableView autorelease];
//#endif
//    
//}


#pragma mark TextView

+ (id)createTextView:(CGRect)frame
{
    UITextView *tv = [[UITextView alloc] initWithFrame:frame];
    
#if __has_feature(objc_arc)
    return tv;
#else
    return [tv autorelease];
#endif
    
}

@end
