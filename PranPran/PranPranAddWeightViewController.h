//
//  PranPranAddWeightViewController.h
//  PranPran
//
//  Created by Kanitkon on 5/22/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PranPranAddWeightViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *facebookID;
@property (strong, nonatomic) NSNumber *height;

@property (weak, nonatomic) IBOutlet UITextField *dataWeight;

- (IBAction)saveWeightButton:(id)sender;
@end
