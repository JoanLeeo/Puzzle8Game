//
//  PigViewController.h
//  Puzzle8Game
//
//  Created by AHUI_MAC on 2017/8/22.
//  Copyright © 2017年 AHUI_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PigViewControllerDelegate <NSObject>



- (void)changePig:(NSInteger)index;

@end
@interface PigViewController : UIViewController
@property (nonatomic, weak) id<PigViewControllerDelegate>delegate;
@end
