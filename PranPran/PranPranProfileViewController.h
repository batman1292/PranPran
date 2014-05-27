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

@interface PranPranProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CBCentralManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *facebookID;

- (IBAction)addWeightButton:(id)sender;
@end
