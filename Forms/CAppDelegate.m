//
//  CAppDelegate.m
//  Forms
//
//  Created by Jose Vildosola on 12-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "CAppDelegate.h"
#import "CConnectionHelper.h"

@implementation CAppDelegate
@synthesize documentPath;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentPath = ([paths count] > 0 ? [paths objectAtIndex:0] : nil);
	NSString *formsMainDirectory = [NSString stringWithFormat:@"%@/forms",documentPath];
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	if (![fileManager fileExistsAtPath:formsMainDirectory]) {
		[fileManager createDirectoryAtPath:formsMainDirectory withIntermediateDirectories:NO attributes:nil error:nil];
		NSLog(@"Directory Created!");
	}
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[CConnectionHelper getFormsURL]] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10];
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
	}
	NSString *draftPath = [NSString stringWithFormat:@"%@/forms/drafts.xml",documentPath];
	if (![[NSFileManager defaultManager] fileExistsAtPath:draftPath]) {
		NSString *draftResource = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"drafts.xml"];
		NSError *error;
		[[NSFileManager defaultManager] copyItemAtPath:draftResource toPath:draftPath error:&error];
		if (error) {
			NSLog(@"ERROR: %@",error);
		}
	}
	NSString *tmp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"tmp.js"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/tmp.js",documentPath]]) {
		[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/tmp.js",documentPath] error:nil];
	}
	[[NSFileManager defaultManager] copyItemAtPath:tmp toPath:[NSString stringWithFormat:@"%@/tmp.js",documentPath] error:&error];
	if (error) {
		NSLog(@"%@",error);
	}
	NSString *jquery = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"jquery-2.0.3.js"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/jquery-2.0.3.js",documentPath]]) {
		[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/jquery-2.0.3.js",documentPath] error:nil];
	}
	[[NSFileManager defaultManager] copyItemAtPath:jquery toPath:[NSString stringWithFormat:@"%@/jquery-2.0.3.js",documentPath] error:&error];
	if (error) {
		NSLog(@"%@",error);
	}
	    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
