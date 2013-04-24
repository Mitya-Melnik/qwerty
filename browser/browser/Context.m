//
//  Context.m
//  Prototype
//
//  Created by Петрова Варвара on 22.04.13.
//  Copyright (c) 2013 Петрова Варвара. All rights reserved.
//

#import "Context.h"

@implementation Context

@synthesize userID;
@synthesize tabList;

-(id)init{
    
    //Создаем массив записей
    NSMutableArray *recordsArray = [[NSMutableArray alloc]init];
    self.tabList = recordsArray;
    [recordsArray release];
    
    //Получаем путь к базе данных
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"records.sql"];
    
    //Открываем базу данных
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        
        // Запрашиваем список идентификаторов записей
        const char *sql = "SELECT id FROM records ORDER BY id ASC";
        sqlite3_stmt *statement;
        
        //Копирунм запрос в байткод перед отправкой в базу данных
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            int primaryKey;
            while (sqlite3_step(statement) == SQLITE_ROW) {
                primaryKey= sqlite3_column_int(statement, 0);
                Records *record = [[Records alloc] initWithIdentifier:primaryKey database:database];
                [tabList addObject:record];
                [record release];
            }
        }
        
        sqlite3_finalize(statement);
    } else {
        // Даже в случае ошибки открытия базы закрываем ее для корректного освобождения памяти
        sqlite3_close(database);
        NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
      }
    return self;
}

+(void)finalizeStatements {
    if (init_statement) sqlite3_finalize(init_statement);
    if (read_statement) sqlite3_finalize(read_statement);
    if (update_statement) sqlite3_finalize(update_statement);
    if (insert_statement) sqlite3_finalize(insert_statement);
}

-(void) addRecordInArray:(Records *) newRecord{
    [tabList addObject:newRecord];
    [newRecord release];
}

-(void) deleteRecordFromArray:(int) recordID{
    int n = [tabList count];
    int counter = 0;
    Records *record;
    while(counter !=n){
        record = [tabList objectAtIndex:(int)counter];
        if(record.primaryKey == recordID){
            [tabList removeObjectAtIndex:(int) counter];
            break;
        }
        counter++;
    }
        [record release];
}

-(void) deleteAllRecordsFromArray{
    [tabList removeAllObjects];
}

-(void) readRecordOfDataBase{
    if (read_statement == nil) {
        const char *sql = "SELECT txt FROM records WHERE id=?";
        if (sqlite3_prepare_v2(database, sql, -1, &read_statement, NULL) != SQLITE_OK) {
            NSAssert1(NO, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
    Records *record = nil;
    sqlite3_bind_int(read_statement, 1, record.primaryKey);
    
    
    if (sqlite3_step(read_statement) == SQLITE_ROW) {
        record.userID =  sqlite3_column_int(read_statement,0);
    } else {
        record.userID = -1;
    }
    sqlite3_reset(read_statement);
    [tabList addObject:record];
    [record release];
}

-(void) insertIntoDataBase:(Records *) newRecord{
        // Если пользователь ничего не ввел, то запись в базу не производится
        if ((newRecord.url == nil) || (newRecord.url.length == 0)) return;
        
        if (insert_statement == nil) {
            const char *sql = "INSERT INTO records(userID, url) VALUES(?, ?)";
            if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
                NSAssert1(NO, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
        sqlite3_bind_int(insert_statement, 1, newRecord.userID);
        sqlite3_bind_text(insert_statement, 2, [newRecord.url UTF8String], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(insert_statement) == SQLITE_DONE) {
            newRecord.primaryKey = sqlite3_last_insert_rowid(database);
        } else {
            NSAssert1(NO, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
        }
        
        sqlite3_reset(insert_statement);
        
        newRecord.url = nil;
    }


@end
