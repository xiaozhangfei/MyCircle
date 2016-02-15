//
//  NSData+AES.h
//  MyCircle
//
//  Created by and on 16/1/29.
//  Copyright © 2016年 and. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)

- (NSData *)AES128EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES128DecryptWithKey:(NSString *)key;   //解密


@end
