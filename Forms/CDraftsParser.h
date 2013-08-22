//
//  CDraftsParser.h
//  Forms
//
//  Created by Jose Vildosola on 20-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDraftModel.h"

@interface CDraftsParser : NSObject<NSXMLParserDelegate>
@property (strong, nonatomic) NSXMLParser *parser;
@property (strong, nonatomic) NSMutableArray *mDraftList;
@property (strong, nonatomic) NSMutableDictionary *mDraftDict;
@property (strong, nonatomic) CDraftModel *mDraftModel;

-(id) initWithFilePath:(NSString *)filePath;
-(void) parse;
@end
