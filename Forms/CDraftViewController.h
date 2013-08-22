//
//  CDraftViewController.h
//  Forms
//
//  Created by Jose Vildosola on 20-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDraftViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mDraftTableView;
@property (strong, nonatomic) NSMutableArray *mDraftArray;
@property (strong, nonatomic) NSMutableDictionary *mDraftDict;

@end
