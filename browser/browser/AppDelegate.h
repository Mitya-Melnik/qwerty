//
//  AppDelegate.h
//  Browser
//
//  Created by Admin on 26/03/2013.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    sqlite3 *database;// дескриптор базы, полученной при открытии
    NSMutableArray *records;//записи из базы
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;


-(void)createEditableCopyOfDatabaseIfNeeded;//bundle->documents
-(void)initializeDatabase;//открытие бд и инициализация начальных значений

@end
