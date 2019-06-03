//
//  QYFMDBTest.m
//  MHRefresh
//
//  Created by panle on 2019/4/23.
//  Copyright © 2019 developer. All rights reserved.
//

#import "QYFMDBTest.h"

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

static FMDatabaseQueue *dataSerialQueue () {
    static dispatch_once_t onceToken;
    static FMDatabaseQueue *databaseQueue = nil;
    dispatch_once(&onceToken, ^ {
        NSString *dataBasePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName = [dataBasePath stringByAppendingPathComponent:@"West.sqlite"];
        [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
        databaseQueue = [FMDatabaseQueue databaseQueueWithPath:fileName];
    });
    return databaseQueue;
}

static dispatch_queue_t mDatabaseConcurrentQueue() {
    static dispatch_queue_t mDatabaseConcurrentQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mDatabaseConcurrentQueue = dispatch_queue_create("com.bluelive.test.database", DISPATCH_QUEUE_CONCURRENT);
    });
    return mDatabaseConcurrentQueue;
}


@implementation QYFMDBTest

+ (void)start
{
    [dataSerialQueue() inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
       
        //唯一联合性测试
        
        //创建表
        NSString *sqlString1 = @"CREATE TABLE IF NOT EXISTS t_section1(id INTEGER PRIMARY KEY AUTOINCREMENT, card_uuid CHAR(5), section_uuid CHAR(5) default '11111', course_uuid CHAR(1), package_uuid CHAR(1), rank INTEGER, UNIQUE(card_uuid, section_uuid, course_uuid, package_uuid))";
        
        NSString *sqlString2 = @"CREATE TABLE IF NOT EXISTS t_section2(card_uuid CHAR(5) PRIMARY KEY UNIQUE, status INTEGER)";
        NSString *sqlString3 = @"CREATE TABLE IF NOT EXISTS t_section3(card_uuid CHAR(5) PRIMARY KEY UNIQUE, title TEXT)";
        
        [db executeUpdate:sqlString1];
        [db executeUpdate:sqlString2];
        [db executeUpdate:sqlString3];
        
        for (NSInteger i = 0; i < 3; i ++) {
            NSString *insrt1 = @"INSERT INTO t_section1(section_uuid, course_uuid, package_uuid, card_uuid, rank) VALUES (?, ?, ?, ?, ?)";
            [db executeUpdate:insrt1, @"<null>", @"1", @"1", @"1", @(i)];
        }
        
//        for (NSInteger i = 0; i < 3; i ++) {
//            NSString *insrt1 = @"INSERT INTO t_section1(section_uuid, course_uuid, package_uuid, card_uuid, rank) VALUES (?, ?, ?, ?, ?)";
//            [db executeUpdate:insrt1, @(i).stringValue, @(i).stringValue, @"1", @"2", @(i)];
//        }
//
//        for (NSInteger i = 0; i < 3; i ++) {
//            NSString *insrt1 = @"INSERT INTO t_section1(section_uuid, course_uuid, package_uuid, card_uuid, rank) VALUES (?, ?, ?, ?, ?)";
//            [db executeUpdate:insrt1, @(i).stringValue, @(i).stringValue, @"1", @"3", @(i)];
//        }
//
//        NSString *insrt1 = @"INSERT INTO t_section1(section_uuid, course_uuid, package_uuid, card_uuid, rank) VALUES (?, ?, ?, ?, ?)";
//        [db executeUpdate:insrt1, nil, @(3).stringValue, @"1", @"3", @(2)];
//        [db executeUpdate:insrt1, nil, @(3).stringValue, @"1", @"4", @(2)];
//        BOOL success1 = [db executeUpdate:insrt1, nil, @(3).stringValue, @"1", @"4", @(2)];
//
//        if (!success1) {
//            NSLog(@"插入数据失败");
//        } else {
//            NSLog(@"插入数据成功");
//        }
//
//        for (NSInteger i = 0; i < 1; i ++) {
//            NSString *insrt1 = @"INSERT INTO t_section2(card_uuid, status) VALUES (?, ?)";
//            [db executeUpdate:insrt1, @"1", @(i).stringValue];
//        }
//
//        for (NSInteger i = 0; i < 1; i ++) {
//            NSString *insrt1 = @"INSERT INTO t_section2(card_uuid, status) VALUES (?, ?)";
//            [db executeUpdate:insrt1, @"2", @(i).stringValue];
//        }
//
//        for (NSInteger i = 0; i < 1; i ++) {
//            NSString *insrt1 = @"INSERT INTO t_section2(card_uuid, status) VALUES (?, ?)";
//            [db executeUpdate:insrt1, @"3", @(3).stringValue];
//        }
//
//
//
//        for (NSInteger i = 0; i < 1; i ++) {
//            NSString *insrt1 = @"INSERT INTO t_section3(card_uuid, title) VALUES (?, ?)";
//            [db executeUpdate:insrt1, @"1", @(i).stringValue];
//        }
//
//        for (NSInteger i = 0; i < 1; i ++) {
//            NSString *insrt1 = @"INSERT INTO t_section3(card_uuid, title) VALUES (?, ?)";
//            [db executeUpdate:insrt1, @"2", @(i).stringValue];
//        }
//
//        for (NSInteger i = 0; i < 1; i ++) {
//            NSString *insrt1 = @"INSERT INTO t_section3(card_uuid, title) VALUES (?, ?)";
//            [db executeUpdate:insrt1, @"3", @(i).stringValue];
//        }
//
////    SELECT t_card.finish_period, t_card.finish_at, t_card.card_status, t_card.title, t_card.card_period, t_card.inversion_period, t_package.name FROM t_card INNER JOIN t_package ON t_card.package_uuid = t_package.package_uuid WHERE t_package.status = '%ld' AND ignore = '0' AND (t_card.card_status = '%ld' OR t_card.card_status = '%ld') ORDER BY t_card.review_sequence DESC", PackageLearning, CardStatusLearning, CardStatusActive
//
//        NSString *sql1 = @"SELECT t_section1.*, t_section2.*, t_section3.* FROM t_section1 INNER JOIN t_section2 ON t_section1.card_uuid = t_section2.card_uuid INNER JOIN t_section3 ON t_section1.card_uuid = t_section3.card_uuid group by t_section1.card_uuid order by rank desc";
//
//        FMResultSet *set = [db executeQuery:sql1];
//        while ([set next]) {
//            NSLog(@"%@ %@ %@ %@", [set stringForColumn:@"card_uuid"], [set stringForColumn:@"section_uuid"], @([set longForColumn:@"status"]), @([set longForColumn:@"rank"]));
//        }
//
//        NSLog(@"---------------------");
//
//        NSString *sql2 = @"SELECT t_section1.*, t_section2.*, t_section3.* FROM t_section1 INNER JOIN t_section2 ON t_section1.card_uuid = t_section2.card_uuid INNER JOIN t_section3 ON t_section1.card_uuid = t_section3.card_uuid ";
//
//        FMResultSet *set2 = [db executeQuery:sql2];
//        while ([set2 next]) {
//            NSLog(@"%@ %@ %@ %@ ", [set2 stringForColumn:@"card_uuid"], [set2 stringForColumn:@"section_uuid"], @([set2 longForColumn:@"status"]), @([set2 longForColumn:@"rank"]));
//        }
        
        NSString *sql3 = @"SELECT * FROM t_section1";
        FMResultSet *set3 = [db executeQuery:sql3];
        while ([set3 next]) {
            NSLog(@"%@ %@", [set3 stringForColumn:@"card_uuid"], [set3 stringForColumn:@"section_uuid"]);
        }
        
//        FMResultSet *search1 = [SELECT * FROM t_section];
//
//        while ([set next]) {
//
//        }
        
    }];
}

@end
