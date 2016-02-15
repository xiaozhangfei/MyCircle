//
//  EditPersonViewController.m
//  MyCircle
//
//  Created by and on 15/12/12.
//  Copyright © 2015年 and. All rights reserved.
//

#import "EditPersonViewController.h"
#import "AppMacro.h"
#import <UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

#import "XFAPI.h"
#import "XFAppContext.h"
#import "UtilsMacro.h"
#import "UIView+Ext.h"
#import "XFPicVideoPicker.h"

//上传图片需要的类
#import "AFManagerHandle.h"
#import "XFAPI.h"
#import "BaseModel.h"
#import "AFHTTPRequestOperationManager+URLData.h"

#import "MiscTool.h"
#import "PersonModel.h"
#import "UpFileManager.h"

@interface EditPersonViewController () <UITableViewDataSource, UITableViewDelegate, XFPicVideoPickerProtocol>
{
    UIImageView *_photoImv;
    
    PersonModel *_personModel;
    
    
    NSString *_key;
    NSString *_token;
    
}
@property (strong, nonatomic) UITableView *personTV;//
//用此picker时，需声明为strong
@property (strong, nonatomic) XFPicVideoPicker *picViewPicker;

@end

@implementation EditPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _personModel = [[PersonModel alloc] init];
    [self initView];
    [self initData];
}

- (void)initView {
    
    self.title = @"个人信息";
    //设置对应的导航条的返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction:)];

    _personTV = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    [self.view addSubview:_personTV];
    _personTV.delegate = self;
    _personTV.dataSource = self;
}

- (void)initData {
    __weak typeof (self) weakSelf = self;
    [AFHTTPRequestOperationManager getWithURLString:[XFAPI getPersonInfo:@"1"] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel){
        if (![baseModel.code isEqual:@"200"]) {
            [weakSelf showToast:baseModel.s_description];
            return ;
        }
        [weakSelf personInfoHandle:responseDict baseModel:baseModel];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel) {
        [weakSelf showToast:@"网络错误"];
        NSLog(@"error = %@",error);
    } dataRequestProgress:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
    
    [self getUpKey];
}

- (void)personInfoHandle:(NSDictionary *)response baseModel:(BaseModel *)baseModel {
    [_personModel setValuesForKeysWithDictionary:response];
    [self.personTV reloadData];
}

#pragma mark -- 获取上传头像的key
- (void)getUpKey {
    __weak typeof (self) weakSelf = self;
    [AFHTTPRequestOperationManager getWithURLString:[XFAPI getUpTokenForPhotoWithType:@"portrait"] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel) {
        if (![baseModel.code isEqual:@"200"]) {
            [weakSelf showToast:@"请求token失败"];
            return ;
        }
        _key = responseDict[@"key"];
        _token = responseDict[@"token"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel) {
        [weakSelf showToast:@"网络错误"];
    }];
}

