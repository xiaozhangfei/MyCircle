//
//  HYPageControl.h
//  DaDiJinRong
//
//  Created by HY on 15/6/2.
//  Copyright (c) 2015年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYPageControl : UIPageControl

/**
 *  初始化
 *
 *  @param frame frame
 *
 *  @return HYPageControl
 */
-(id)initWithFrame:(CGRect)frame;
/**
 *  改变索引时调用
 *
 *  @param page 当前页面
 */
-(void)setCurrentPage:(NSInteger)page;
@end
