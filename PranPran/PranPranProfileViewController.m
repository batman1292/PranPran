//
//  PranPranProfileViewController.m
//  PranPran
//
//  Created by Kanitkon on 5/22/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import "PranPranProfileViewController.h"
#import "CoreData.h"
#import "TrendTableViewCell.h"

@interface PranPranProfileViewController ()
@property (nonatomic, strong) CoreData *coreData;
@property (nonatomic, strong) NSDictionary *profileData;
@property (strong, nonatomic) CBCentralManager *center;
@property (nonatomic, strong) NSNumber *resultBefore;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *weightData;
@property (nonatomic, strong) NSTimer *timer;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES animated:NO];
    //setup Singleton
//    [self.navigationItem setTitle];
//    NSLog(@"profile : %@", self.profileData);
    
    //set corebluetooth
    self.center = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.resultBefore = [NSNumber numberWithInt:0];
    self.count = [NSNumber numberWithInt:0];
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
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Really reset?" message:@"Do you really want to reset this game?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
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
        [self.coreData setWeightFromBluetooth:self.weightData];
        self.weightData = [self.coreData getLastHistoryWeight];
        [self.tableView reloadData];
        [self.center scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    }else{
        self.weightData = [self.coreData getLastHistoryWeight];
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
            cell.textLabel.text = [NSString stringWithFormat:@"BMI : %.2f", [self.coreData getLastHistoryBMI].floatValue];
            break;
        case 2:
//            cell = cellTrend;
            cellTrend.trendWeight.text = [self.coreData getTerndWeight];
            cellTrend.trendBMI.text = [self.coreData getTerndBMI];
            cell = cellTrend;
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cellGoal"];
            if ([[self.profileData objectForKey:@"goal"] intValue] == 0) {
                cell.textLabel.text = @"Goal : คุณไม่ได้ตั้งไว้";
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"Goal : %@ Kg", [self.profileData objectForKey:@"goal"]];
            }
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

- (NSString *)changeWeightFormat:(NSNumber *)dataIn{
    int tempFloat = dataIn.intValue%100;
    int tempInt = dataIn.intValue/100;
//    NSLog(@"x %f", x.floatValue);
    return [NSString stringWithFormat:@"%d.%d", tempInt, tempFloat];
}

- (IBAction)addWeightButton:(id)sender{
    [self.center stopScan];
    UIViewController * addProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"PranPranAddWeightView"];
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
