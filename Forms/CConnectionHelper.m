//
//  CConnectionHelper.m
//  Forms
//
//  Created by Jose Vildosola on 12-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "CConnectionHelper.h"

@implementation CConnectionHelper

static NSString *formsURL = @"http://192.168.4.176/forms/myforms.xml";
static NSString *formsRepo = @"http://192.168.4.176/forms/repo";

+ (NSString*)getFormsURL{
	return formsURL;
}

+ (NSString*)getRepoURL{
	return formsRepo;
}
@end
