//
//  CIngresoLCUParser.m
//  Forms
//
//  Created by Jose Vildosola on 07-10-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "CIngresoLCUParser.h"

@implementation CIngresoLCUParser

-(NSMutableDictionary *)parse{
	[parser parse];
	return parseResult;
}

-(id)initWithFilepath:(NSString *)path{
	self = [super init];
	if (self != nil) {
		parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:path]];
		parser.delegate = self;
		parseResult = [[NSMutableDictionary alloc] init];
	}
	return self;
}

#pragma mark - NSXMLParserDelegate

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if ([elementName isEqualToString:@"field2"]) {
		[parseResult setObject:tmpString forKey:@"filial"];
	} else if ([elementName isEqualToString:@"field3"]){
		[parseResult setObject:tmpString forKey:@"unidad"];
	} else if ([elementName isEqualToString:@"field4"]){
		[parseResult setObject:tmpString forKey:@"analisis"];
	} else if ([elementName isEqualToString:@"field6"]){
		[parseResult setObject:tmpString forKey:@"plazoard"];
	} else if ([elementName isEqualToString:@"field7"]){
		[parseResult setObject:tmpString forKey:@"prevencion"];
	} else if ([elementName isEqualToString:@"field8"]){
		[parseResult setObject:tmpString forKey:@"plazoprevencion"];
	} else if ([elementName isEqualToString:@"field9"]){
		[parseResult setObject:tmpString forKey:@"reglamento"];
	} else if ([elementName isEqualToString:@"field10"]){
		[parseResult setObject:tmpString forKey:@"plazoreglamento"];
	} else if ([elementName isEqualToString:@"field11"]){
		[parseResult setObject:tmpString forKey:@"observaciones"];
	}
	tmpString = @"";
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	tmpString = string;
}

@end
