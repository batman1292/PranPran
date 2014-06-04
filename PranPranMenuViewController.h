//
//  PranPranMenuViewController.h
//  PranPran
//
//  Created by Kanitkon on 6/4/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface PranPranMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
