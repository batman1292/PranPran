//
//  PranPranAddProfileViewController.h
//  PranPran
//
//  Created by Kanitkon on 5/22/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidingViewController.h"

@interface PranPranAddProfileViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *dataName;
@property (weak, nonatomic) IBOutlet UITextField *dataAge;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dataGender;
@property (weak, nonatomic) IBOutlet UITextField *dataHeight;
@property (weak, nonatomic) IBOutlet UITextField *dataWeight;

@property (strong, nonatomic) NSString *name;

- (IBAction)saveProfileButton:(id)sender;

@end
