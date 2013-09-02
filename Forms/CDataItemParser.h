//
//  CDataItemParser.h
//  Forms
//
//  Created by Jose Vildosola on 28-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRelatedItem.h"

@interface CDataItemParser : NSObject<NSXMLParserDelegate>
@property (strong, nonatomic) NSXMLParser *parser;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) CRelatedItem *related;
@property (strong, nonatomic) NSString *prop;
@property (strong, nonatomic) NSString *chars;
@property (strong, nonatomic) NSMutableDictionary *tmpDict;

-(id)initWithFilePath:(NSString *)filePath;
-(NSString *)getDataAsJSON;

@end
