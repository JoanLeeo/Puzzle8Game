//
//  ViewController.m
//  Puzzle8Game
//
//  Created by AHUI_MAC on 2017/8/20.
//  Copyright © 2017年 AHUI_MAC. All rights reserved.
//

#import "ViewController.h"
#import "PigViewController.h"
#import "SoundsTableViewController.h"

#import <AudioToolbox/AudioToolbox.h>

#define kPuzzleBtnGap 2


#define kTipLbTag 1000

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, PigViewControllerDelegate, SoundsTableViewControllerDelegate> {

    UIButton *_maxPuzzleBtn;
    int _difficulty;//难度系数 3*3 4*4 5*5
    int _puzzleCount;
    BOOL _showBgImg;
    
    BOOL _showTip;
    BOOL _isSound;
    unsigned int _sound;
    
    NSString *_addArrStr;
    
    int _stepCount; //计步器
    
    NSInteger _bestRecord;
    
    

}
@property (weak, nonatomic) IBOutlet UILabel *stepCountLb;
@property (weak, nonatomic) IBOutlet UILabel *bestRecordLb;


@property (nonatomic, strong) NSMutableArray *randomNums;//存储初始化nums
@property (nonatomic, strong) UIView *puzzleBgView;
@property (nonatomic, strong) UIImage *puzzleBgImg; //背景图片

@property (nonatomic, strong) NSMutableArray *puzzleImgArr;//存储分割img


@end



@implementation ViewController

#pragma mark - Lazy loading
- (NSMutableArray *)puzzleImgArr {
    if (!_puzzleImgArr) {
        _puzzleImgArr = [NSMutableArray array];
    }
    return _puzzleImgArr;
}

- (NSMutableArray *)randomNums {
    if (!_randomNums) {
        _randomNums = [NSMutableArray array];
    }
    return _randomNums;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _bestRecord = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestRecord"];
    
    if (_bestRecord != INT_MAX) {
        self.bestRecordLb.text = [NSString stringWithFormat:@"你的最佳记录：%ld", (long)_bestRecord];
    }
    
    _stepCount = 0;
    _sound = 1104;
    _difficulty = 3;
    _puzzleCount = _difficulty * _difficulty;
    
    
    self.randomNums = nil;
    [self.randomNums addObjectsFromArray:[self getNewAvailableRandomNums]];
    [self customUI];
    //随机数字
    
    
}

- (void)customUI {
    
    
    [_puzzleBgView removeFromSuperview];
    
    CGFloat puzzleBgViewX = 0;
    CGFloat puzzleBgViewY = 64 + 20;
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
        [_puzzleBgView addSubview:puzzleBtn];
        
        
        int  puzzleValue = [self.randomNums[i] intValue];
        if (puzzleValue == _puzzleCount - 1) {
            puzzleBtn.backgroundColor = [UIColor clearColor];
            _maxPuzzleBtn = puzzleBtn;
        } else {
            
            if (_showBgImg) {
                [puzzleBtn setBackgroundImage:self.puzzleImgArr[puzzleValue] forState:UIControlStateNormal];
                [puzzleBtn setBackgroundImage:self.puzzleImgArr[puzzleValue] forState:UIControlStateHighlighted];
                
                //tip
                CGFloat tipLbW = 15;
                CGFloat tipLbH = tipLbW;
                CGFloat tipLbX = puzzleBtnW - tipLbW;
                CGFloat tipLbY = puzzleBtnH - tipLbH;
                
                UILabel *tipLb = [[UILabel alloc] initWithFrame:CGRectMake(tipLbX, tipLbY, tipLbW, tipLbH)];
                tipLb.tag = i + kTipLbTag;
                tipLb.layer.cornerRadius = tipLbW * 0.5;
                tipLb.layer.masksToBounds = YES;
                tipLb.text = [NSString stringWithFormat:@"%d", puzzleValue + 1];
                tipLb.font = [UIFont systemFontOfSize:8];
                tipLb.alpha = 0.6;
                tipLb.hidden = YES;
                tipLb.textAlignment = NSTextAlignmentCenter;
                tipLb.backgroundColor = [UIColor whiteColor];
                [puzzleBtn addSubview:tipLb];
                
            } else {
                [puzzleBtn setTitle:[NSString stringWithFormat:@"%d", puzzleValue + 1] forState:UIControlStateNormal];
                puzzleBtn.backgroundColor = [UIColor colorWithRed:0x4A / 255.0 green:0xC2 / 255.0 blue:0xFB / 255.0 alpha:1];
                
            }
            [puzzleBtn addTarget:self action:@selector(puzzleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
}





#pragma mark - Btn Action
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
        
        [self isWin];
        
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
        
        [self isWin];
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
        
        [self isWin];
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
        
        [self isWin];
        return;
    }
    
}
- (IBAction)difficultyBtnAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"难度选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"高" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _difficulty = 5;
        _puzzleCount = _difficulty * _difficulty;
        weakSelf.title = @"Puzzle 24";
        [weakSelf refreshAction:nil];
        
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"中" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _difficulty = 4;
        _puzzleCount = _difficulty * _difficulty;
        weakSelf.title = @"Puzzle 15";
        [weakSelf refreshAction:nil];

    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"低" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _difficulty = 3;
        _puzzleCount = _difficulty * _difficulty;
        weakSelf.title = @"Puzzle 8";
        [weakSelf refreshAction:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
- (IBAction)tipsBtnAction:(UIButton *)sender {
//    1104
    
    if (!_showBgImg) {
        return;
    }
    _showTip = !_showTip;
    
    if (_showTip) {
        [sender setTitle:@"关闭提示" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"显示提示" forState:UIControlStateNormal];
    }
    
    int i = 0;
    for (UIButton *puzzleBtn in _puzzleBgView.subviews) {
        
        UILabel *tipLb = [puzzleBtn viewWithTag:kTipLbTag + i];
        
        if (tipLb) {
            tipLb.hidden = !_showTip;
        }
        i++;
    }
    
    
}

//打开相册
- (IBAction)openCamera:(id)sender {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"默认数字" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _showBgImg = NO;
        [weakSelf refreshAction:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)refreshAction:(UIBarButtonItem *)sender {
    
    _stepCount = 0;
    self.stepCountLb.text = @"0";
    
    if (_showBgImg) {
        [self cutPuzzleImg:self.puzzleBgImg];
    }
    self.randomNums = nil;
    [self.randomNums addObjectsFromArray:[self getNewAvailableRandomNums]];
    [self customUI];
}

- (IBAction)moreAction:(UIBarButtonItem *)sender {
    
    
}


#pragma mark - UIImagePickerControllerDelegate

/// 选择图片
- (void)selectImageWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    picker.allowsEditing = YES;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *tmpImg = info[UIImagePickerControllerEditedImage];
        if (fabs(tmpImg.size.width - tmpImg.size.height) < 2) {
            self.puzzleBgImg = tmpImg;
        } else {
            
            CGFloat x;
            CGFloat y;
            CGFloat w;
            CGFloat h;
            if (tmpImg.size.width > tmpImg.size.height) {
                x = (tmpImg.size.width - tmpImg.size.height) * 0.5;
                y = 0;
                w = tmpImg.size.height;
                h = w;
            } else {
                x = 0;
                y = (tmpImg.size.height - tmpImg.size.width) * 0.5;
                w = tmpImg.size.width;
                h = w;
            }
            CGImageRef imgRef = CGImageCreateWithImageInRect(tmpImg.CGImage, CGRectMake(x, y, w, h));
            self.puzzleBgImg = [UIImage imageWithCGImage:imgRef];
        }
        
        
        _showBgImg = YES;
        [self refreshAction:nil];
    }];
}

