//
//  PranPranAddWeightViewController.m
//  PranPran
//
//  Created by Kanitkon on 5/22/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import "PranPranAddWeightViewController.h"
#import "CoreData.h"

@interface PranPranAddWeightViewController ()
@property (nonatomic, strong) CoreData *coreData;
@end

@implementation PranPranAddWeightViewController

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
    //setup Singleton
    self.coreData = [CoreData sharedCoredata];
    UITapGestureRecognizer *tapGestrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tapGestrue];
    self.dataWeight.delegate = self;
}

-(void)handleTap{
    for (UITextField *textField in self.view.subviews) {
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

- (IBAction)saveWeightButton:(id)sender{
    if ([self.dataWeight.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"กรุณากรอกข้อมูลให้ครบทุกช่อง" delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
        [alert show];
    }else{
        [self.coreData setWeight:[NSNumber numberWithFloat:[self.dataWeight.text floatValue]]
                                    ];
    }
    UIViewController * addProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"PranPranProfileView"];
    [self.navigationController pushViewController:addProfile animated:YES];
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
