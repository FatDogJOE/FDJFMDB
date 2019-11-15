//
//  FDJAppDelegate.m
//  FDJFMDB
//
//  Created by likethephoenix@163.com on 11/06/2019.
//  Copyright (c) 2019 likethephoenix@163.com. All rights reserved.
//

#import "FDJAppDelegate.h"
#import "FDJFMDB.h"
#import "People.h"

@implementation FDJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString * documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * dbPath = [documents stringByAppendingPathComponent:@"dataBase.db"];
    
    FDJDatabaseConfig * config = [[FDJDatabaseConfig alloc] init];
    config.version = 1;
    config.path = dbPath;
    [FDJDatabase setupWithConfig:config];
    
    [[FDJDatabase db] registerTables:@[People.class]];
    
    [self performance];
    
    return YES;
}

- (void)performance {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray * array = [NSMutableArray array];

        for (NSInteger i = 0; i < 50000; i++) {

            People * people = [[People alloc] init];
            people.name = FDJ_STR(@"People%@",@(i));
            people.age = i;
            people.male = (i % 2) == 0;
            people.money = 1321.03;
            people.date = [[NSDate date] dateByAddingTimeInterval:i * 3600];

            [array addObject:people];
        }
        NSTimeInterval b1 = [[NSDate date] timeIntervalSince1970];
        BOOL success1 = [People insertOrUpdate:array];
        NSTimeInterval e1 = [[NSDate date] timeIntervalSince1970];

        NSTimeInterval delta1 = e1 - b1;
        NSLog(@"插入数据耗时%f", delta1);
        
//        NSTimeInterval b2 = [[NSDate date] timeIntervalSince1970];
//        NSArray * result = [People queryWhere:@"date > '2020-11-20 14:00:00' AND date < '2020-11-21'"];
//        NSTimeInterval e2 = [[NSDate date] timeIntervalSince1970];
//
//        NSTimeInterval delta2 = e2 - b2;
//        NSLog(@"查找耗时:%f", delta2);
//
//        NSTimeInterval b3 = [[NSDate date] timeIntervalSince1970];
//        BOOL success2 = [People updateWithDic:@{@"name":@"People0",@"age":@400}];
//        NSTimeInterval e3 = [[NSDate date] timeIntervalSince1970];
//
//        NSTimeInterval delta3 = e3 - b3;
//        NSLog(@"更新耗时:%f", delta3);
//
//        NSTimeInterval b4 = [[NSDate date] timeIntervalSince1970];
//        BOOL success3 = [People insertOrUpdateWithDic:@{@"name":@"People1",@"age":@300}];
//        NSTimeInterval e4 = [[NSDate date] timeIntervalSince1970];
//
//        NSTimeInterval delta4 = e4 - b4;
//        NSLog(@"插入或更新耗时：%f", delta4);
        
    });
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
