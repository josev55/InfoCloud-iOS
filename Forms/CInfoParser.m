//
//  CInfoParser.m
//  Forms
//
//  Created by Jose Vildosola on 20-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "CInfoParser.h"

@implementation CInfoParser{
	NSString *tmp;
}
@synthesize parser, infoModel;

-(id)initWithFile:(NSString *)filePath{
	if ((self = [super init]) != nil) {
		parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
		parser.delegate = self;
		infoModel = [[CInfoModel alloc] init];
	}
	return self;
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if ([elementName isEqualToString:@"id"]) {
		[infoModel setID:tmp];
	} else if([elementName isEqualToString:@"name"]){
		[infoModel setName:tmp];
	} else if([elementName isEqualToString:@"version"]) {
		[infoModel setVersion:tmp];
	} else if([elementName isEqualToString:@"lastCopy"]){
		[infoModel setLastCopy:[NSNumber numberWithInteger:[tmp integerValue]]];
	}
	tmp = @"";
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	tmp = string;
}

-(void) parse{
	[parser parse];
}

@end
