//
//  CFormModel.h
//  Forms
//
//  Created by Jose Vildosola on 12-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFormModel : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *directoryName;
@property (strong, nonatomic) NSString *mainHtml;
@property (strong, nonatomic) NSString *localVersion;

@end
