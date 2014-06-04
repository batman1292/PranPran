//
//  PranPranMenuViewController.m
//  PranPran
//
//  Created by Kanitkon on 6/4/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import "PranPranMenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface PranPranMenuViewController ()
@property (strong, nonatomic)NSArray *menuItems;
@property (nonatomic, strong) UINavigationController *transitionsNavigationController;
@property (nonatomic, strong) FBLoginView *loginview;
@end

@implementation PranPranMenuViewController

- (NSArray *) menuItems{
    if (!_menuItems) {
        _menuItems = @[@"Home", @"Trend", @"Social", @"Setting", @"Logout"];
    }
    return _menuItems;
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
    self.loginview = [[FBLoginView alloc] initWithReadPermissions:
                      @[@"public_profile", @"email", @"user_friends"]];
    self.loginview.delegate = self;
    // Do any additional setup after loading the view.
    self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
    NSLog(@"menu : %@", self.menuItems);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table&cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    if ([self.menuItems[indexPath.row] isEqualToString:@"Logout"]){
        self.loginview.frame = CGRectOffset(_loginview.frame, 0, 0);
        //            self.loginview.center = self.cell.center;
        [cell addSubview:self.loginview];
    }else{
        cell.textLabel.text = self.menuItems[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *menuItem = self.menuItems[indexPath.row];
    
    // This undoes the Zoom Transition's scale because it affects the other transitions.
    // You normally wouldn't need to do anything like this, but we're changing transitions
    // dynamically so everything needs to start in a consistent state.
    
    if ([menuItem isEqualToString:@"Home"]) {
        
        UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"PranPranHomeNavigationcontroller"];
        self.slidingViewController.topViewController = nav;
        [self.slidingViewController resetTopViewAnimated:YES];
        
    } else if ([menuItem isEqualToString:@"Trend"]) {
        
        UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"PranPranTrendNavigationcontroller"];
        self.slidingViewController.topViewController = nav;
        [self.slidingViewController resetTopViewAnimated:YES];
        
    } else if ([menuItem isEqualToString:@"Social"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MESettingsNavigationController"];
    } else if ([menuItem isEqualToString:@"Setting"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MESettingsNavigationController"];
    }
    //else if ([menuItem isEqualToString:@"Logout"]) {
        //self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MESettingsNavigationController"];
   // }
    
    
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"PranPranNavigationcontroller"];
    self.slidingViewController.topViewController = nav;
    [self.slidingViewController resetTopViewAnimated:YES];
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
