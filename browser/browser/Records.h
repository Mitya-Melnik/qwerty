//
//  Records.h
//  Prototype
//
//  Created by Петрова Варвара on 11.04.13.
//  Copyright (c) 2013 Петрова Варвара. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface Records : NSObject{
    sqlite3 *database;
    NSInteger primaryKey;
    NSString *url;
    NSString *user;
  
}
@property (assign, nonatomic, readonly) NSInteger primaryKey;//readonly
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *user;

+(void)finalizeStatements;

-(id)initWithIdentifier:(NSInteger)idKey database:(sqlite3 *)db;
-(void)readRecord;
-(void)updateRecord;
-(void)insertIntoDatabase:(sqlite3 *)db;
-(void)deleteRecord;
@end

