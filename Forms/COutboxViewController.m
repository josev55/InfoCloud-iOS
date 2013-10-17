//
//  COutboxViewController.m
//  Forms
//
//  Created by Jose Vildosola on 02-09-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "COutboxViewController.h"
#import "COutboxItemCell.h"
#import "COutboxModel.h"
#import "CAppDelegate.h"
#import "Base64.h"
#import "CIngresoLCUParser.h"
#import "LoadingView.h"

@interface COutboxViewController (){
	CAppDelegate *app;
	NSMutableDictionary *dict;
	LoadingView *loadingView;
}

@end

@implementation COutboxViewController

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
	self.mTableView.dataSource = self;
	self.mTableView.delegate = self;
	app = (CAppDelegate *)[[UIApplication sharedApplication] delegate];
	dict = [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/forms/outbox.plist",app.documentPath]];
	self.mOutboxArray = [[dict allKeys] mutableCopy];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)sincronizar:(id)sender {
	loadingView = [LoadingView loadingViewInView:[self.view.window.subviews objectAtIndex:0]];
	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/forms/outbox.plist",app.documentPath]];
	dispatch_async(dispatch_get_main_queue(), ^{
		for (NSString *value in dictionary) {
			CIngresoLCUParser *parser = [[CIngresoLCUParser alloc] initWithFilepath:[dictionary objectForKey:value]];
			NSMutableDictionary *resultDict = [parser parse];
			NSString *sharepointData = @"";
			for (NSString *key in resultDict) {
				sharepointData = [NSString stringWithFormat:@"%@%@=%@&",sharepointData,key,[resultDict objectForKey:key]];
			}
			NSMutableURLRequest *sharepointRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://formulariosweb.colabra.cl/api/sharepoint"] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10];
			[sharepointRequest setHTTPMethod:@"POST"];
			[sharepointRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
			[sharepointRequest setHTTPBody:[sharepointData dataUsingEncoding:NSUTF8StringEncoding]];
			NSURLResponse *sharepointResponse;
			NSError *sharepointError;
			NSData *sharepointResponseData = [NSURLConnection sendSynchronousRequest:sharepointRequest returningResponse:&sharepointResponse error:&sharepointError];
			if (!sharepointError) {
				NSString *sharepointDataString = [[NSString alloc] initWithData:sharepointResponseData encoding:NSUTF8StringEncoding];
				NSLog(@"Response: %@",sharepointDataString);
			}
		}
	});
	dispatch_async(dispatch_get_main_queue(), ^{
		
		
		for (NSString *value in dictionary) {
			NSString *content = [dictionary objectForKey:value];
			NSError *error;
			NSString *encoded = [[NSString stringWithContentsOfFile:content encoding:NSUTF8StringEncoding error:&error] stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy];
			if (error) {
				NSLog(@"ERROR: %@",error);
			}
			NSLog(@"%@",encoded);
			NSData *data = [encoded dataUsingEncoding:NSUTF8StringEncoding];
			NSString *data64 = [data base64EncodedString];
			NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://formulariosweb.colabra.cl/api/mobile"] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10];
			[request setHTTPMethod:@"POST"];
			[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
			NSString *postData = [NSString stringWithFormat:@"filename=%@&encodedFile=%@",value,data64];
			[request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
			NSURLResponse *response;
			error = nil;
			NSData *mydata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
			if (!error) {
				NSString *dataString = [[NSString alloc] initWithData:mydata encoding:NSUTF8StringEncoding];
				[dict removeObjectForKey:[dataString stringByReplacingOccurrencesOfString:@".xml" withString:@""]];
				if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/forms/outbox.plist",app.documentPath]]) {
					NSError *error;
					[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/forms/outbox.plist",app.documentPath] error:&error];
					if (error) {
						NSLog(@"ERROR: %@",error);
					}
					
					[self reload];
					[self.mTableView reloadData];
				}
			}
		}
	});
	[loadingView removeView];
	[[[UIAlertView alloc] initWithTitle:@"Sharepoint" message:@"Datos sincronizados a Sharepoint" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

-(void)reload{
	dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/forms/outbox.plist",app.documentPath]];
	self.mOutboxArray = [[dict allKeys] mutableCopy];
}

#pragma mark - TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if ([self.mOutboxArray count] == 0) {
		return 1;
	}
	return self.mOutboxArray.count;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
	if (self.mOutboxArray.count == 0) {
		return NO;
	}
	return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *identifier = @"Cell";
	COutboxItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = (COutboxItemCell *)[[[NSBundle mainBundle] loadNibNamed:@"UIOutboxCell" owner:self options:nil] objectAtIndex:0];
	}
	if ([self.mOutboxArray count] == 0) {
		cell.mOutboxLabel.text = @"";
		
	} else {
		cell.mOutboxImg.image = [UIImage imageNamed:@"edit.png"];
		cell.mOutboxLabel.text = [self.mOutboxArray objectAtIndex:indexPath.row];
	}
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([self.mOutboxArray count] == 0) {
		return self.mTableView.bounds.size.height;
	}
	return 90;
}

#pragma mark - UIALertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	[[self navigationController] popToRootViewControllerAnimated:YES];
}
@end
