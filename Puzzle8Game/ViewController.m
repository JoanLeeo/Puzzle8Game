//
//  ViewController.m
//  Puzzle8Game
//
//  Created by AHUI_MAC on 2017/8/20.
//  Copyright © 2017年 AHUI_MAC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *randomNums;//存储初始化nums


@end



@implementation ViewController

- (NSMutableArray *)randomNums {
    if (!_randomNums) {
        _randomNums = [NSMutableArray array];
    }
    return _randomNums;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    

    self.randomNums = nil;
    [self.randomNums addObjectsFromArray:[self getNewAvailableRandomNums]];
    [self customUI];
    //随机数字
    
    
    
    
    
    
    
    
}

- (void)customUI {
    
    CGFloat puzzleBtnX = 0;
    CGFloat puzzleBtnY = 0;
    CGFloat puzzleBtnW = [UIScreen mainScreen].bounds.size.width / 3;
    CGFloat puzzleBtnH = puzzleBtnW;
    
    for (int i = 0; i < 9; i++) {
        puzzleBtnX = i % 3 * puzzleBtnW;
        puzzleBtnY = i / 3 * puzzleBtnH;
        UIButton *puzzleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        puzzleBtn.frame = CGRectMake(puzzleBtnX, puzzleBtnY, puzzleBtnW, puzzleBtnH);
        [puzzleBtn setTitle:[NSString stringWithFormat:@"%d", [self.randomNums[i] intValue]] forState:UIControlStateNormal];
        puzzleBtn.backgroundColor = [UIColor greenColor];
        [self.view addSubview:puzzleBtn];
        
    }
}

- (NSMutableArray *)getNewAvailableRandomNums {
    
    //随机数字
    int inverCount = 0;
    while (1) {
        inverCount = 0;
        NSMutableArray *initializeNums = [NSMutableArray array];//初始化0-n数字
        for (int i = 0; i < 9; i++) {
            [initializeNums addObject:@(i)];
        }
        
        NSMutableArray *randomNums = [NSMutableArray array];//随机数组
        for (int i = 0; i < 9; i++) {
            
            int randomNum = arc4random() % initializeNums.count;
            
            [randomNums addObject:initializeNums[randomNum]];
            
            [initializeNums removeObjectAtIndex:randomNum];
            
        }
        //判断是否可还原拼图
        int curNum = 0;
        int nextNum = 0;
        for (int i = 0; i < 9; i++) {
            curNum = [randomNums[i] intValue];
            for (int j = i + 1; j < 9; j++) {
                nextNum = [randomNums[j] intValue];
                if (curNum > nextNum) {
                    inverCount++;
                }
            }
            
        }
        
        if (!(inverCount % 2)) {
            return randomNums;
        }
        
    }
}


@end
