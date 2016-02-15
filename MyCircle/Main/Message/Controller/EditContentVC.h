//
//  EditContentVC.h
//  MyCircle
//
//  Created by and on 16/1/5.
//  Copyright © 2016年 and. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ContentBlock)(NSString *);


@interface EditContentVC : BaseViewController

@property (copy, nonatomic) ContentBlock contentBlock;
@property (copy, nonatomic) NSString *conTitle;
@property (copy, nonatomic) NSString *content;
@end
