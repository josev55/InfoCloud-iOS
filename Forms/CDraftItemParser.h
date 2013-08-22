//
//  CDraftItemParser.h
//  Forms
//
//  Created by Jose Vildosola on 20-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDraftItemParser : NSObject<NSXMLParserDelegate>
@property (strong, nonatomic) NSXMLParser *parser;
@property (strong, nonatomic) NSMutableArray *mDraftData;

-(id)initWithFilePath:(NSString *)filePath;
-(NSString *)getDataAsJSON;
@end
