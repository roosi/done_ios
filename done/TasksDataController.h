//
//  TasksDataController.h
//  done
//
//  Created by Jouni Nurmi on 11/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Task;

@interface TasksDataController : NSObject
@property (nonatomic,copy) NSMutableArray *tasks;
@property (nonatomic) NSUInteger selectedTask;

+(TasksDataController *) sharedController;

-(NSUInteger)countOfTasks;
-(Task *) objectInTasksAtIndex:(NSUInteger)index;
@end
