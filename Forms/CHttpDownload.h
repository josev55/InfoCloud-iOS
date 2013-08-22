//
//  CHttpDownload.h
//  Forms
//
//  Created by Jose Vildosola on 19-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

@protocol HttpDownloadDelegate; //ACA SE DECLARA EL PROTOCOLO IGUAL QUE CUANDO SE DECLARA UNA FUNCION EN C

#import <Foundation/Foundation.h>
#import "CFormModel.h"

@interface CHttpDownload : NSObject<NSURLConnectionDataDelegate>{

}

@property (nonatomic, assign) id<HttpDownloadDelegate> delegate;
@property (nonatomic, strong) CFormModel *formModel;

-(void) startAsynchronousRequest:(NSURLRequest *)request delegate:(id<HttpDownloadDelegate>)d andFormModel:(CFormModel *)formModel;
@end


//ACA SE DEFINE EL PROTOCOLO
@protocol HttpDownloadDelegate <NSObject>

@required
-(void) didFinishedDownload:(NSString *)destination;

@optional
-(void) didFailWithError:(NSError *)error;

@end