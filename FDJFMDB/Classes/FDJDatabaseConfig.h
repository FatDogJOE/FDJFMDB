//
//  FDJDatabaseConfig.h
//  FDJFMDB_Example
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 likethephoenix@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDJDatabaseConfig : NSObject

@property (nonatomic, strong) NSString * path;
@property (nonatomic, assign) NSInteger version;

@end

NS_ASSUME_NONNULL_END
