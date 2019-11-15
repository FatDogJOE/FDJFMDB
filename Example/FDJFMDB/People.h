//
//  People.h
//  FDJFMDB_Example
//
//  Created by mac on 2019/11/8.
//  Copyright © 2019 likethephoenix@163.com. All rights reserved.
//

#import "FDJDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface People : FDJDataModel

@property (nonatomic, copy)     NSString * name;
@property (nonatomic, assign)   NSInteger age;
@property (nonatomic, assign)   BOOL male;
@property (nonatomic, assign)   double money;
@property (nonatomic, strong)   NSDate * date;


@end

NS_ASSUME_NONNULL_END
