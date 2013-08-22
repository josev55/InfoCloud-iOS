//
//  CDraftItemParser.m
//  Forms
//
//  Created by Jose Vildosola on 20-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "CDraftItemParser.h"

@implementation CDraftItemParser{
	NSString *tmp;
	NSNumber *ID;
}
@synthesize parser,mDraftData;

-(id)initWithFilePath:(NSString *)filePath{
	if ([super init] != nil) {
		parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
		parser.delegate = self;
		mDraftData = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if (![elementName isEqualToString:@"formData"]) {
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict setObject:ID forKey:@"guid"];
		[dict setObject:tmp forKey:@"valor"];
		[dict setObject:elementName forKey:@"name"];
		[mDraftData addObject:dict];
	}
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	if ([attributeDict objectForKey:@"id"] != nil) {
		NSString *value = [attributeDict objectForKey:@"id"];
		ID = [NSNumber numberWithInteger:[value integerValue]];
	}
	if (![elementName isEqualToString:@"formData"]) {
		tmp = @"";
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	tmp = string;
}

-(NSString *)getDataAsJSON{
	NSError *error;
	NSData *data = [NSJSONSerialization dataWithJSONObject:mDraftData options:NSJSONWritingPrettyPrinted error:&error];
	if (error) {
		NSLog(@"JSON Error: %@", error);
	}
	NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return json;
}

@end
