//
//  PranPranAPIController.m
//  PranPran
//
//  Created by Kanitkon on 5/26/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import "PranPranAPIController.h"
#import "AFNetworking.h"

@implementation PranPranAPIController

+ (void)checkUserByFBid:(NSString*)fbid Completed:(CompleteHandle)completed Failure:(FailureHandle)failure{
    //set parameter
    NSDictionary *parameters = @{@"fbid": fbid};
//    NSLog(@"parameter : %@", parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://s2weight.azurewebsites.net/api/CheckDataByFBid.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *localError = nil;
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&localError];
//        NSLog(@"data : %@", parsedObject);
        completed(parsedObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)addProfileIntoDB:(NSString*)inputFBid name:(NSString*)inputName age:(NSNumber *)inputAge gender:(NSNumber *)inputGender height:(NSNumber *)inputHeight weight:(NSNumber*)inputWeight goal:(NSNumber*)inputGoal Completed:(CompleteHandle)completed Failure:(FailureHandle)failure
{
    //set parameter
    NSDictionary *parameters = @{@"fbid": inputFBid,
                                 @"name":inputName,
                                  @"age":[NSString stringWithFormat:@"%d", inputAge.intValue],
                               @"gender":[NSString stringWithFormat:@"%d", inputGender.intValue],
                               @"height":[NSString stringWithFormat:@"%d", inputHeight.intValue],
                               @"weight":[NSString stringWithFormat:@"%0.2f", inputWeight.floatValue],
                                 @"goal":[NSString stringWithFormat:@"%d", inputGoal.intValue]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://s2weight.azurewebsites.net/api/AddProfileData.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *localError = nil;
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&localError];
        //        NSLog(@"data : %@", parsedObject);
        completed(parsedObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

+ (void)getDataByFBid:(NSString*)fbid Completed:(CompleteHandle)completed Failure:(FailureHandle)failure{
    //set parameter
    NSDictionary *parameters = @{@"fbid": fbid};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://s2weight.azurewebsites.net/api/GetProfileData.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *localError = nil;
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&localError];
        completed(parsedObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getWeightDataByFBid:(NSString*)fbid Completed:(CompleteHandle)completed Failure:(FailureHandle)failure{
    //set parameter
    NSDictionary *parameters = @{@"fbid": fbid};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://s2weight.azurewebsites.net/api/GetWeightDataByFBid.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *localError = nil;
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&localError];
        completed(parsedObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

+ (void)setWeight:(NSString *)fbid Weight:(NSNumber *)weight Height:(NSNumber *)height Completed:(CompleteHandle)completed Failure:(FailureHandle)failure{
    //cal bmi
    NSNumber *heightM = [NSNumber numberWithFloat:height.floatValue/100];
    NSNumber *bmi = [NSNumber numberWithFloat:(weight.floatValue/(heightM.floatValue*heightM.floatValue))];
    //get current date
    NSDateFormatter * convertDateToLocal =[[NSDateFormatter alloc]init];
    [convertDateToLocal setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [convertDateToLocal setTimeZone:[NSTimeZone localTimeZone]];
    [convertDateToLocal setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    NSString *date = [convertDateToLocal stringFromDate:[NSDate date]];
    NSLog(@"timezone : %ld", (long)[NSTimeZone localTimeZone].secondsFromGMT);
    //set parameter
    NSDictionary *parameters = @{@"fbid": fbid,
                                 @"weight":[NSString stringWithFormat:@"%0.2f", weight.floatValue],
                                 @"bmi":[NSString stringWithFormat:@"%0.2f", bmi.floatValue],
                                 @"date":date,
                                 @"timezone":[NSString stringWithFormat:@"%ld", (long)[NSTimeZone localTimeZone].secondsFromGMT]
                                 };
    NSLog(@"parameters : %@", parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://s2weight.azurewebsites.net/api/SetWeight.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *localError = nil;
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&localError];
        NSLog(@"data : %@", parsedObject);
        completed(parsedObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)editProfileDataByFBid:(NSString*)fbid Age:(NSNumber *)age Gender:(NSNumber *)gender Height:(NSNumber *)height Target:(NSNumber *)target Completed:(CompleteHandle)completed Failure:(FailureHandle)failure{
    NSDictionary *parameters = @{@"fbid":fbid,
                                 @"goal":[NSString stringWithFormat:@"%.2f", target.floatValue],
                                 @"gender":[NSString stringWithFormat:@"%d", gender.intValue],
                                 @"height":[NSString stringWithFormat:@"%d", height.intValue],
                                 @"age":[NSString stringWithFormat:@"%d", age.intValue]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://s2weight.azurewebsites.net/api/EditProfileData.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *localError = nil;
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&localError];
        //        NSLog(@"data : %@", parsedObject);
        completed(parsedObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
@end
