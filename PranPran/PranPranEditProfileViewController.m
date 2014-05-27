//
//  PranPranEditProfileViewController.m
//  PranPran
//
//  Created by Kanitkon on 5/22/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import "PranPranEditProfileViewController.h"
#import "CoreData.h"

@interface PranPranEditProfileViewController ()
@property (nonatomic, strong) CoreData *coreData;
@property (nonatomic, strong) NSDictionary *profileData;
@end

@implementation PranPranEditProfileViewController

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
    self.profileData = [self.coreData getProfile];
    self.editName.text = [self.profileData objectForKey:@"name"];
    self.editAge.text = [NSString stringWithFormat:@"%@",[self.profileData objectForKey:@"age"]];
    [self.editGender setSelectedSegmentIndex:[[self.profileData objectForKey:@"gender"] intValue]];
    self.editHeight.text = [NSString stringWithFormat:@"%@",[self.profileData objectForKey:@"height"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editProfileButton:(id)sender{
    if ([self.editName.text isEqualToString:@""] ||
        [self.editAge.text isEqualToString:@""] ||
        [self.editHeight.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"กรุณากรอกข้อมูลให้ครบทุกช่อง" delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
        [alert show];
    }else{
        //add input into profile coredata
        [self.coreData editProfile:self.editName.text
                               age:[NSNumber numberWithInt:[self.editAge.text intValue]]
                            gender:[NSNumber numberWithInteger:self.editGender.selectedSegmentIndex]
                            height:[NSNumber numberWithFloat:[self.editHeight.text floatValue]]];
        
        //change page
        UIViewController * addProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"PranPranProfileView"];
        [self.navigationController pushViewController:addProfile animated:YES];
    }

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
