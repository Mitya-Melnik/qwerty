//
//  Context.h
//  Prototype
//
//  Created by Петрова Варвара on 22.04.13.
//  Copyright (c) 2013 Петрова Варвара. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Records.h"

@interface Context : NSObject{
    sqlite3 *database;
    NSInteger *userID;
    NSMutableArray *tabList;
}

@property (assign, nonatomic) NSInteger *userID;
@property(nonatomic,retain) NSMutableArray *tabList;

-(id)init;
-(void) addRecordInArray:(Records *) newRecord;
-(void) deleteRecordFromArray:(int) recordID;
-(void) deleteAllRecordsFromArray;
-(void) readRecordOfDataBase;
-(void) insertIntoDataBase:(Records *)newRecord;
+(void)finalizeStatements;

@end
