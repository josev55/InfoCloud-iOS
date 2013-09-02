//
//  CStartViewController.m
//  Forms
//
//  Created by Jose Vildosola on 02-09-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "CStartViewController.h"
#import "CConnectionHelper.h"
#import "Reachability.h"

@interface CStartViewController ()

@end

@implementation CStartViewController
@synthesize loadingIndicator,documentPath,app;

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
	[[[self navigationController] navigationBar] setHidden:YES];
	[loadingIndicator startAnimating];
	dispatch_async(dispatch_get_main_queue(), ^{
		[self setInitialResources];
	});
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setInitialResources{

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentPath = ([paths count] > 0 ? [paths objectAtIndex:0] : nil);
	NSString *formsMainDirectory = [NSString stringWithFormat:@"%@/forms",documentPath];
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	if (![fileManager fileExistsAtPath:formsMainDirectory]) {
		[fileManager createDirectoryAtPath:formsMainDirectory withIntermediateDirectories:NO attributes:nil error:nil];
		NSLog(@"Directory Created!");
	}
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[CConnectionHelper getFormsURL]] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:5];
	NSURLResponse *response = nil;
	NSError *error;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if (!error) {
		NSLog(@"%@",error);
		NSString *xmlForms = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@",xmlForms);
		NSString *filename = [NSString stringWithFormat:@"%@/myforms.xml",formsMainDirectory];
		if ([fileManager fileExistsAtPath:filename]){
			[fileManager removeItemAtPath:filename error:nil];
		}
		[fileManager createFileAtPath:filename contents:data attributes:nil];
	} else {
		NSLog(@"ERROR: %@",error);
	}
	NSString *draftPath = [NSString stringWithFormat:@"%@/forms/drafts.xml",documentPath];
	if (![[NSFileManager defaultManager] fileExistsAtPath:draftPath]) {
		NSString *draftResource = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"drafts.xml"];
		NSError *error2;
		[[NSFileManager defaultManager] copyItemAtPath:draftResource toPath:draftPath error:&error2];
		if (error2) {
			NSLog(@"ERROR: %@",error2);
		}
	}
	NSString *tmp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"tmp.js"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/tmp.js",documentPath]]) {
		[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/tmp.js",documentPath] error:nil];
	}
	error = nil;
	[[NSFileManager defaultManager] copyItemAtPath:tmp toPath:[NSString stringWithFormat:@"%@/tmp.js",documentPath] error:&error];
	if (error) {
		NSLog(@"%@",error);
	}
	NSString *jquery = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"jquery-2.0.3.js"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/jquery-2.0.3.js",documentPath]]) {
		[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/jquery-2.0.3.js",documentPath] error:nil];
	}
	error = nil;
	[[NSFileManager defaultManager] copyItemAtPath:jquery toPath:[NSString stringWithFormat:@"%@/jquery-2.0.3.js",documentPath] error:&error];
	if (error) {
		NSLog(@"%@",error);
	}
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/forms/outbox.plist",app.documentPath]]) {
		NSString *outboxPlist = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"outbox.plist"];
		error = nil;
		[[NSFileManager defaultManager] copyItemAtPath:outboxPlist toPath:[NSString stringWithFormat:@"%@/forms/outbox.plist",app.documentPath] error:&error];
		if (error) {
			NSLog(@"ERROR: %@",error);
		}
	}
	[self performSegueWithIdentifier:@"menu" sender:nil];
}
@end
