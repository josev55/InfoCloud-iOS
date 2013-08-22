//
//  CInfoModel.h
//  Forms
//
//  Created by Jose Vildosola on 20-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CInfoModel : NSObject{

}
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSNumber *lastCopy;

@end
