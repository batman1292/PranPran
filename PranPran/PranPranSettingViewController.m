//
//  PranPranSettingViewController.m
//  PranPran
//
//  Created by Kanitkon on 6/5/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import "PranPranSettingViewController.h"
#import "PranPranAPIController.h"
#import "PranPranAppDelegate.h"
#import "UIViewController+ECSlidingViewController.h"

@interface PranPranSettingViewController ()
@property (nonatomic, weak) PranPranAppDelegate *appDelegate;
@end

@implementation PranPranSettingViewController

-(PranPranAppDelegate *)appDelegate {
    if (!_appDelegate) {
        _appDelegate = [[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [PranPranAPIController getDataByFBid:self.appDelegate.facebookID Completed:^(id object) {
        if ([object objectForKey:@"data"] == nil){
            [self viewDidLoad];
        }else{
            NSLog(@"data : %@", object);
            self.editTarget.text = [object objectForKey:@"data"][0][@"goal"];
            self.editAge.text = [object objectForKey:@"data"][0][@"age"];
            self.editHeight.text = [object objectForKey:@"data"][0][@"height"];
            [self.editGender setSelectedSegmentIndex:[[object objectForKey:@"data"][0][@"gender"] intValue]];
        }
    } Failure:^(NSError *error) {
        //        [self viewDidLoad];
        NSLog(@"error : %@", error);
    }];
    UITapGestureRecognizer *tapGestrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
    [self.scrollView addGestureRecognizer:tapGestrue];
    self.editTarget.delegate = self;
    self.editAge.delegate = self;
    self.editHeight.delegate = self;
}

-(void)handleTap{
    for (UITextField *textField in self.scrollView.subviews) {
        if ([textField isFirstResponder]) {
            [textField resignFirstResponder];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonAction
- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
- (IBAction)saveButtonTapped:(id)sender{
    [PranPranAPIController editProfileDataByFBid:self.appDelegate.facebookID
                                             Age:[NSNumber numberWithInt:[self.editAge.text intValue]]
                                          Gender:[NSNumber numberWithInteger:self.editGender.selectedSegmentIndex]
                                          Height:[NSNumber numberWithInt:[self.editHeight.text intValue]]
                                          Target:[NSNumber numberWithFloat:[self.editTarget.text floatValue]]
                                       Completed:^(id object) {
                                           NSLog(@"%@", object);
                                           UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"PranPranHomeNavigationcontroller"];
                                           self.slidingViewController.topViewController = nav;
                                           [self.slidingViewController resetTopViewAnimated:YES];
                                       } Failure:^(NSError *error) {
                                           NSLog(@"error : %@", error);
                                       }];
}

#pragma mark - ScrollPage
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //    if(textField.tag == 3 || textField.tag == 4){
    if(textField.frame.origin.y >= 216){
        //        ScrollView.contentSize = CGSizeMake(320, 600);
        self.scrollView.frame =  CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [UIView animateWithDuration:0.25 animations:^{
            // set origin axis Y is 65 because navigationbar height 65px
            self.scrollView.contentSize = CGSizeMake(320, 800);
            self.scrollView.frame =  CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        }];
        [self.scrollView scrollRectToVisible:CGRectMake(textField.frame.origin.x, textField.frame.origin.y, 600, 600) animated:YES];
    }else{
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 600, 600) animated:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
