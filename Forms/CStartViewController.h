//
//  CStartViewController.h
//  Forms
//
//  Created by Jose Vildosola on 02-09-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAppDelegate.h"

@interface CStartViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) NSString *documentPath;
@property (strong, nonatomic) CAppDelegate *app;
@end
