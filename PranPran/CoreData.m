//
//  CoreData.m
//  PranPran
//
//  Created by Kanitkon on 5/22/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import "CoreData.h"

@interface CoreData()
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;
@end

@implementation CoreData

+ (id)sharedCoredata {
    static dispatch_once_t once;
    static CoreData *coredata;
    dispatch_once(&once, ^ {
        coredata = [[CoreData alloc] init];
        [coredata initCoreData];
    });
    return coredata;
}

- (NSString *)applicationDocumentsDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void) initCoreData{
    NSURL *modeURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    
    if (modeURL == nil) {
        NSLog(@"Fail url");
    }
    
    //Model
    self.model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modeURL];
    //Coordinate
    NSPersistentStoreCoordinator *psc = nil;
    psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"database.sqlite"]];
    NSError *error = nil;
    NSPersistentStore *store = nil;
    
    // Store
    store = [psc addPersistentStoreWithType:NSSQLiteStoreType
                              configuration:nil
                                        URL:storeURL
                                    options:nil
                                      error:&error];
    
    NSManagedObjectContextConcurrencyType ccType = NSMainQueueConcurrencyType;
    
    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:ccType];
    [self.context setPersistentStoreCoordinator:psc];
}

- (BOOL)checkProfileData{
    BOOL result = NO;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Profile"];
    NSArray *dataProfile = [self.context executeFetchRequest:request error:nil];
    for (Profile *profileTemp in dataProfile){
        if (profileTemp.name != nil) {
            result = YES;
        }
    }
    return result;
}

- (void)addProfile:(NSString *)inputName age:(NSNumber *)inputAge gender:(NSNumber *)inputGender height:(NSNumber *)inputHeight weight:(NSNumber*)inputWeight goal:(NSNumber*)inputGoal{
    NSEntityDescription *profileEntity = [[self.model entitiesByName] objectForKey:@"Profile"];
    Profile *profile = (Profile *)[[NSManagedObject alloc] initWithEntity:profileEntity insertIntoManagedObjectContext:self.context];
    profile.name = inputName;
    profile.age = inputAge;
    profile.gender = inputGender;
    profile.height = inputHeight;
    profile.weight = inputWeight;
    profile.goal = inputGoal;
    
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)editProfile:(NSString *)inputName age:(NSNumber *)inputAge gender:(NSNumber *)inputGender height:(NSNumber *)inputHeight{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Profile"];
    NSArray *dataProfiles = [self.context executeFetchRequest:request error:nil];
    Profile *dataProfile = [dataProfiles objectAtIndex:dataProfiles.count-1];
    dataProfile.name = inputName;
    dataProfile.age = inputAge;
    dataProfile.gender = inputGender;
    dataProfile.height = inputHeight;
    
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    
}
#pragma mark - getting
- (NSDictionary *)getProfile{
    NSDictionary *result = [[NSDictionary alloc] init];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Profile"];
    NSArray *dataProfile = [self.context executeFetchRequest:request error:nil];
    for (Profile *profileTemp in dataProfile){
        result = @{@"name":profileTemp.name, @"age":profileTemp.age, @"gender":profileTemp.gender, @"height":profileTemp.height, @"weight":profileTemp.weight, @"goal":profileTemp.goal};
    }
    return result;
}

- (NSString *)getProfileName{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Profile"];
    NSArray *dataProfile = [self.context executeFetchRequest:request error:nil];
    Profile *result = [dataProfile objectAtIndex:dataProfile.count-1];
    return result.name;
}

- (NSNumber *)getProfileHeight{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Profile"];
    NSArray *dataProfile = [self.context executeFetchRequest:request error:nil];
    Profile *result = [dataProfile objectAtIndex:dataProfile.count-1];
//    result.height = [NSNumber numberWithFloat:result.height.floatValue/100];
    return result.height;
}

- (NSDictionary *)getLastHistory{
    NSDictionary *result = [[NSDictionary alloc] init];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    NSArray *dataHistorys = [self.context executeFetchRequest:request error:nil];
    History *dataHistory = [dataHistorys objectAtIndex:dataHistorys.count-1];
    result = @{@"bmi":dataHistory.bmi, @"weight":dataHistory.weight, @"date":dataHistory.date};
    return result;
}

- (NSNumber *)getLastHistoryWeight{
    return [[self getLastHistory] objectForKey:@"weight"];
}

