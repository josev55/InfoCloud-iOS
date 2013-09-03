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

@interface COutboxViewController (){
	CAppDelegate *app;
	NSMutableDictionary *dict;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.mOutboxArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *identifier = @"Cell";
	COutboxItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = (COutboxItemCell *)[[[NSBundle mainBundle] loadNibNamed:@"UIOutboxCell" owner:self options:nil] objectAtIndex:0];
	}
	cell.mOutboxImg.image = [UIImage imageNamed:@"edit.png"];
	cell.mOutboxLabel.text = [self.mOutboxArray objectAtIndex:indexPath.row];
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 90;
}

- (IBAction)sincronizar:(id)sender {
	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/forms/outbox.plist",app.documentPath]];
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
				}
				[self reload];
				[self.mTableView reloadData];
			}
		}
	});
}
-(void)reload{
	dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/forms/outbox.plist",app.documentPath]];
	self.mOutboxArray = [[dict allKeys] mutableCopy];
}
@end
