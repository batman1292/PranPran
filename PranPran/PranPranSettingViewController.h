//
//  PranPranSettingViewController.h
//  PranPran
//
//  Created by Kanitkon on 6/5/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidingViewController.h"

@interface PranPranSettingViewController : SlidingViewController <UIScrollViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;
@property (weak, nonatomic) IBOutlet UITextField *editTarget;
@property (weak, nonatomic) IBOutlet UITextField *editHeight;
@property (weak, nonatomic) IBOutlet UITextField *editAge;
@property (weak, nonatomic) IBOutlet UISegmentedControl *editGender;

- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)saveButtonTapped:(id)sender;
@end
