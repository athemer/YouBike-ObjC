//
//  ViewController.m
//  YouBike-ObjC
//
//  Created by 劉仲軒 on 2017/5/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "ViewController.h"
#import "StationTableViewController.h"
#import "StationCollectionViewController.h"

@interface ViewController ()

@property (strong, nonatomic) StationTableViewController *stationTableViewController;
@property (strong, nonatomic) StationCollectionViewController *stationCollectionViewController;
@property (strong, nonatomic) UISegmentedControl *segmentControl;

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setUpSegmentControl];
    
    [self.navigationController setNavigationBarHidden:false animated: true];
    
    self.navigationController.navigationBar.translucent = false;
    
//    [self addTableViewVC];
    
    NSLog(@" need to check %@", [[FBSDKAccessToken currentAccessToken ] tokenString]);
    
    YouBikeManager.sharedInstance.delegate = self;
    
    [YouBikeManager.sharedInstance signInWithFacebookWithAccessToken:[FBSDKAccessToken.currentAccessToken tokenString]
                                               withCompletionHandler:^(NSString * _Nullable token,
                                                                       NSString * _Nullable tokenType,
                                                                       NSError * _Nullable error) {
                                                   
                                                   NSLog(@" Check Toekn %@", token);
                                                   NSLog(@"%@", tokenType);
                                                   
                                                   [YouBikeManager.sharedInstance getStations];
                                                   
                                               }];
    
    [self updateView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (StationTableViewController *) stationTableViewController {
    
    if (!_stationTableViewController) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
        
        _stationTableViewController = (StationTableViewController *)[storyboard instantiateViewControllerWithIdentifier: @"StationTableViewController"];
        
        [self addAsChildViewControlle:_stationTableViewController];
        
    }
    
    return _stationTableViewController;
}

- (StationCollectionViewController *)stationCollectionViewController {

    if (!_stationCollectionViewController) {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

        _stationCollectionViewController = (StationCollectionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"StationCollectionViewController"];

        [self addAsChildViewControlle:_stationCollectionViewController];

    }

    return _stationCollectionViewController;

}


//-(void) addTableViewVC {
//    
//    UITableViewController *tableViewVC = [[self storyboard ] instantiateViewControllerWithIdentifier: @"StationTableViewController"];
//    
//    [self addChildViewController: tableViewVC];
//    
//    [[self view] addSubview: tableViewVC.view];
//    
//    [tableViewVC didMoveToParentViewController: self];
//    
//}
//
//-(void) removeTableViewVC {
//    
//    UITableViewController *tableViewVC = [[self storyboard ] instantiateViewControllerWithIdentifier: @"StationTableViewController"];
//    
//    [tableViewVC willMoveToParentViewController: self];
//    
//    [[tableViewVC view] removeFromSuperview ];
//    
//    [tableViewVC removeFromParentViewController];
//    
//}

- (void)setUpSegmentControl {
    
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"List", @"Grid"]];
    [self.segmentControl setImage:[UIImage imageNamed:@"icon-list"] forSegmentAtIndex:0];
    [self.segmentControl setImage:[UIImage imageNamed:@"icon-grid"] forSegmentAtIndex:1];
    self.segmentControl.tintColor = [UIColor colorWithRed:251/255.0 green:197/255.0 blue:111/255.0 alpha:1];
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl addTarget: self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: self.segmentControl];
    
}

- (void)onChange:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        
        [self removeAsChildViewController: self.stationCollectionViewController];
        [self addAsChildViewControlle: self.stationTableViewController];
        
    } else {
        
        [self removeAsChildViewController: self.stationTableViewController];
        [self addAsChildViewControlle: self.stationCollectionViewController];
        
    }
    
}


- (void)updateView {
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
        
        [self removeAsChildViewController: self.stationCollectionViewController];
        [self addAsChildViewControlle: self.stationTableViewController];
        
    } else {
        
        [self removeAsChildViewController: self.stationTableViewController];
        [self addAsChildViewControlle: self.stationCollectionViewController];
        
    }
    
}


- (void)addAsChildViewControlle:(UIViewController *)viewController {
    
    [self addChildViewController:viewController];
    
    [self.view addSubview:viewController.view];
    
    viewController.view.frame = self.view.bounds;
//        [viewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    [viewController didMoveToParentViewController:self];
    
}

- (void)removeAsChildViewController:(UIViewController *)viewController {
    
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
    
}

#pragma mark - YouBikeManagerDelegate
- (void)manager:(YouBikeManager *)manager didGet:(NSArray <Station *> *)stations {
    
    self.stationTableViewController.station = stations;
    self.stationCollectionViewController.station = stations;

    [self.stationTableViewController.tableView reloadData];
    [self.stationCollectionViewController.collectionView reloadData];
    
    NSLog(@"numCHECK %lu", (unsigned long) self.stationTableViewController.station.count);
}

- (void)manager:(YouBikeManager *)manager didFailWith:(NSError *)error {
    
    NSLog(@"%@", error);
    
}




@end
