//
//  PranPranViewController.m
//  PranPran
//
//  Created by Kanitkon on 5/22/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import "PranPranAppDelegate.h"
#import "PranPranViewController.h"
#import "PranPranAPIController.h"
#import "PranPranAddProfileViewController.h"

@interface PranPranViewController ()
@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, weak) PranPranAppDelegate *appDelegate;

@end

@implementation PranPranViewController

-(NSString *) _facebookID{
    if (!_facebookID){
        _facebookID = [[NSString alloc] init];
    }
    return _facebookID;
}

-(PranPranAppDelegate *)appDelegate {
    if (!_appDelegate) {
        _appDelegate = [[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    NSDateFormatter * convertDateToLocal =[[NSDateFormatter alloc]init];
    [convertDateToLocal setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [convertDateToLocal setTimeZone:[NSTimeZone localTimeZone]];
    [convertDateToLocal setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    NSDate *notificationDate = [convertDateToLocal dateFromString:@"2014-06-03 19:10:20"];
    localNotification.fireDate = notificationDate;
    localNotification.alertBody = @"Open App Now";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationItem setTitle:@"Welcome 2 PranPran"];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    //set up facebook login button
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:
                              @[@"public_profile", @"email", @"user_friends"]];
    loginView.delegate = self;
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), (self.view.center.y - (loginView.frame.size.height / 2)));
    loginView.center = self.view.center;
    [self.view addSubview:loginView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
//    NSLog(@"id : %@", user.objectID);
    self.appDelegate.facebookID = user.objectID;
    self.facebookID = user.objectID;
    self.name = user.name;
}

// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
//    NSLog(@"Delegateid %@", self.appDelegate.facebookID);
    if (self.appDelegate.facebookID == nil) {
        NSLog(@"eksie");
        [self viewDidLoad];
    }else{
        [PranPranAPIController checkUserByFBid:self.appDelegate.facebookID Completed:^(id object) {
//        NSLog(@"data : %@", [object objectForKey:@"status"]);
                if([[object objectForKey:@"status"] isEqualToString:@"found"]){
                    UIViewController * viewProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"PranPranSlidingView"];
                    [self.navigationController pushViewController:viewProfile animated:YES];
                }else{
                    PranPranAddProfileViewController * addProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"PranPranAddProfileView"];
                    addProfile.name = self.name;
                    [self.navigationController pushViewController:addProfile animated:YES];
                }
            [self reloadInputViews];
        } Failure:^(NSError *error) {
            NSLog(@"error : %@", error);
        }];
    }
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
//    self.profilePictureView.profileID = nil;
//    self.nameLabel.text = @"";
//    self.statusLabel.text= @"You're not logged in!";
}

// You need to override loginView:handleErroหกดเr in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}
@end
