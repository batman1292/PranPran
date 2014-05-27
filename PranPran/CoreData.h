//
//  CoreData.h
//  PranPran
//
//  Created by Kanitkon on 5/22/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "History.h"
#import "Profile.h"

@interface CoreData : NSObject

+ (id)sharedCoredata;
- (void)initCoreData;

- (BOOL)checkProfileData;
- (void)addProfile:(NSString *)inputName age:(NSNumber *)inputAge gender:(NSNumber *)inputGender height:(NSNumber *)inputHeight weight:(NSNumber*)inputWeight goal:(NSNumber*)inputGoal;
- (void)editProfile:(NSString *)inputName age:(NSNumber *)inputAge gender:(NSNumber *)inputGender height:(NSNumber *)inputHeight;
- (NSDictionary *)getProfile;
- (NSString *)getProfileName;
- (NSNumber *)getProfileHeight;

- (NSDictionary *)getLastHistory;
- (NSNumber *)getLastHistoryWeight;
- (NSNumber *)getLastHistoryBMI;

- (NSString *)getTerndWeight;
- (NSString *)getTerndBMI;

- (void)setWeightFormProfile:(NSNumber *)inputWeight height:(NSNumber *)inputHeight;
- (void)setWeightFromInput:(NSNumber *)inputWeight date:(NSDate *)inputDate;
- (void)setWeightFromBluetooth:(NSNumber *)inputWeight;
- (void)setWeight:(NSNumber *)inputWeight;
@end
