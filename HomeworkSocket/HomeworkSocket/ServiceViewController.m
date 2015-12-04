//
//  ServiceViewController.m
//  HomeworkSocket
//
//  Created by MS on 15-12-2.
//  Copyright (c) 2015年 陶顺顺. All rights reserved.
//

#import "ServiceViewController.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncSocket+AddProperty.h"


@interface ServiceViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,GCDAsyncSocketDelegate>

@end

@implementation ServiceViewController
{
    GCDAsyncSocket* _serviceSocket;
    
    NSMutableArray* _clientArr;
    
    NSMutableArray* _dataArr;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [NSMutableArray array];
    self.portTF.delegate =self;
    self.chatTableV.dataSource =self;
    self.chatTableV.delegate =self;
    
}
-(void)createServiceSocket{
    
    _clientArr = [NSMutableArray array];
    
    if (_serviceSocket==nil) {
        _serviceSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    NSError* error =nil;
    
    [_serviceSocket acceptOnPort:[self.portTF.text intValue] error:&error];
    if (error) {
        NSLog(@"监听失败：%@",error);
    }else{
        NSLog(@"监听成功");
    }
}

-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    
    [_clientArr addObject:newSocket];
    
    for (GCDAsyncSocket* cSocket in _clientArr) {
        
        [cSocket readDataWithTimeout:-1 tag:888];
    }
    
}
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSString* mesString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [_dataArr addObject:mesString];
    [self.chatTableV reloadData];
    
}


- (IBAction)observeing:(UIButton *)sender {
    
    [self createServiceSocket];
}

- (IBAction)sendMessage:(UIButton *)sender {
    
    NSData* data = [self.message.text dataUsingEncoding:NSUTF8StringEncoding];
    
    GCDAsyncSocket* toSocket =nil;
    for (GCDAsyncSocket* cSocket in _clientArr) {
        
        if ([self.nickName.text isEqualToString:cSocket.nickName]) {
            toSocket =cSocket;
        }
        NSLog(@"%@",cSocket);
    }
    if (toSocket ==nil) {
        NSLog(@"用户不存在");
    }else {
        [toSocket writeData:data withTimeout:-1 tag:999];
 }
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
    [_dataArr addObject:[NSString stringWithFormat:@"服务端：%@",self.message.text]];
    [self.chatTableV reloadData];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* str = @"cellID";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}

@end
