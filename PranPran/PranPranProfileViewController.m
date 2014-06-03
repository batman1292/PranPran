//
//  PranPranProfileViewController.m
//  PranPran
//
//  Created by Kanitkon on 5/22/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import "PranPranProfileViewController.h"
#import "PranPranAppDelegate.h"
#import "TrendTableViewCell.h"
#import "PranPranAPIController.h"
#import "PranPranAddWeightViewController.h"
#import "PranPranGraphProfleViewController.h"

@interface PranPranProfileViewController ()
@property (nonatomic, strong) FBLoginView *loginview;
@property (nonatomic, weak) PranPranAppDelegate *appDelegate;
@property (nonatomic, strong) NSDictionary *profileData;
@property (strong, nonatomic) CBCentralManager *center;
@property (nonatomic, strong) NSNumber *resultBefore;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *weightData;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation PranPranProfileViewController
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    self.loginview = [[FBLoginView alloc] initWithReadPermissions:
                              @[@"public_profile", @"email", @"user_friends"]];
    self.loginview.delegate = self;
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES animated:NO];
    //setup Singleton
//    [self.navigationItem setTitle];
//    NSLog(@"profile : %@", self.profileData);
    //set corebluetooth
    self.center = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.resultBefore = [NSNumber numberWithInt:0];
    self.count = [NSNumber numberWithInt:0];
    
    [PranPranAPIController getDataByFBid:self.appDelegate.facebookID Completed:^(id object) {
        if ([object objectForKey:@"data"] == nil){
            [self viewDidLoad];
        }else{
            self.profileData = @{@"name":[object objectForKey:@"data"][0][@"name"],
                             @"height":[object objectForKey:@"data"][0][@"height"],
                             @"bmi":[object objectForKey:@"data"][1][@"bmi"],
                             @"weight":[object objectForKey:@"data"][1][@"weight"],
                             @"beWeight":[object objectForKey:@"data"][1][@"beforeWeight"],
                             @"beBMI":[object objectForKey:@"data"][1][@"beforeBMI"]
                                                     };
            self.weightData = [object objectForKey:@"data"][1][@"weight"];
            NSLog(@"profiledata : %@", self.profileData);
            [self.tableView reloadData];
        }
    } Failure:^(NSError *error) {
//        [self viewDidLoad];
        NSLog(@"error : %@", error);
    }];
    
}

