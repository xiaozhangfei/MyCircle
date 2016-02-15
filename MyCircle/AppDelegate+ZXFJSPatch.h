//
//  AppDelegate+ZXFJSPatch.h
//  MyCircle
//
//  Created by and on 16/2/15.
//  Copyright © 2016年 and. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (ZXFJSPatch)

- (void)hello;

#pragma mark -- js修改代码

/*
 *  第一次进入时，从网络获取js内容，验证，加密，存储
 */
- (void)getUpJS;

/*
 *  每次didBecomeActive时，解密，读取js内容，执行
 */
- (void)execJs;


@end
