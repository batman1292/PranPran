//
//  PranPranAddWeightViewController.h
//  PranPran
//
//  Created by Kanitkon on 5/22/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PranPranAddWeightViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *dataWeight;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataDate;

- (IBAction)saveWeightButton:(id)sender;
@end
