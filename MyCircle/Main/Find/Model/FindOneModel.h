//
//  FindOneModel.h
//  MyCircle
//
//  Created by and on 16/3/3.
//  Copyright © 2016年 and. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (copy, nonatomic) NSString *l;
@property (copy, nonatomic) NSString *h;

@end

@interface FindOneModel : NSObject


@property (copy, nonatomic) NSString *f_id;
@property (copy, nonatomic) NSString *name;

@property (strong, nonatomic) Location *location;
@end
