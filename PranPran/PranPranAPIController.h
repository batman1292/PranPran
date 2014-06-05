//
//  PranPranAPIController.h
//  PranPran
//
//  Created by Kanitkon on 5/26/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PranPranAPIController : NSObject

typedef void (^CompleteHandle)(id object);
typedef void (^FailureHandle)(NSError *error);

+ (void)checkUserByFBid:(NSString*)fbid Completed:(CompleteHandle)completed Failure:(FailureHandle)failure;

+ (void)addProfileIntoDB:(NSString*)fbid name:(NSString*)inputname age:(NSNumber *)inputAge gender:(NSNumber *)inputGender height:(NSNumber *)inputHeight weight:(NSNumber*)inputWeight goal:(NSNumber*)inputGoal Completed:(CompleteHandle)completed Failure:(FailureHandle)failure;

+ (void)getDataByFBid:(NSString*)fbid Completed:(CompleteHandle)completed Failure:(FailureHandle)failure;

+ (void)getWeightDataByFBid:(NSString*)fbid Completed:(CompleteHandle)completed Failure:(FailureHandle)failure;

+ (void)setWeight:(NSString *)fbid Weight:(NSNumber *)weight Height:(NSNumber *)height Completed:(CompleteHandle)completed Failure:(FailureHandle)failure;

+ (void)editProfileDataByFBid:(NSString*)fbid Age:(NSNumber *)age Gender:(NSNumber *)gender Height:(NSNumber *)height Target:(NSNumber *)target Completed:(CompleteHandle)completed Failure:(FailureHandle)failure;

@end
