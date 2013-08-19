//
//  CNuevoViewController.h
//  Forms
//
//  Created by Jose Vildosola on 12-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHttpDownload.h"

@interface CNuevoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, HttpDownloadDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mNuevoTableView;
@property (strong, nonatomic) NSMutableArray *mNuevoArray;
@property (nonatomic, strong) CHttpDownload *httpManager;


@end
