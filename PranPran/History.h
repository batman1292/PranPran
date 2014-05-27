//
//  History.h
//  PranPran
//
//  Created by Kanitkon on 5/22/14.
//  Copyright (c) 2014 BVH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface History : NSManagedObject

@property (nonatomic, retain) NSNumber * bmi;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSDate * date;

@end
