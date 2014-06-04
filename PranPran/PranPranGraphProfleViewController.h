//
//  PranPranGraphProfleViewController.h
//  PranPran
//
//  Created by Kanitkon on 5/28/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidingViewController.h"

@interface PranPranGraphProfleViewController : SlidingViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;

- (IBAction)menuButtonTapped:(id)sender;

@end
