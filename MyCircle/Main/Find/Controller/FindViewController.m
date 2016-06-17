//
//  FindViewController.m
//  MyCircle
//
//  Created by and on 15/11/1.
//  Copyright © 2015年 and. All rights reserved.
//

#import "FindViewController.h"
#import "FindOneViewController.h"
#import "FindTwoViewController.h"
#import "AppMacro.h"



@interface FindViewController ()
{
    FindOneViewController *oneVC;
    FindTwoViewController *twoVC;
    UIViewController *currentVC;
    UIView *_backView;
    UISegmentedControl *segment;
}

@property (assign, nonatomic) NSInteger index;

@property (strong, nonatomic) NSMutableArray *vcArray;


//左右滑手势
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;


@end

@implementation FindViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"tab_find", @"tab_");
    _selectedIndex = 0;
    [self initView];
}

- (void)initView {
    segment = [[UISegmentedControl alloc] initWithItems:@[@"left",@"right"]];
    segment.frame = CGRectMake(SCREEN_ORIGINWIDTH_5(20), 64 + SCREEN_ORIGINWIDTH_5(10), self.view.frame.size.width - SCREEN_ORIGINWIDTH_5(40), SCREEN_ORIGINWIDTH_5(60));
    segment.tintColor = [UIColor orangeColor];
    segment.backgroundColor = [UIColor whiteColor];
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:(UIControlEventValueChanged)];
    segment.selectedSegmentIndex = _selectedIndex;
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 113)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView];
    
    [self.view addSubview:segment];
    
    oneVC = [[FindOneViewController alloc] init];
    [self addChildViewController:oneVC];
    twoVC = [[FindTwoViewController alloc] init];
    [self addChildViewController:twoVC];
    
    _vcArray = [NSMutableArray array];
    [_vcArray addObject:oneVC];
    [_vcArray addObject:twoVC];
    //[_backView addSubview:oneVC.view];
    currentVC = oneVC;
    [_backView addSubview:currentVC.view];
    _index = 0;
    
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"willMove--");
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"didMove--");
}

- (void)segmentAction:(UISegmentedControl *)sender {
    NSLog(@"--selected = %ld",sender.selectedSegmentIndex);
    if (_index != sender.selectedSegmentIndex && sender.selectedSegmentIndex == 0) {//移除1，添加0
        [self transitionFromViewController:currentVC toViewController:_vcArray[_index] duration:4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
        }  completion:^(BOOL finished) {
            //......

        }];
        
        currentVC = _vcArray[sender.selectedSegmentIndex];
        [_backView addSubview:currentVC.view];
        _index = sender.selectedSegmentIndex;
        //[twoVC removeFromParentViewController];

    }else {
        [self transitionFromViewController:currentVC toViewController:twoVC duration:4 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            
        }  completion:^(BOOL finished) {
            //......

        }];
        
        currentVC = _vcArray[sender.selectedSegmentIndex];
        [_backView addSubview:currentVC.view];
        _index = sender.selectedSegmentIndex;
        //[oneVC removeFromParentViewController];
    }
    
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {

        if (_index == 0) {
            NSLog(@"右边没有了..");
            return;
        }
        [self transitionFromViewController:currentVC toViewController:_vcArray[_index - 1] duration:4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                
            }  completion:^(BOOL finished) {
                //......
                
            }];
            
            currentVC = _vcArray[_index - 1];
            [_backView addSubview:currentVC.view];
            _index --;
        segment.selectedSegmentIndex = _index;
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_index == _vcArray.count - 1) {
            NSLog(@"左边没有了..");
            return;
        }
        [self transitionFromViewController:currentVC toViewController:_vcArray[_index + 1] duration:4 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            
        }  completion:^(BOOL finished) {
            //......
        
        }];
        
        currentVC = _vcArray[_index + 1];
        [_backView addSubview:currentVC.view];
        _index ++;
        segment.selectedSegmentIndex = _index;

    }
}


@end
