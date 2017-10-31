//
//  RunInfo+CoreDataProperties.h
//  PKU
//
//  Created by ironfive on 17/9/20.
//  Copyright © 2017年 ironfive. All rights reserved.
//

#import "RunInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RunInfo (CoreDataProperties)

+ (NSFetchRequest<RunInfo *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *array;
@property (nullable, nonatomic, copy) NSNumber *distance;
@property (nullable, nonatomic, copy) NSNumber *endtime;
@property (nullable, nonatomic, copy) NSNumber *index;
@property (nullable, nonatomic, copy) NSNumber *isver;
@property (nullable, nonatomic, copy) NSNumber *speed;
@property (nullable, nonatomic, copy) NSNumber *time;
@property (nullable, nonatomic, retain) NSData *tureline;
@property (nullable, nonatomic, copy) NSString *userid;
@property (nullable, nonatomic, copy) NSString *photoFilename;
@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, copy) NSNumber *restart;
@property (nullable, nonatomic, copy) NSNumber *step;

@end

NS_ASSUME_NONNULL_END
