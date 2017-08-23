//
//  SoundsTableViewController.m
//  Puzzle8Game
//
//  Created by AHUI_MAC on 2017/8/23.
//  Copyright © 2017年 AHUI_MAC. All rights reserved.
//

#import "SoundsTableViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SoundsTableViewController () {
    int _selSound;
}
@property (strong, nonatomic) IBOutlet UITableView *soundsTableView;
@property (nonatomic, strong) NSArray *soundsArray;


@end

@implementation SoundsTableViewController


- (NSArray *)soundsArray {
    if (!_soundsArray) {
        _soundsArray = @[@"关闭提示音",@"1001",@"1004",@"1057",@"1071",@"1072",@"1075",@"1100",@"1103",@"1104",@"1105",@"1113",@"1114",@"1117",@"1118",@"1119",@"1121",@"1122",@"1123",@"1124",@"1125",@"1126",@"1127",@"1128",@"1130",@"1131",@"1155",@"1156",@"1157",@"1200",@"1201",@"1202",@"1203",@"1204",@"1205",@"1206",@"1207",@"1208",@"1209",@"1210",@"1211",@"1261",@"1395",@"1396",@"1397",@"1405",@"1407",@"1421",@"1422",@"1426",@"1427",@"1428"];
    }
    return _soundsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.soundsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"soundsTableViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.soundsArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    _selSound = [self.soundsArray[indexPath.row] intValue];
    
    AudioServicesPlaySystemSound(_selSound);
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)soundDoneAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(changeSound:)]) {
        [self.delegate changeSound:_selSound];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