//over write bluetooth method
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    // You should test all scenarios
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    if (central.state == CBCentralManagerStatePoweredOn) {
        // Scan for devices
        [self.center scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    if ([peripheral.name isEqualToString:@"Lemon"]) {
        NSTimeInterval currentSeconds = [NSDate timeIntervalSinceReferenceDate];
        int currentMilliSeconds =  currentSeconds;
        // Save a local copy of the peripheral, soCoreBluetooth doesn't get rid of it
        NSData *data = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
        NSRange r;
        if (data.length == 11){
            r.location = 8;
            r.length = 3;
            NSString *asciiData = [[NSString alloc] initWithData:[data subdataWithRange:r] encoding:NSASCIIStringEncoding];
            int result = 0;
            for (int i=0; i<[asciiData length]; i++) {
                int asciiCode = [asciiData characterAtIndex:i];
                unsigned char character = asciiCode; // this step could probably be combined with the last
                // for each bit in a byte extract the bit
                for (int j=0; j < 8; j++) {
                    int bit = (character >> j) & 1;
                    if (j>3){
                        if(i==0){
                            result += bit*(pow(2.0, j+4));
                        }else if(i==1){
                            result += bit*(pow(2.0, j));
                        }else{
                            result += bit*(pow(2.0, j-4));
                        }
                    }
                }
            }
            if (self.resultBefore.intValue == result){
                NSTimeInterval seconds = [NSDate timeIntervalSinceReferenceDate];
                int milliseconds = seconds;
                if (currentMilliSeconds == milliseconds) {
                    NSLog(@"same seconds");
                    self.count = [NSNumber numberWithInt:self.count.intValue+1];
                    if(self.count.intValue > 10){
                        self.count = [NSNumber numberWithInt:0];
                        [self.center stopScan];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%.1f",self.resultBefore.floatValue/10] message:@"That is your Weight?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:nil];
                        // optional - add more buttons:
                        [alert addButtonWithTitle:@"Yes"];
                        [alert show];
                    }
                }
            }else{
                self.count = [NSNumber numberWithInt:0];
            }
//            if (self.count.intValue != 0) {
//                self.weightData = [self.coreData getLastHistoryWeight];
//                [self.tableView reloadData];
//            }else{
                self.resultBefore = [NSNumber numberWithInt:result];
                self.weightData = [NSNumber numberWithFloat:self.resultBefore.floatValue/10];
                [self.tableView reloadData];
//            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [PranPranAPIController setWeight:self.appDelegate.facebookID Weight:[NSNumber numberWithFloat:[self.weightData floatValue]] Height:[NSNumber numberWithFloat:[self.profileData[@"height"] floatValue]] Completed:^(id object) {
            
        } Failure:^(NSError *error) {
            NSLog(@"error %@", error);
        }];
        [PranPranAPIController getDataByFBid:self.appDelegate.facebookID Completed:^(id object) {
            self.profileData = @{@"name":[object objectForKey:@"data"][0][@"name"],
                                 @"height":[object objectForKey:@"data"][0][@"height"],
                                 @"bmi":[object objectForKey:@"data"][1][@"bmi"],
                                 @"weight":[object objectForKey:@"data"][1][@"weight"],
                                 @"beWeight":[object objectForKey:@"data"][1][@"beforeWeight"],
                                 @"beBMI":[object objectForKey:@"data"][1][@"beforeBMI"]
                                 };
            self.weightData = [object objectForKey:@"data"][1][@"weight"];
            NSLog(@"profiledata : %@", self.profileData);
            [self.tableView reloadData];
            [self.center scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
        } Failure:^(NSError *error) {
            NSLog(@"error : %@", error);
        }];
    }else{
        self.weightData = self.profileData[@"weight"];
        [self.tableView reloadData];
        [self.center scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table&cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellWeight"];
    TrendTableViewCell *cellTrend = [tableView dequeueReusableCellWithIdentifier:@"cellTrend"];
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cellWeight"];
            cell.textLabel.text = [NSString stringWithFormat:@"Weight : %.1f Kg", self.weightData.floatValue];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"BMI : %.2f", [self.profileData[@"bmi"] floatValue]];
            break;	
        case 2:
//            cell = cellTrend;
            if ([self.profileData[@"beWeight"] floatValue] != 0.0){
                float changeWeight = ([self.profileData[@"weight"] floatValue] - [self.profileData[@"beWeight"] floatValue]);
                float perChangeWeight = changeWeight*100/[self.profileData[@"weight"] floatValue];
                cellTrend.trendWeight.text = [NSString stringWithFormat:@"Weight change %.1f , perChange %.2f ", changeWeight, perChangeWeight];
                float changeBMI = ([self.profileData[@"bmi"] floatValue] - [self.profileData[@"beBMI"] floatValue]);
                float perChangeBMI = changeWeight*100/[self.profileData[@"bmi"] floatValue];
                cellTrend.trendBMI.text = [NSString stringWithFormat:@"BMI change %.1f , perChange %.2f ", changeBMI, perChangeBMI];
            }else{
                cellTrend.trendWeight.text = @"Trend Weight : No enough data";
                cellTrend.trendBMI.text = @"Trend BMI : No enough data";
            }
            cell = cellTrend;
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cellGoal"];
            self.loginview.frame = CGRectOffset(_loginview.frame, (137-(_loginview.frame.size.width / 2)), (35	-(_loginview.frame.size.height / 2)));
//            self.loginview.center = self.cell.center;
            [cell addSubview:self.loginview];
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:20.0];
    [cell.textLabel setTextAlignment: NSTextAlignmentCenter];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (IBAction)addWeightButton:(id)sender{
    [self.center stopScan];
    PranPranAddWeightViewController * addWeight = [self.storyboard instantiateViewControllerWithIdentifier:@"PranPranAddWeightView"];
    //addWeight.facebookID = self.facebookID;
    addWeight.height = self.profileData[@"height"];
    [self.navigationController pushViewController:addWeight animated:YES];
}

- (IBAction)viewGrahpButton:(id)sender{
    [self.center stopScan];
    PranPranGraphProfleViewController * addWeight = [self.storyboard instantiateViewControllerWithIdentifier:@"PranPranGraphProfleView"];
    //addWeight.facebookID = self.facebookID;
    [self.navigationController pushViewController:addWeight animated:YES];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    UIViewController *mainView = [self.storyboard instantiateViewControllerWithIdentifier:@"PranPranView"];
    [self.navigationController pushViewController:mainView animated:YES];
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
