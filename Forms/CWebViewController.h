//
//  CWebViewController.h
//  Forms
//
//  Created by Jose Vildosola on 19-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//
@protocol CWebNotificationDelegate;

#import <UIKit/UIKit.h>
#import "CFormModel.h"

@interface CWebViewController : UIViewController<UIWebViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) CFormModel *model;
@property (assign, nonatomic) id<CWebNotificationDelegate> delegate;

-(void) setHtmlFile:(NSString *)html;
-(void) setFormName:(NSString *)formName;
-(void) setFormModel:(CFormModel *)formModel;
-(void) setIsDraft;
-(void)setJson:(NSString *)jsonData;
-(void)setDraftFilename:(NSString *)draftFile;
@end

@protocol CWebNotificationDelegate <NSObject>

@required
-(void)didReloadDataAtDataSource;

@end