- (void)leftBarButtonAction:(id )sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- tableView delegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0://头像，昵称
            return 2;
            break;
        case 1://性别，地区，生日
            return 3;
            break;
        case 2://兴趣
            return 1;
            break;
        case 3://简介
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //去重用池取cell
    UITableViewCell *cell;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"pCell"];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cCell"];
    }
    if (cell == nil) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"pCell"];
        }else {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cCell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        CGRect rect = cell.contentView.frame;
        rect.size.width = self.view.frame.size.width;
        cell.contentView.frame = rect;
        if (indexPath.section == 0 && indexPath.row == 0) {
            _photoImv = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - SCREEN_CURRETWIDTH(150), SCREEN_CURRETWIDTH(20), SCREEN_CURRETWIDTH(90), SCREEN_CURRETWIDTH(90))];
            _photoImv.layer.masksToBounds = YES;
            _photoImv.layer.cornerRadius = SCREEN_CURRETWIDTH(10);
            [_photoImv addTapCallBack:self sel:@selector(photoZoneAction:)];
            [cell.contentView addSubview:_photoImv];
        }else {
            UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - SCREEN_CURRETWIDTH(400), 0, SCREEN_CURRETWIDTH(340), SCREEN_CURRETWIDTH(70))];
            descLabel.textAlignment = NSTextAlignmentRight;
            descLabel.tag = 1200 + indexPath.section * 10 + indexPath.row;
            descLabel.text = @"aaaaaa";
            descLabel.textColor = HexColor(0x7E7E7E);
            [cell.contentView addSubview:descLabel];
        }
    }
    UILabel *descLabel = (UILabel *)[cell.contentView viewWithTag:1200 + indexPath.section * 10 + indexPath.row];
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {//头像
                cell.textLabel.text = @"头像";
                __weak typeof (self) weakSelf = self;
                [_photoImv sd_setImageWithURL:[NSURL URLWithString:[XFAPI image_url:[XFAppContext sharedContext].portrait]] placeholderImage:[UIImage imageNamed:@"women"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                }];
                return cell;
            }else {//昵称
                cell.textLabel.text = @"昵称";
                descLabel.text = _personModel.nickname;
                [cell.contentView addSubview:descLabel];
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {//性别
                cell.textLabel.text = @"性别";
                NSString *sex;
                if ([_personModel.sex isEqualToString:@"0"]) {
                    sex = @"女";
                }else {
                    sex = @"男";
                }
                descLabel.text = sex;
            }else if (indexPath.row == 1) {//地区
                cell.textLabel.text = @"地区";
                descLabel.text = _personModel.location;
            }else {//生日
                cell.textLabel.text = @"生日";
                descLabel.text = _personModel.birth;
            }
        }
            break;
        case 2://兴趣
        {
            cell.textLabel.text = @"兴趣";
            descLabel.text = _personModel.intrests;
        }
            break;
        case 3://简介
        {
            cell.textLabel.text = @"个性签名";
            descLabel.text = _personModel.intro;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREEN_CURRETWIDTH(20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SCREEN_CURRETWIDTH(20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return SCREEN_CURRETWIDTH(130);
    }else {
        return SCREEN_CURRETWIDTH(70);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {//头像
                _picViewPicker = [[XFPicVideoPicker alloc] initWithController:self];
                _picViewPicker.type = XFPicVideoPickerTypePic;
                _picViewPicker.isAllowsEditing = YES;
                [_picViewPicker showPicActionSheet:nil descMsg:@"作为头像"];
            }else {//昵称
              
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {//性别
                
            }else if (indexPath.row == 1) {//地区
                
            }else {//生日
                
            }
        }
            break;
        case 2://兴趣
        {
            
        }
            break;
        case 3://简介
        {
            
        }
            break;
        default:
            break;
    }
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //((UILabel *)[cell.contentView viewWithTag:1200 + indexPath.section * 10 + indexPath.row]).text = @"该改变了";
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark -- all action
- (void)photoZoneAction:(UIGestureRecognizer *)sender {
    //放大图片

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor blackColor];
    [window addSubview:view];
    
    UIImage *image = _photoImv.image;
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(view.width / 2, view.height / 2, 0, 0)];
    img.tag = 1999;
    img.image = image;
    [view addSubview:img];
    
    [view addTapCallBack:self sel:@selector(noZoneAction:)];
    //动画显示
    CGFloat height = image.size.height * view.frame.size.width / image.size.width;
    CGRect rect = CGRectMake(0, (view.height - height) / 2, view.width, height);
    [UIView animateWithDuration:0.5f animations:^{
        img.frame = rect;
    }];
}

- (void)noZoneAction:(UIGestureRecognizer *)sender {
    [UIView animateWithDuration:0.5f animations:^{
        CGRect rect = CGRectZero;
        rect.origin.x = sender.view.width / 2;
        rect.origin.y = sender.view.height / 2;
        [sender.view viewWithTag:1999].frame = rect;
    } completion:^(BOOL finished) {
        [sender.view removeFromSuperview];
    }];
}



#pragma mark -- XFPicVideoPicker delegate
- (void)selectImage:(NSArray *)images {
    NSLog(@"选择了新图片");
    if (images.count == 0) {
        return;
    }
    _photoImv.image = images[0];
    
    [[UpFileManager shareHandle] sendSingleImageWithImage:images[0] type:(UpFileManagerTypePortrait) key:_key token:_token];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
