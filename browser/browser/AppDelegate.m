//
//  AppDelegate.m
//  Browser
//
//  Created by Admin on 26/03/2013.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Records.h"

@implementation AppDelegate

- (void)dealloc
{
    [records release];
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //БД
    [self createEditableCopyOfDatabaseIfNeeded];
    [self initializeDatabase];
    //------------
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
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
    //Закрытие БД
    [Records finalizeStatements];
    if (sqlite3_close(database) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//Метод для перемещения БД из bundle в Documents
-(void)createEditableCopyOfDatabaseIfNeeded {
    BOOL success;
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"records.sql"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"records.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(NO, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

-(void)initializeDatabase {
    // Создание массива записей
    NSMutableArray *recordsArray = [[NSMutableArray alloc] init];
    self->records = recordsArray;
    [recordsArray release];
    
    // Получаем путь к базе данных
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"records.sql"];
    
    // Открываем базу данных
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        // Запрашиваем список идентификаторов записей
        const char *sql = "SELECT id FROM records ORDER BY id ASC";
        sqlite3_stmt *statement;
        
        // Компилируем запрос в байткод перед отправкой в базу данных
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int primaryKey = sqlite3_column_int(statement, 0);
                
                Records *record = [[Records alloc] initWithIdentifier:primaryKey database:database];
                [records addObject:record];
                [record release];
            }
        }
        
        sqlite3_finalize(statement);
    } else {
        // Даже в случае ошибки открытия базы закрываем ее для корректного освобождения памяти
        sqlite3_close(database);
        NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
}

@end
