//
//  CWebViewController.m
//  Forms
//
//  Created by Jose Vildosola on 19-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "CWebViewController.h"
#import "CFormModel.h"
#import "CAppDelegate.h"

@interface CWebViewController ()

@end

@implementation CWebViewController{
	NSString *htmlFile;
	NSString *form;
}
@synthesize webView,model;

-(void)setFormModel:(CFormModel *)formModel{
	model = formModel;
}

-(void)setHtmlFile:(NSString *)html{
	htmlFile = html;
}

-(void)setFormName:(NSString *)formName{
	form = formName;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.backBarButtonItem.title = @"Nuevo";
	self.navigationItem.title = form;
	NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
	webView.delegate = self;
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
	[webView loadHTMLString:htmlString baseURL:nil];
}

-(void) setIphone{
	[webView stringByEvaluatingJavaScriptFromString:@"setIphone()"];
	//NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"javascript:setIphone();"]];
	//[webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//UIWebViewDelegate Implementation

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	NSString *requestString = [[request URL] absoluteString];
	if ([requestString hasPrefix:@"js-frame:"]) {
		NSLog(@"Entro al metodo");
		NSArray *elements = [requestString componentsSeparatedByString:@":"];
		NSString *function = [elements objectAtIndex:1];
		NSString *args = [elements objectAtIndex:2];
		[self handleFunction:function withDataAsString:args];
	}
	return YES;
}

-(void) handleFunction:(NSString *)function withDataAsString:(NSString *)data{
	if ([function isEqualToString:@"save"]) {
		NSString *localData = [data stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		CAppDelegate *app = (CAppDelegate *)[[UIApplication sharedApplication] delegate];
		NSString *draftFile = [NSString stringWithFormat:@"%@/forms/draft_%@.xml",app.documentPath,model.directoryName];
		[localData writeToFile:draftFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
	}
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
	[self setIphone];
}

//End of UIWebViewDelegate Implementation

@end
