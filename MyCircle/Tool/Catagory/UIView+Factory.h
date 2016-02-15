//
//  UIView+Factory.h
//  MyCircle
//
//  Created by and on 15/11/3.
//  Copyright © 2015年 and. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Factory)

// Label
+ (id)createLabel;
+ (id)createLabel:(CGRect)frame;

// TextField
+ (id)createTextFiled;
+ (id)createTextFiled:(UITextBorderStyle)style;
+ (id)createTextFiled:(CGRect)frame style:(UITextBorderStyle)style;

// Button
+ (id)createButton:(CGRect)frame;

+ (id)createButton:(CGRect)frame
              type:(UIButtonType)type;

+ (id)createButton:(CGRect)frame
            target:(id)target
            action:(SEL)action;

+ (id)createButton:(CGRect)frame
            target:(id)target
            action:(SEL)action
        buttonType:(UIButtonType)type;


//// TableView
//+ (id)createTableView:(id<uitableviewdatasource>)dataSource
//             delegete:(id<uitableviewdelegate>)delegate;
//
//+ (id)createTableView:(id<uitableviewdatasource>)dataSource
//             delegete:(id<uitableviewdelegate>)delegate
//                style:(UITableViewStyle)style;
//
//+ (id)createTableView:(CGRect)frame
//           dataSource:(id<uitableviewdatasource>)dataSource
//             delegete:(id<uitableviewdelegate>)delegate;
//
//+ (id)createTableView:(CGRect)frame
//           dataSource:(id<uitableviewdatasource>)dataSource
//             delegete:(id<uitableviewdelegate>)delegate
//                style:(UITableViewStyle)style;
//
//
//// TextView
@end
