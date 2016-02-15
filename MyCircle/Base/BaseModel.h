//
//  BaseModel.h
//  Chuangdou
//
//  Created by tech on 15/7/1.
//  Copyright (c) 2015年 and. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

//@property (nonatomic, copy) NSDictionary *data;
@property (nonatomic, assign) BOOL error;
@property (nonatomic, copy) NSString *s_description;
@property (nonatomic, copy) NSNumber *code;

@end
