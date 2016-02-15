//
//  HoView.h
//  MyCircle
//
//  Created by and on 15/12/17.
//  Copyright © 2015年 and. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XFHomeView : NSObject
/*
 *将boardWindow放在keyWindow上，添加拖拽移动，惦记显示中部view事件
 *
 *将boardView放在boardWindow上，放大时，放大此view
 *
 *homeImageView放在boardWindow上，放大时，隐藏此view，
 *
 *其他小块，放大时按照圆的摆放在boardView上，动画变大，
 *
 *      缩小后，移除所有小块，将homeImageView显示
 *
 * 放大：
 *      改变boardWindow为整个屏幕，添加点击移除事件
 *      改变boardView为boardWindow改变之前的frame
 *      隐藏homeImageView,添加小块
 * 缩小：
 *      与上相反
 *
 * 动画比较水，重写即可
 *
 */
+ (XFHomeView *)defaultSetHomeTouchViewWithTitleArray:(NSArray *)titleArray iconArray:(NSArray *)iconArray;

@end
