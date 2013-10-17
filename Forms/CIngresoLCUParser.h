//
//  CIngresoLCUParser.h
//  Forms
//
//  Created by Jose Vildosola on 07-10-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIngresoLCUParser : NSObject<NSXMLParserDelegate>{
	NSXMLParser *parser;
	NSMutableDictionary *parseResult;
	NSString *tmpString;
}

- (id) initWithFilepath:(NSString*)path;
- (NSMutableDictionary*) parse;

@end
