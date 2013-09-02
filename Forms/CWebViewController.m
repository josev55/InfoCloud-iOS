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
#import "CDataItemParser.h"
#import "Base64.h"

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
	BOOL isSendingData;
	NSString *draftFilename;
}
@synthesize webView,model;

-(void)setDraftFilename:(NSString *)draftFile{
	draftFilename = draftFile;
}

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

-(void)setIsSendiongData:(BOOL) value{
	isSendingData = value;
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
	NSString *baseURL = [htmlFile stringByDeletingLastPathComponent];
	NSLog(@"%@",baseURL);
	NSString *script = [NSString stringWithFormat:@"<script src='%@/jquery-2.0.3.js'></script><script src='%@/tmp.js'></script></body>",app.documentPath,app.documentPath];
	htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</body>" withString:script];
	if (isDraft) {
		NSString *formFolder = [form stringByReplacingOccurrencesOfString:@" " withString:@"_"];
		NSString *filePath = [NSString stringWithFormat:@"%@/forms/%@/%@",app.documentPath,formFolder,htmlFile];
		baseURL = [filePath stringByDeletingLastPathComponent];
		NSLog(@"%@",baseURL);
		htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
		htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</body>" withString:script];
		
	}
	webView.delegate = self;
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
	[webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:baseURL]];
	if (isDraft) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Enviar" style:UIBarButtonItemStyleBordered target:self action:@selector(enviar)];

	}
	[self setIsSendiongData:NO];
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
	[self setIsSendiongData:YES];

	[[[UIAlertView alloc] initWithTitle:@"Prueba de boton" message:isSendingData ? @"YES" : @"NO" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
	[webView stringByEvaluatingJavaScriptFromString:@"save()"];
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
	if (isDraft) {
		tmpPath = [form stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	} else {
		tmpPath = model.directoryName;
	}
	if ([function isEqualToString:@"save"]) {
		
		
		NSString *localData = [data stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		infoPath = [NSString stringWithFormat:@"%@/forms/%@/info.xml",app.documentPath,tmpPath];
		CInfoParser *parser = [[CInfoParser alloc] initWithFile:infoPath];
		[parser parse];
		CInfoModel *infoModel = [parser infoModel];
		if (!isSendingData) {
			[self modifyInfoXML:infoModel];
			NSString *draftFile = [NSString stringWithFormat:@"%@/forms/draft_%@_%d.xml",app.documentPath,tmpPath,infoModel.lastCopy.integerValue];
			[localData writeToFile:draftFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mensaje" message:@"Datos Guardados" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
			alert.delegate = self;
			[alert show];
		} else {
			NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/forms/outbox.plist",app.documentPath]];
			[plistDict setValue:[NSString stringWithFormat:@"%@/forms/%@.xml",app.documentPath,draftFilename] forKey:[draftFilename stringByReplacingOccurrencesOfString:@"draft_" withString:@""]];
			[plistDict writeToFile:[NSString stringWithFormat:@"%@/forms/outbox.plist",app.documentPath] atomically:NO];
			[self modifyDraftXML:draftFilename];
			NSLog(@"%@",plistDict);
			NSLog(@"%@",[form stringByReplacingOccurrencesOfString:@" " withString:@"_"]);
			[[self delegate] didReloadDataAtDataSource];
			
		}
	}
	if([function isEqualToString:@"load_related"]){
		NSArray *splitArgs = [data componentsSeparatedByString:@"$"];
		CDataItemParser *dataParser = [[CDataItemParser alloc] initWithFilePath:[NSString stringWithFormat:@"%@/forms/%@/%@.xml",app.documentPath,tmpPath,[splitArgs objectAtIndex:0]]];
		dataParser.prop = [splitArgs objectAtIndex:1];
		[dataParser.parser parse];
		NSString *json2 = [dataParser getDataAsJSON];
		NSLog(@"JSON: %@",json2);
		[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"related_data('%@')",json2]];
	}
}

-(void)modifyDraftXML:(NSString *)draftName{
	NSError *error;
	NSString *xmlDraft = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/forms/drafts.xml",app.documentPath] encoding:NSUTF8StringEncoding error:&error];
	
	NSLog(@"%@",[NSString stringWithFormat:@"<draft><refName>%@</refName><data>%@</data></draft>",[form stringByReplacingOccurrencesOfString:@" " withString:@"_"],draftName]);
	xmlDraft = [xmlDraft stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<draft><refName>%@</refName><data>%@</data></draft>",[form stringByReplacingOccurrencesOfString:@" " withString:@"_"],draftName] withString:@""];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/forms/drafts.xml",app.documentPath]]) {
		[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/forms/drafts.xml",app.documentPath] error:&error];
	}
	[xmlDraft writeToFile:[NSString stringWithFormat:@"%@/forms/drafts.xml",app.documentPath] atomically:NO encoding:NSUTF8StringEncoding error:&error];
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

-(void) sendData{
	NSString *test = @"asdfghjklqwertyuio";
	NSData *data = [test dataUsingEncoding:NSUTF8StringEncoding];
	NSString *encoded = [data base64EncodedString];
}



//End of UIWebViewDelegate Implementation

@end
