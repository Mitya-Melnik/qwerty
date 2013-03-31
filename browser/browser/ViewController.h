//
//  ViewController.h
//  Browser
//
//  Created by Admin on 26/03/2013.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *url;
@property (retain, nonatomic) IBOutlet UIWebView *webPage;
- (IBAction)pushGo:(id)sender;
@end
