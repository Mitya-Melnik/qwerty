//
//  ViewController.m
//  Browser
//
// Created by Admin on 26/03/2013.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController;
@synthesize url;
@synthesize webPage;

- (void)viewDidLoad
{
    self.webPage.scalesPageToFit = YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [url release];
    [webPage release];
    [super dealloc];
}

- (IBAction)pushGo:(id)sender {
    NSURL *U =[NSURL URLWithString:url.text];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:U];
    [webPage loadRequest:requestObj];
}

@end
