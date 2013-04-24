//
//  Records.m
//  Prototype
//
//  Created by Петрова Варвара on 11.04.13.
//  Copyright (c) 2013 Петрова Варвара. All rights reserved.
//

#import "Records.h"

@implementation Records
//#define USER_LENGTH 50
@synthesize url;
//@synthesize user;
@synthesize primaryKey;
@synthesize userID;


 

-(id)initWithIdentifier:(NSInteger)idKey database:(sqlite3 *)db {
    if (self = [super init]) {
        //database = db;
        primaryKey = idKey;
        
        // Инициализуем переменную init_statement при первом вызоме метода
        if (init_statement == nil) {
            // Подготавливаем запрос перед отправкой в базу данных
            const char *sql = "SELECT user FROM records WHERE id=?";
            if (sqlite3_prepare_v2(db, sql, -1, &init_statement, NULL) != SQLITE_OK) {
                NSAssert1(NO, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
            }
        }
        
        // Подставляем значение в запрос
        sqlite3_bind_int(init_statement, 1, self.primaryKey);
        
        // Получаем результаты выборки
        if (sqlite3_step(init_statement) == SQLITE_ROW) {
            self.url = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 0)];
        } else {
            self.url = @"";
        }
        
        // Сбрасываем подготовленное выражение для повторного использования
        sqlite3_reset(init_statement);
    }
    return self;
}


/*// Метод класса
+(void)finalizeStatements {
        if (init_statement) sqlite3_finalize(init_statement);
        if (read_statement) sqlite3_finalize(read_statement);
        if (update_statement) sqlite3_finalize(update_statement);
        if (insert_statement) sqlite3_finalize(insert_statement);
    }

-(void)readRecord {
    if (read_statement == nil) {
        const char *sql = "SELECT url FROM records WHERE id=?";
        if (sqlite3_prepare_v2(database, sql, -1, &read_statement, NULL) != SQLITE_OK) {
            NSAssert1(NO, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
    
    sqlite3_bind_int(read_statement, 1, self.primaryKey);
    
    if (sqlite3_step(read_statement) == SQLITE_ROW) {
        self.url = [NSString stringWithUTF8String:(char *)sqlite3_column_text(read_statement, 0)];
    } else {
        self.url = @"";
    }
    
    sqlite3_reset(read_statement);
}

-(void)updateRecord {
    // Если обновление уже проходило — выходим
    if (self.url == nil) return;
    
    if (update_statement == nil) {
        const char *sql = "UPDATE records SET user=?, url=? WHERE id=?";
        if (sqlite3_prepare_v2(database, sql, -1, &update_statement, NULL) != SQLITE_OK) {
            NSAssert1(NO, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
    
    NSUInteger lenToCut = (url.length < USER_LENGTH) ? url.length : USER_LENGTH;
    self.user = [url substringToIndex:lenToCut];
    
    sqlite3_bind_text(update_statement, 1, [user UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(update_statement, 2, [url UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(update_statement, 3, self.primaryKey);
    
    if (sqlite3_step(update_statement) != SQLITE_DONE) {
        NSAssert1(NO, @"Error: failed to update with message '%s'.", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(update_statement);
    
    self.url = nil;
}
-(void)insertIntoDatabase:(sqlite3 *)db {
    database = db;
    
    // Если пользователь ничего не ввел, то запись в базу не производится
    if ((self.url == nil) || (url.length == 0)) return;
    
    if (insert_statement == nil) {
        const char *sql = "INSERT INTO records(user, url) VALUES(?, ?)";
        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
            NSAssert1(NO, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
    
    NSUInteger lenToCut = (url.length < USER_LENGTH) ? url.length : USER_LENGTH;
    self.user = [url substringToIndex:lenToCut];
    
    sqlite3_bind_text(insert_statement, 1, [user UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement, 2, [url UTF8String], -1, SQLITE_TRANSIENT);
    
    if (sqlite3_step(insert_statement) == SQLITE_DONE) {
        primaryKey = sqlite3_last_insert_rowid(database);
    } else {
        NSAssert1(NO, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(insert_statement);
    
    self.url = nil;
}
*/

@end
