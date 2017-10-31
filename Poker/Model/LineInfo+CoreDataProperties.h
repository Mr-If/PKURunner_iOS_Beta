//
//  LineInfo+CoreDataProperties.h
//  PKU
//
//  Created by ironfive on 17/9/20.
//  Copyright © 2017年 ironfive. All rights reserved.
//

#import "LineInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LineInfo (CoreDataProperties)

+ (NSFetchRequest<LineInfo *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, copy) NSNumber *index;
@property (nullable, nonatomic, copy) NSNumber *restart;
@property (nullable, nonatomic, copy) NSString *userid;

@end

NS_ASSUME_NONNULL_END
