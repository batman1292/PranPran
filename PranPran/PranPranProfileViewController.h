//
//  PranPranProfileViewController.h
//  PranPran
//
//  Created by Kanitkon on 5/22/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//, CBCentralManagerDelegate

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBAdvertisementData.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SlidingViewController.h"

@interface PranPranProfileViewController : SlidingViewController <UITableViewDataSource, UITableViewDelegate, CBCentralManagerDelegate, FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;

- (IBAction)addWeightButton:(id)sender;
- (IBAction)menuButtonTapped:(id)sender;
@end
