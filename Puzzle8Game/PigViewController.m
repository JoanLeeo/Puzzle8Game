//
//  PigViewController.m
//  Puzzle8Game
//
//  Created by AHUI_MAC on 2017/8/22.
//  Copyright © 2017年 AHUI_MAC. All rights reserved.
//

#import "PigViewController.h"

@interface PigViewController ()

@end

@implementation PigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)pigAction:(UIButton *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(changePig:)]) {
        [self.delegate changePig:sender.tag];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
