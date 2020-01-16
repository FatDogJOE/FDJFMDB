//
//  FDJColume.h
//  FDJFMDB_Example
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 likethephoenix@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDJSQL.h"
#import "FDJDatabaseDefines.h"


typedef NS_ENUM(NSUInteger, FDJDataType) {
    FDJDataTypeText,
    FDJDataTypeInteger,
    FDJDataTypeNumeric,
    FDJDataTypeReal,
    FDJDataTypeDate
};

extern NSString * _Nonnull const ColumeConstraintNotNull;
extern NSString * _Nonnull const ColumeConstraintDefault;
extern NSString * _Nonnull const ColumeConstraintUnique;
extern NSString * _Nonnull const ColumeConstraintPrimaryKey;
extern NSString * _Nonnull const ColumeConstraintCheck;

NS_ASSUME_NONNULL_BEGIN

#define fdj_colume(p1,p2,p3)\
({\
NSSet * set = [NSSet setWithArray:(p2 ? : @[])];\
FDJColume * colume = [FDJColume columeWithName:p1 constraints:set dataType:p3];\
(colume);\
})

@interface FDJColume : NSObject<FDJSQL>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSSet * constraints;
@property (nonatomic, assign) FDJDataType dataType;

- (NSString *)dataTypeString;

- (BOOL)haveConstraint:(NSString *)constraint;

+ (instancetype)columeWithName:(NSString *)name constraints:(NSSet<NSString *> *)constraints dataType:(FDJDataType)dataType;
+ (instancetype)columeWithName:(NSString *)name constraintsArr:(NSArray<NSString *> *)constraints dataType:(FDJDataType)dataType;
@end

NS_ASSUME_NONNULL_END
