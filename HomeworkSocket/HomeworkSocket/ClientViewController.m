//
//  ClientViewController.m
//  HomeworkSocket
//
//  Created by MS on 15-12-2.
//  Copyright (c) 2015年 陶顺顺. All rights reserved.
//

#import "ClientViewController.h"
#import "GCDAsyncSocket+AddProperty.h"
#import "GCDAsyncSocket.h"


@interface ClientViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,GCDAsyncSocketDelegate>

@end

@implementation ClientViewController
{
    GCDAsyncSocket* _clientSocket;
    
    NSMutableArray* _dataArr;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray array];
    self.ipTF.delegate=self;
    self.portTF.delegate=self;
    self.message.delegate=self;
    self.chatTVClient.dataSource =self;
    self.chatTVClient.delegate=self;
    
}
-(void)createClientSocket{

    if (_clientSocket==nil) {
         _clientSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    _clientSocket.nickName =self.nickName.text;
    NSError* error = nil;
    [_clientSocket connectToHost:self.ipTF.text onPort:[self.portTF.text intValue] error:&error];
    if (error) {
        NSLog(@"链接失败：%@",error);
    }else{
        NSLog(@"链接成功");
    }

}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"已链接上服务器");
    
    [_clientSocket readDataWithTimeout:-1 tag:999];
}
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"失去链接：%@",err);
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSString* mesString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    [_dataArr addObject:mesString];
    [self.chatTVClient reloadData];
    
    [_clientSocket readDataWithTimeout:-1 tag:999];
    
}
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSString* string = [NSString stringWithFormat:@"客户端：%@",self.message.text];
    [_dataArr addObject:string];
}

- (IBAction)connectting:(UIButton *)sender {
    [self createClientSocket];
}

- (IBAction)sendMessage:(UIButton *)sender {
    
    NSData* data = [self.message.text dataUsingEncoding:NSUTF8StringEncoding];
    
    [_clientSocket writeData:data withTimeout:-1 tag:888];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* str = @"cellid";
   
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}


@end
