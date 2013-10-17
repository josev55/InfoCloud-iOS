//
//  CDraftsParser.m
//  Forms
//
//  Created by Jose Vildosola on 20-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "CDraftsParser.h"

@implementation CDraftsParser{
	NSString *tmp;
}
@synthesize mDraftList, parser, mDraftModel,mDraftDict;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	if ([elementName isEqualToString:@"draft"]) {
		mDraftModel = [[CDraftModel alloc] init];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if ([elementName isEqualToString:@"refName"]) {
		[mDraftModel setRefName:tmp];
		if ([mDraftDict objectForKey:tmp] == nil) {
			NSMutableArray *array = [[NSMutableArray alloc] init];
			[mDraftDict setObject:array forKey:tmp];
		}
	} else if ([elementName isEqualToString:@"data"]){
		[mDraftModel setData:tmp];
	} else if ([elementName isEqualToString:@"draft"]){
		NSMutableArray *dictArray = [mDraftDict objectForKey:mDraftModel.refName];
		[dictArray addObject:mDraftModel];
	}
	tmp = @"";
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	tmp = string;
}

-(id)initWithFilePath:(NSString *)filePath{
	if ((self = [super init]) != nil) {
		parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
		parser.delegate = self;
		mDraftList = [[NSMutableArray alloc] init];
		mDraftDict = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(void)parse{
	[parser parse];
}

@end
