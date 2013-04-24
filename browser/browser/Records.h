//
//  Records.h
//  Prototype
//
//  Created by Петрова Варвара on 11.04.13.
//  Copyright (c) 2013 Петрова Варвара. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

static sqlite3_stmt *init_statement;
static sqlite3_stmt *read_statement;
static sqlite3_stmt *update_statement;
static sqlite3_stmt *insert_statement;

@interface Records : NSObject{
    NSInteger userID;
    NSString *url;
    NSInteger primaryKey;
   
  
}
@property (assign, nonatomic) NSInteger userID;
@property (copy, nonatomic) NSString *url;
@property (assign,nonatomic) NSInteger primaryKey;

-(id)initWithIdentifier:(NSInteger)idKey database:(sqlite3 *)db;

@end

