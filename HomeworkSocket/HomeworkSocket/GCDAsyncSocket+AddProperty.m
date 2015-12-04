//
//  GCDAsyncSocket+AddProperty.m
//  HomeworkSocket
//
//  Created by MS on 15-12-2.
//  Copyright (c) 2015年 陶顺顺. All rights reserved.
//

#import "GCDAsyncSocket+AddProperty.h"
#import <objc/runtime.h>
static void* nickKey = @"nickKey";

@implementation GCDAsyncSocket (AddProperty)


-(void)setNickName:(NSString *)nickName{
    
    objc_setAssociatedObject(self, nickKey,nickName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString*)nickName{
    
    return  objc_getAssociatedObject(self, nickKey);
}
@end
