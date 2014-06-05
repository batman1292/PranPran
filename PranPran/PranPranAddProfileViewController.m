//
//  PranPranAddProfileViewController.m
//  PranPran
//
//  Created by Kanitkon on 5/22/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import "PranPranAddProfileViewController.h"
#import "PranPranAPIController.h"
#import "PranPranAppDelegate.h"

@interface PranPranAddProfileViewController ()
@property (nonatomic, weak) PranPranAppDelegate *appDelegate;
@end

@implementation PranPranAddProfileViewController

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
    [self.navigationItem setHidesBackButton:YES animated:NO];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGestrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
    [self.scrollView addGestureRecognizer:tapGestrue];
    self.dataName.text = self.name;
    self.dataName.delegate = self;
    self.dataAge.delegate = self;
    self.dataHeight.delegate = self;
    self.dataWeight.delegate = self;
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

#pragma mark - Button
- (IBAction)saveProfileButton:(id)sender{
    if ([self.dataName.text isEqualToString:@""] || [self.dataAge.text isEqualToString:@""] || [self.dataHeight.text isEqualToString:@""] || [self.dataWeight.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"กรุณากรอกข้อมูลให้ครบทุกช่อง" delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
        [alert show];
    }else{
        [PranPranAPIController addProfileIntoDB:self.appDelegate.facebookID
                                           name:self.dataName.text
                                            age:[NSNumber numberWithInt:[self.dataAge.text intValue]]
                                         gender:[NSNumber numberWithInteger:self.dataGender.selectedSegmentIndex]
                                         height:[NSNumber numberWithFloat:[self.dataHeight.text floatValue]]
                                         weight:[NSNumber numberWithFloat:[self.dataWeight.text floatValue]]
                                           goal:[NSNumber numberWithInteger:0]
                                      Completed:^(id object) {
                                        
                                      }
                                        Failure:^(NSError *error) {
                                            NSLog(@"error : %@", error);
                                        }];
        [PranPranAPIController setWeight:self.appDelegate.facebookID
                                  Weight:[NSNumber numberWithFloat:[self.dataWeight.text floatValue]]
                                  Height:[NSNumber numberWithFloat:[self.dataHeight.text floatValue]]
                               Completed:^(id object) {
            
                               }
                                 Failure:^(NSError *error) {
                                     NSLog(@"error %@", error);
                                 }];
        UIViewController * viewProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"PranPranProfileView"];
        [self.navigationController pushViewController:viewProfile animated:YES];
    }
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
