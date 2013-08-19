//
//  CFormsParser.h
//  Forms
//
//  Created by Jose Vildosola on 12-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFormModel.h"

@interface CFormsParser : NSObject<NSXMLParserDelegate>
@property (strong, nonatomic) NSXMLParser *parser;
@property (strong, nonatomic) NSString *chars;
@property (strong, nonatomic) NSMutableArray *formularios;
@property (strong, nonatomic) CFormModel *formModel;

-(void)parse;
-(id) initWithFile:(NSString *) filePath;

@end
