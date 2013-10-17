 //
//  CDataItemParser.m
//  Forms
//
//  Created by Jose Vildosola on 28-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "CDataItemParser.h"
#import "CRelatedItem.h"

@implementation CDataItemParser
@synthesize data,parser,related,prop,chars,tmpDict;

-(id)initWithFilePath:(NSString *)filePath{
	if ((self = [super init]) != nil) {
		parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
		parser.delegate = self;
		data = [[NSMutableArray alloc] init];
	}
	return self;
}

-(NSString *)getDataAsJSON{
	NSError *error;
	NSData *myData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
	if (error) {
		NSLog(@"ERROR: %@",error);
	}
	return [[[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if (related != nil && ![chars isEqualToString:@"\n"] && tmpDict != nil) {
		related.text = chars;
		[tmpDict setObject:related.valor forKey:@"valor"];
		[tmpDict setObject:related.text forKey:@"text"];
		[data addObject:tmpDict];
	}
	chars = @"";
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	NSString *relatedString = [attributeDict objectForKey:@"related"];
	NSLog(@"Related: %@", relatedString);
	if (relatedString != nil) {
		NSString *propFormatted = [NSString stringWithFormat:@"%@;#",prop];
		NSLog(@"prop_formatted: %@",propFormatted);
		NSRange range = [relatedString rangeOfString:propFormatted];
		if (range.location == NSNotFound) {
			NSLog(@"Not Found");
			tmpDict = nil;
		} else {
			tmpDict = [[NSMutableDictionary alloc] init];
			related = [[CRelatedItem alloc] init];
			related.valor = [attributeDict objectForKey:@"value"];
		}
	}
	
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	chars = string;
}

@end
