//
//  ViewController.m
//  Puzzle8Game
//
//  Created by AHUI_MAC on 2017/8/20.
//  Copyright © 2017年 AHUI_MAC. All rights reserved.
//

#import "ViewController.h"

#define kPuzzleBtnGap 2

@interface ViewController (){

    UIButton *_maxPuzzleBtn;
    int _difficulty;//难度系数 3*3 4*4 5*5
    int _puzzleCount;
    

}

@property (nonatomic, strong) NSMutableArray *randomNums;//存储初始化nums
@property (nonatomic, strong) UIView *puzzleBgView;


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
    
    
    _difficulty = 4;
    _puzzleCount = _difficulty * _difficulty;
    
    
    self.randomNums = nil;
    [self.randomNums addObjectsFromArray:[self getNewAvailableRandomNums]];
    [self customUI];
    //随机数字
    
    
    
    
    
    
    
    
}

- (void)customUI {
    
    
    [_puzzleBgView removeFromSuperview];
    
    CGFloat puzzleBgViewX = 0;
    CGFloat puzzleBgViewY = 64;
    CGFloat puzzleBgViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat puzzleBgViewH = puzzleBgViewW;
    
    _puzzleBgView = [[UIView alloc] initWithFrame:CGRectMake(puzzleBgViewX, puzzleBgViewY, puzzleBgViewW, puzzleBgViewH)];
    _puzzleBgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_puzzleBgView];
    
    CGFloat puzzleBtnX = 0;
    CGFloat puzzleBtnY = 0;
    CGFloat puzzleBtnW = puzzleBgViewW / _difficulty - kPuzzleBtnGap * 2;
    CGFloat puzzleBtnH = puzzleBtnW;
    
    
    
    for (int i = 0; i < _puzzleCount; i++) {
        puzzleBtnX = i % _difficulty * (puzzleBtnW + kPuzzleBtnGap * 2) + kPuzzleBtnGap;
        puzzleBtnY = i / _difficulty * (puzzleBtnH + kPuzzleBtnGap * 2) + kPuzzleBtnGap;
        UIButton *puzzleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        puzzleBtn.frame = CGRectMake(puzzleBtnX, puzzleBtnY, puzzleBtnW, puzzleBtnH);
        puzzleBtn.tag = i;
        puzzleBtn.clipsToBounds = YES;
        
        int  puzzleValue = [self.randomNums[i] intValue];
        if (puzzleValue == _puzzleCount - 1) {
            puzzleBtn.backgroundColor = [UIColor clearColor];
            _maxPuzzleBtn = puzzleBtn;
        } else {
            [puzzleBtn setTitle:[NSString stringWithFormat:@"%d", puzzleValue] forState:UIControlStateNormal];
           puzzleBtn.backgroundColor = [UIColor greenColor];
            [puzzleBtn addTarget:self action:@selector(puzzleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [_puzzleBgView addSubview:puzzleBtn];
    }
}

- (void)puzzleBtnAction:(UIButton *)puzzleBtn {
    
    
    NSInteger index = puzzleBtn.tag;
    
    //上
    NSInteger upIndex = index - _difficulty;
    if (upIndex >= 0 && [self.randomNums[upIndex] intValue] == _puzzleCount - 1) {
        
        CGPoint maxPuzzleBtnCenter = _maxPuzzleBtn.center;
        CGPoint puzzleBtnCenter = puzzleBtn.center;
        _maxPuzzleBtn.tag = index;
        puzzleBtn.tag = upIndex;
        self.randomNums[upIndex] = @([self.randomNums[index] intValue]);
        self.randomNums[index] = @(_puzzleCount - 1);
        [UIView animateWithDuration:0.35 animations:^{
            puzzleBtn.center = maxPuzzleBtnCenter;
            _maxPuzzleBtn.center = puzzleBtnCenter;
        }];
        return;
        
    }
    //下
    NSInteger downIndex = index + _difficulty;
    if (downIndex <= _puzzleCount - 1 && [self.randomNums[downIndex] intValue] == _puzzleCount - 1) {
        CGPoint maxPuzzleBtnCenter = _maxPuzzleBtn.center;
        CGPoint puzzleBtnCenter = puzzleBtn.center;
        _maxPuzzleBtn.tag = index;
        puzzleBtn.tag = downIndex;
        self.randomNums[downIndex] = @([self.randomNums[index] intValue]);
        self.randomNums[index] = @(_puzzleCount - 1);
        [UIView animateWithDuration:0.35 animations:^{
            puzzleBtn.center = maxPuzzleBtnCenter;
            _maxPuzzleBtn.center = puzzleBtnCenter;
        }];
        
        return;
    }
    //左
    NSInteger leftIndex = index - 1;
    if (index % _difficulty > 0 && [self.randomNums[leftIndex] intValue] == _puzzleCount - 1) {
        CGPoint maxPuzzleBtnCenter = _maxPuzzleBtn.center;
        CGPoint puzzleBtnCenter = puzzleBtn.center;
        _maxPuzzleBtn.tag = index;
        puzzleBtn.tag = leftIndex;
        self.randomNums[leftIndex] = @([self.randomNums[index] intValue]);
        self.randomNums[index] = @(_puzzleCount - 1);
        [UIView animateWithDuration:0.35 animations:^{
            puzzleBtn.center = maxPuzzleBtnCenter;
            _maxPuzzleBtn.center = puzzleBtnCenter;
        }];
        
        return;
    }
    //右
    NSInteger rightIndex = index + 1;
    if (index % _difficulty < _difficulty - 1 && [self.randomNums[rightIndex] intValue] == _puzzleCount - 1) {
        CGPoint maxPuzzleBtnCenter = _maxPuzzleBtn.center;
        CGPoint puzzleBtnCenter = puzzleBtn.center;
        _maxPuzzleBtn.tag = index;
        puzzleBtn.tag = rightIndex;
        self.randomNums[rightIndex] = @([self.randomNums[index] intValue]);
        self.randomNums[index] = @(_puzzleCount - 1);
        [UIView animateWithDuration:0.35 animations:^{
            puzzleBtn.center = maxPuzzleBtnCenter;
            _maxPuzzleBtn.center = puzzleBtnCenter;
        }];
       
        return;
    }
    
}

- (NSMutableArray *)getNewAvailableRandomNums {
    
    //随机数字
    int inverCount = 0;
    while (1) {
        inverCount = 0;
        NSMutableArray *initializeNums = [NSMutableArray array];//初始化0-n数字
        for (int i = 0; i < _puzzleCount; i++) {
            [initializeNums addObject:@(i)];
        }
        
        NSMutableArray *randomNums = [NSMutableArray array];//随机数组
        for (int i = 0; i < _puzzleCount; i++) {
            
            
            int randomNum = arc4random() % initializeNums.count;
            
            [randomNums addObject:initializeNums[randomNum]];
            
            [initializeNums removeObjectAtIndex:randomNum];
            
        }
        //判断是否可还原拼图
        int curNum = 0;
        int nextNum = 0;
        for (int i = 0; i < _puzzleCount; i++) {
            curNum = [randomNums[i] intValue];
            if (curNum == _puzzleCount - 1) {
                inverCount += _difficulty - 1 - (i / _difficulty);
                inverCount += _difficulty - 1 - (i % _difficulty);
            }
            for (int j = i + 1; j < _puzzleCount; j++) {
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
- (IBAction)btn:(id)sender {
    
    self.randomNums = nil;
    [self.randomNums addObjectsFromArray:[self getNewAvailableRandomNums]];
    [self customUI];
    
}


@end
