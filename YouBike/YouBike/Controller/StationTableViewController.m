//
//  StationTableViewController.m
//  YouBike-ObjC
//
//  Created by 劉仲軒 on 2017/5/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "StationTableViewController.h"
#import "StationTableViewCell.h"
#import "YouBikeManager.h"


@interface StationTableViewController ()




@end

@implementation StationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerNib:[UINib nibWithNibName: @"StationTableViewCell"
                                               bundle: nil]
         forCellReuseIdentifier: @"StationTableViewCell"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    NSLog(@"====================viewWillAppear==================");
}


- (void)viewDidAppear:(BOOL)animated {
    
    
    [super viewDidAppear:animated];
    
    NSLog(@"-------------------- viewDidAppear --------------------");
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    NSLog(@"???????? %lu", (unsigned long)self.station.count);
    
    return self.station.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"StationTableViewCell" forIndexPath:indexPath];
    
    
    cell.addressLabel.text = self.station[indexPath.row].address;
    cell.nameLabel.text = self.station[indexPath.row].name;
    cell.bikesLabel.text = @"台";
    cell.numberLabel.text = [NSString stringWithFormat: @"%d", self.station[indexPath.row].numberOfRemainingBikes];
    cell.remainLabel.text = @"剩";

    cell.mapButton.layer.borderWidth = 1;
    cell.mapButton.layer.borderColor = [UIColor colorWithRed:204/255.0 green:113/255.0 blue:93/255.0 alpha:1].CGColor;
    cell.mapButton.layer.cornerRadius = 4;
    cell.mapButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cell.mapButton addTarget:self action:@selector(viewMap:) forControlEvents:UIControlEventTouchUpInside];

    cell.markerImageView.image = [cell.markerImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.markerImageView.tintColor = [UIColor colorWithRed:160/255.0 green:98/255.0 blue:90/255.0 alpha:1];

    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    return 120;
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    Station *selectedStation = self.station[indexPath.row];

        MapTableViewController *MVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MapTableViewController"];

        MVC.selectedStation = selectedStation;
        MVC.isFromButton = false;

        MVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:MVC animated:true];

}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger lastElement = self.station.count - 1;
    
    if (indexPath.row == lastElement && YouBikeManager.sharedInstance.stationParameter != nil) {
        [YouBikeManager.sharedInstance getStations];
    }
    
}


#pragma mark - Helper Method
- (void)viewMap:(UIButton *)sender {
    
    StationTableViewCell *cell = (StationTableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Station *selectedStation = self.station[indexPath.row];
    
    MapTableViewController *MVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MapTableViewController"];
    
    MVC.selectedStation = selectedStation;
    MVC.isFromButton = true;
    
    MVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:MVC animated:true];
    
}


@end
