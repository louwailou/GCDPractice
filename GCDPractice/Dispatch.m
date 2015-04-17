//
//  Dispatch.m
//  GCDPractice
//
//  Created by sun on 15/3/24.
//  Copyright (c) 2015年 sun. All rights reserved.
//

#import "Dispatch.h"

@interface Dispatch ()

@property (nonatomic,strong) dispatch_queue_t isolationQueue;
@property (nonatomic,strong) dispatch_queue_t workQueue;
@property (nonatomic,strong) NSMutableDictionary * counts;
@end
@implementation Dispatch

-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)dispathc_delay{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"dispathc delay .....");
    });
}

- (void)createQueue{
    NSString *label = [NSString stringWithFormat:@"%@.isolation.%p", [self class], self];
    self.isolationQueue = dispatch_queue_create([label UTF8String], 0);
    
    label = [NSString stringWithFormat:@"%@.work.%p", [self class], self];
    self.workQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_CONCURRENT);
    self.counts = [[NSMutableDictionary alloc]initWithCapacity:0];
}
-(void)concurrentQueue{
  
   
}
//改变setter
- (void)setCount:(NSUInteger)count forKey:(NSString *)key
{
    key = [key copy];
    //确保所有barrier都是async异步的    barrier 确保所有在queueu 中得执行顺序是串行的，保证同步
    dispatch_barrier_async(self.workQueue, ^(){
        if (count == 0) {
            [self.counts removeObjectForKey:key];
        } else {
            self.counts[key] = @(count);
        }
        NSLog(@"counts = %@",self.counts);
    });
    
    
}

- (void)testConcurrnet{
    for (int i =0; i <10; i++) {
        dispatch_async(self.workQueue, ^{
            [self setCount:i forKey:[NSString stringWithFormat:@"%d",i]];
        });
    }
    for (int i =30; i <40; i++) {
        dispatch_async(self.workQueue, ^{
            [self setCount:i forKey:[NSString stringWithFormat:@"%d",i]];
        });
    }
    //使用dispatch_apply可以运行的更快
    
}
- (void)calculate{
    dispatch_apply(1, dispatch_get_global_queue(0, 0), ^(size_t y) {
        for (size_t x = 0; x < 100; x += 2) {
            //Do something with x and y here
            NSLog(@" xxxx =%d",x);
        }
    });
}

-(void)group{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, globalQueue, ^(){
        // 会处理一会
        [self calculate];
        dispatch_group_async(group, dispatch_get_main_queue(), ^(){
            NSLog(@"as = 1");
        });
    });
    dispatch_group_async(group, globalQueue, ^(){
        // 处理一会儿
        [self calculate];
        dispatch_group_async(group, dispatch_get_main_queue(), ^(){
            NSLog(@"as = 2");
        });
    });
    
    // 上面的都搞定后这里会执行一次
    dispatch_group_notify(group, dispatch_get_main_queue(), ^(){
       NSLog(@"as = 3");
    });
}

//给Core Data的-performBlock:添加groups。组合完成任务后使用dispatch_group_notify来运行一个block即可。
- (void)withGroup:(dispatch_group_t)group performBlock:(dispatch_block_t)block
{
    if (group == NULL) {
     //   [self performBlock:block];
    } else {
        dispatch_group_enter(group);
//        [self performBlock:^(){
//            block();
//            dispatch_group_leave(group);
//        }];
    }
}

- (void)timer{
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, DISPATCH_TARGET_QUEUE_DEFAULT);
    dispatch_source_set_event_handler(source, ^(){
        NSLog(@"Time flies.");
    });
    dispatch_time_t start ;
    dispatch_source_set_timer(source, DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC,100ull * NSEC_PER_MSEC);
    
    dispatch_resume(source);
}
@end
