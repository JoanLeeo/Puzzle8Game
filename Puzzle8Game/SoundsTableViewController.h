//
//  SoundsTableViewController.h
//  Puzzle8Game
//
//  Created by AHUI_MAC on 2017/8/23.
//  Copyright © 2017年 AHUI_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SoundsTableViewControllerDelegate <NSObject>
- (void)changeSound:(NSInteger)soundId;

@end

@interface SoundsTableViewController : UITableViewController
@property (nonatomic, weak) id<SoundsTableViewControllerDelegate>delegate;
@end
