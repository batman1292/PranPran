//
//  PranPranEditProfileViewController.h
//  PranPran
//
//  Created by Kanitkon on 5/22/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PranPranEditProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *editName;
@property (weak, nonatomic) IBOutlet UITextField *editAge;
@property (weak, nonatomic) IBOutlet UISegmentedControl *editGender;
@property (weak, nonatomic) IBOutlet UITextField *editHeight;
@property (weak, nonatomic) IBOutlet UITextField *editGoal;

- (IBAction)editProfileButton:(id)sender;
@end
