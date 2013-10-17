//
//  CConnectionHelper.m
//  Forms
//
//  Created by Jose Vildosola on 12-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "CConnectionHelper.h"

@implementation CConnectionHelper

static NSString *formsURL = @"http://formulariosweb.colabra.cl/myforms.xml";
static NSString *formsRepo = @"http://formulariosweb.colabra.cl/repo";

+ (NSString*)getFormsURL{
	return formsURL;
}

+ (NSString*)getRepoURL{
	return formsRepo;
}
@end