#pragma mark - Other
- (void)cutPuzzleImg:(UIImage *)img {

    self.puzzleImgArr = nil;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat puzzleBtnW = screenW / _difficulty;
    CGFloat multi = img.size.width / screenW;
    CGFloat imgX = 0;
    CGFloat imgY = 0;
    CGFloat imgW = (screenW / _difficulty - kPuzzleBtnGap * 2) * multi;
    CGFloat imgH = imgW;
    
    for (int i = 0; i < _puzzleCount; i++) {
        imgX = (i % _difficulty * (puzzleBtnW + kPuzzleBtnGap * 2) + kPuzzleBtnGap) * multi;
        imgY = (i / _difficulty * (puzzleBtnW + kPuzzleBtnGap * 2) + kPuzzleBtnGap) * multi;
        // 切割图片
        CGRect rect = CGRectMake(imgX, imgY, imgW, imgH);
        CGImageRef imgRef = CGImageCreateWithImageInRect(img.CGImage, rect);
        [self.puzzleImgArr addObject:[UIImage imageWithCGImage:imgRef]];
    }
    
}
- (void)isWin {
    
    
    
    _stepCount++;
    
    self.stepCountLb.text = [NSString stringWithFormat:@"%d", _stepCount];
    
    AudioServicesPlaySystemSound(_sound);
    
    NSInteger count = 0;
    for (int i = 0; i < _puzzleCount; i++) {
        if ([self.randomNums[i] intValue] != i) {
            return;
        }
        count++;
    }
    if (count == _puzzleCount) {
        ;
        UIAlertController *alert =  [UIAlertController alertControllerWithTitle:@"恭喜你" message:[NSString stringWithFormat:@"用了%ld步成功过关！", (long)_stepCount] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (_stepCount < _bestRecord) {
                _bestRecord = _stepCount;
                [[NSUserDefaults standardUserDefaults] setInteger:_bestRecord forKey:@"bestRecord"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.bestRecordLb.text = [NSString stringWithFormat:@"你的最佳记录：%ld", (long)_bestRecord];
            }
        }]];
        [self presentViewController:alert animated:YES completion:nil];
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

- (void)changePig:(NSInteger)index {
    _showBgImg = YES;
    self.puzzleBgImg = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", (long)index]];
    [self refreshAction:nil];
}
#pragma mark - SoundsTableViewControllerDelegate
- (void)changeSound:(NSInteger)soundId {
    
    _sound = (unsigned int)soundId;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id page2 = segue.destinationViewController;
    // 设定委托为self
    [page2 setValue:self forKey:@"delegate"];
    
}
//
@end
