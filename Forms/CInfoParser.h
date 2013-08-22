//
//  CInfoParser.h
//  Forms
//
//  Created by Jose Vildosola on 20-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CInfoModel.h"

@interface CInfoParser : NSObject<NSXMLParserDelegate>
@property (strong, nonatomic) NSXMLParser *parser;
@property (strong, nonatomic) CInfoModel *infoModel;

-(id) initWithFile:(NSString *)filePath;
-(void) parse;
@end