- (NSNumber *)getLastHistoryBMI{
    return [[self getLastHistory] objectForKey:@"bmi"];
}

- (NSString *)getTerndWeight{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    NSArray *dataHistorys = [self.context executeFetchRequest:request error:nil];
    if (dataHistorys.count > 1) {
        History *dataHistoryLast = [dataHistorys objectAtIndex:dataHistorys.count-1];
        History *dataHistoryBeforeLast = [dataHistorys objectAtIndex:dataHistorys.count-2];
        float change = (dataHistoryLast.weight.floatValue - dataHistoryBeforeLast.weight.floatValue);
        float perChange = change*100/dataHistoryLast.weight.floatValue;
        return [NSString stringWithFormat:@"change %.1f , perChange %.2f ", change, perChange];
    }else{
        return @"not enough data";
    }
}
- (NSString *)getTerndBMI{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    NSArray *dataHistorys = [self.context executeFetchRequest:request error:nil];
    if (dataHistorys.count > 1) {
        History *dataHistoryLast = [dataHistorys objectAtIndex:dataHistorys.count-1];
        History *dataHistoryBeforeLast = [dataHistorys objectAtIndex:dataHistorys.count-2];
        float change = (dataHistoryLast.bmi.floatValue - dataHistoryBeforeLast.bmi.floatValue);
        float perChange = change*100/dataHistoryLast.bmi.floatValue;
        return [NSString stringWithFormat:@"change %.1f , perChange %.2f ", change, perChange];

    }else{
        return @"not enough data";
    }
}

#pragma mark - setting
- (NSNumber *)calBMI:(NSNumber *)inputWeight height:(NSNumber *)inputHeight{
    float height2 = (inputHeight.floatValue*inputHeight.floatValue);
    return [NSNumber numberWithFloat:(inputWeight.floatValue/height2)];
}

- (NSDate *)convertDate:(NSDate *)inputDate{
    NSDateFormatter * convertDateToLocal =[[NSDateFormatter alloc]init];
    [convertDateToLocal setDateFormat:@"dd-MM-yyyy HH:mm"];
    [convertDateToLocal setTimeZone:[NSTimeZone localTimeZone]];
    [convertDateToLocal setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    return [convertDateToLocal dateFromString:[convertDateToLocal stringFromDate:inputDate]];
}

- (void)setWeightFormProfile:(NSNumber *)inputWeight height:(NSNumber *)inputHeight{
    NSEntityDescription *historyEntity = [[self.model entitiesByName] objectForKey:@"History"];
    History *history = (History *)[[NSManagedObject alloc] initWithEntity:historyEntity insertIntoManagedObjectContext:self.context];
    history.weight = inputWeight;
    history.bmi = [self calBMI:inputWeight height:inputHeight];
    history.date = [self convertDate:[NSDate date]];
    
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)setWeightFromInput:(NSNumber *)inputWeight date:(NSDate *)inputDate{
    NSEntityDescription *historyEntity = [[self.model entitiesByName] objectForKey:@"History"];
    History *history = (History *)[[NSManagedObject alloc] initWithEntity:historyEntity insertIntoManagedObjectContext:self.context];
    history.weight = inputWeight;
    history.bmi = [self calBMI:inputWeight height:[self getProfileHeight]];
    history.date = [self convertDate:inputDate];
    
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

}

- (void)setWeightFromBluetooth:(NSNumber *)inputWeight{
    NSEntityDescription *historyEntity = [[self.model entitiesByName] objectForKey:@"History"];
    History *history = (History *)[[NSManagedObject alloc] initWithEntity:historyEntity insertIntoManagedObjectContext:self.context];
    history.weight = inputWeight;
    history.bmi = [self calBMI:inputWeight height:[self getProfileHeight]];
    history.date = [self convertDate:[NSDate date]];
    
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)setWeight:(NSNumber *)inputWeight{
    NSEntityDescription *historyEntity = [[self.model entitiesByName] objectForKey:@"History"];
    History *history = (History *)[[NSManagedObject alloc] initWithEntity:historyEntity insertIntoManagedObjectContext:self.context];
    history.weight = inputWeight;
    history.bmi = [self calBMI:inputWeight height:[NSNumber numberWithFloat:[self getProfileHeight].floatValue/100]];
    history.date = [self convertDate:[NSDate date]];
    
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

@end
