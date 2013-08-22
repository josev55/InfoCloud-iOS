//
//  CHttpDownload.m
//  Forms
//
//  Created by Jose Vildosola on 19-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "CHttpDownload.h"
#import "CAppDelegate.h"
#import "SSZipArchive.h"

@implementation CHttpDownload
@synthesize formModel;

-(void)startAsynchronousRequest:(NSURLRequest *)request delegate:(id<HttpDownloadDelegate>)d andFormModel:(CFormModel *)model{
	NSOperationQueue *downloadQueue = [[NSOperationQueue alloc] init];
	self.formModel = model;
	[NSURLConnection sendAsynchronousRequest:request queue:downloadQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
		if (!error) {
			CAppDelegate *app = (CAppDelegate*)[[UIApplication sharedApplication] delegate];
			NSString *formLocation = [NSString stringWithFormat:@"%@/forms/%@",app.documentPath,formModel.directoryName];
			NSLog(@"Directory Name: %@",formModel.directoryName);
			NSLog(@"File Location: %@",formLocation);
			BOOL isDir;
			if (![[NSFileManager defaultManager] fileExistsAtPath:formLocation isDirectory:&isDir]) {
				[[NSFileManager defaultManager] createDirectoryAtPath:formLocation withIntermediateDirectories:NO attributes:nil error:nil];
			}
			NSLog(@"File: %@",[NSString stringWithFormat:@"%@/%@.zip",formLocation,formModel.directoryName]);
			NSString *file = [NSString stringWithFormat:@"%@/%@.zip",formLocation,formModel.directoryName];
			[data writeToFile:file atomically:NO];
			[SSZipArchive unzipFileAtPath:file toDestination:formLocation];
			[d didFinishedDownload:file];
		} else {
			[d didFailWithError:error];
		}
	}];
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
	return nil;
}

@end
