//
//  COutboxViewController.h
//  Forms
//
//  Created by Jose Vildosola on 02-09-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COutboxViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *mOutboxArray;
@property (nonatomic, strong) NSXMLParser *parser;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
- (IBAction)sincronizar:(id)sender;

@end
