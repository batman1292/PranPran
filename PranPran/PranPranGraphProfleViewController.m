//
//  PranPranGraphProfleViewController.m
//  PranPran
//
//  Created by Kanitkon on 5/28/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import "PranPranGraphProfleViewController.h"
#import "PranPranAPIController.h"
#import "PNChart.h"
#import "PranPranAppDelegate.h"
#import "UIViewController+ECSlidingViewController.h"

@interface PranPranGraphProfleViewController ()
@property (nonatomic, weak) PranPranAppDelegate *appDelegate;
@end

@implementation PranPranGraphProfleViewController

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
    [PranPranAPIController getWeightDataByFBid:self.appDelegate.facebookID Completed:^(id object) {
        NSLog(@"data : %@", [object objectForKey:@"data"]);
        PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
        [lineChart setXLabels:[[object objectForKey:@"data"][0] objectForKey:@"Date"]];
        

        NSArray * data01Array = [[object objectForKey:@"data"][1] objectForKey:@"Weight"];
        PNLineChartData *data01 = [PNLineChartData new];
        data01.color = PNFreshGreen;
        data01.itemCount = lineChart.xLabels.count;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [data01Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        lineChart.chartData = @[data01];
        [lineChart strokeChart];
        [self.view addSubview:lineChart];
    } Failure:^(NSError *error) {
        NSLog(@"error : %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
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
