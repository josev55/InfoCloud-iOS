//
//  CFormsParser.m
//  Forms
//
//  Created by Jose Vildosola on 12-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "CFormsParser.h"

@implementation CFormsParser
@synthesize parser, chars, formModel, formularios;

- (id) initWithFile:(NSString *) filePath{
	if ((self = [super init]) != nil) {
		formularios = [[NSMutableArray alloc] init];
		NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
		parser = [[NSXMLParser alloc] initWithData:data];
		parser.delegate = self;
	}
	return self;
}

- (void) parse{
	[parser parse];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	if ([elementName isEqualToString:@"form"]) {
		self.formModel = [[CFormModel alloc] init];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if ([elementName isEqualToString:@"name"]) {
		formModel.name = chars;
	}
	if ([elementName isEqualToString:@"directoryName"]) {
		formModel.directoryName = chars;
	}
	if ([elementName isEqualToString:@"mainHtml"]) {
		formModel.mainHtml = chars;
	}
	if ([elementName isEqualToString:@"localVersion"]) {
		formModel.localVersion = chars;
	}
	if ([elementName isEqualToString:@"form"]) {
		[formularios addObject:formModel];
	}
	chars = @"";
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	chars = string;
}

@end
