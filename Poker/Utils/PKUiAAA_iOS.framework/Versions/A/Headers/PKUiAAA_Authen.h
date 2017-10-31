//
//  AuthenViewController.h
//  PKU_Mobile_Authen
//
//  Created by yangj on 2016/11/8.
//  Copyright © 2016年 pku. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PKUOpenAPI;
@protocol PKUOpenAPIDelegate <NSObject>

//-(void)authenticateSuccess: (PKUOpenAPI *)sender;


-(void)authenticateSuccess: (NSString*) uid withToken: (NSString*) token;

//-(void)authenticateFail: (PKUOpenAPI *)sender;

-(void)authenticateCancel;

@end


@interface PKUOpenAPI : UIViewController <UIAlertViewDelegate, UITableViewDelegate>{

}
@property (nonatomic, weak) id <PKUOpenAPIDelegate> delegate;

@property(nonatomic, strong) NSString* appID;

@end
