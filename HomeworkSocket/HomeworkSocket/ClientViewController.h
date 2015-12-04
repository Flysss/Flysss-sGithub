//
//  ClientViewController.h
//  HomeworkSocket
//
//  Created by MS on 15-12-2.
//  Copyright (c) 2015年 陶顺顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *ipTF;
@property (weak, nonatomic) IBOutlet UITextField *portTF;

@property (weak, nonatomic) IBOutlet UITextField *nickName;

@property (weak, nonatomic) IBOutlet UITextField *message;
@property (weak, nonatomic) IBOutlet UITableView *chatTVClient;

- (IBAction)connectting:(UIButton *)sender;
- (IBAction)sendMessage:(UIButton *)sender;


@end
