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
#import "CInfoModel.h"
#import "CInfoParser.h"
#import "CDraftsParser.h"

@interface CWebViewController ()

@end

@implementation CWebViewController{
	NSString *htmlFile;
	NSString *form;
	NSString *infoPath;
	CAppDelegate *app;
	BOOL isDraft;
	NSString *tmpPath;
	NSString *json;
}
@synthesize webView,model;

-(void)setJson:(NSString *)jsonData{
	json = jsonData;
}

-(void)setFormModel:(CFormModel *)formModel{
	model = formModel;
}

-(void)setHtmlFile:(NSString *)html{
	htmlFile = html;
}

-(void)setFormName:(NSString *)formName{
	form = formName;
}

-(void)setIsDraft{
	isDraft = YES;
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
	app = (CAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.navigationItem.backBarButtonItem.title = @"Nuevo";
	self.navigationItem.title = form;
	
	NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
	if (isDraft) {
		NSString *formFolder = [form stringByReplacingOccurrencesOfString:@" " withString:@"_"];
		NSString *filePath = [NSString stringWithFormat:@"%@/forms/%@/%@",app.documentPath,formFolder,htmlFile];
		htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	}
	webView.delegate = self;
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
	[webView loadHTMLString:htmlString baseURL:nil];
	if (isDraft) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Enviar" style:UIBarButtonItemStyleBordered target:self action:@selector(enviar)];

	}
}

-(void) setIphone{
	[webView stringByEvaluatingJavaScriptFromString:@"setIphone()"];
	[webView stringByEvaluatingJavaScriptFromString:@"setInputEnabled()"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) enviar{
	
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
		
		if (isDraft) {
			tmpPath = [form stringByReplacingOccurrencesOfString:@" " withString:@"_"];
		} else {
			tmpPath = model.directoryName;
		}
		NSString *localData = [data stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		infoPath = [NSString stringWithFormat:@"%@/forms/%@/info.xml",app.documentPath,tmpPath];
		CInfoParser *parser = [[CInfoParser alloc] initWithFile:infoPath];
		[parser parse];
		CInfoModel *infoModel = [parser infoModel];
		[self modifyInfoXML:infoModel];
		NSString *draftFile = [NSString stringWithFormat:@"%@/forms/draft_%@_%d.xml",app.documentPath,tmpPath,infoModel.lastCopy.integerValue];
		[localData writeToFile:draftFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mensaje" message:@"Datos Guardados" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		alert.delegate = self;
		[alert show];
	}
}

-(void)modifyInfoXML:(CInfoModel *)infoModel{
	NSString *newXML = [NSString stringWithFormat:@"<?xml version='1.0' ?><config xmlns='http://cl.colabra.infocloud'><id>%@</id><name>%@</name><version>%@</version><lastCopy>%d</lastCopy></config>",infoModel.ID,infoModel.name,infoModel.version,infoModel.lastCopy.integerValue + 1];
	NSError *error;
	if ([[NSFileManager defaultManager] fileExistsAtPath:infoPath]) {
		[[NSFileManager defaultManager] removeItemAtPath:infoPath error:&error];
	}
	[newXML writeToFile:infoPath atomically:NO encoding:NSUTF8StringEncoding error:&error];
	if (error) {
		NSLog(@"ERROR: %@",error);
	}
	NSString *draftPath = [NSString stringWithFormat:@"%@/forms/drafts.xml",app.documentPath];
	CDraftsParser *parser = [[CDraftsParser alloc] initWithFilePath:draftPath];
	[parser parse];
	NSMutableDictionary *dict = [parser mDraftDict];
	NSMutableString *draftXML = [[NSMutableString alloc] init];
	[draftXML appendString:@"<?xml version='1.0' ?><drafts xmlns='http://cl.colabra.forms'>"];
	for(NSString *key in dict){
		for(CDraftModel *draft in [dict objectForKey:key]){
			[draftXML appendString:[NSString stringWithFormat:@"<draft><refName>%@</refName><data>%@</data></draft>",draft.refName,draft.data]];
		}
	}
	[draftXML appendString:[NSString stringWithFormat:@"<draft><refName>%@</refName><data>draft_%@_%d</data></draft></drafts>",tmpPath,tmpPath,infoModel.lastCopy.integerValue]];
	if ([[NSFileManager defaultManager] fileExistsAtPath:draftPath]) {
		[[NSFileManager defaultManager] removeItemAtPath:draftPath error:&error];
	}
	[draftXML writeToFile:draftPath atomically:NO encoding:NSUTF8StringEncoding error:&error];
	if (error) {
		NSLog(@"ERROR: %@", error);
	}
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	[[self navigationController] popViewControllerAnimated:YES];

}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
	[self setIphone];
	[self loadData];
}

-(void) loadData{
	if (isDraft) {
		NSLog(@"JSON: %@",json);
		[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"loadData('%@')",json]];
	}
}

//End of UIWebViewDelegate Implementation

@end
