//
//  TaskListsDataController.h
//  done
//
//  Created by Jouni Nurmi on 10/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TaskList;

@interface TaskListsDataController : NSObject
@property (nonatomic, copy) NSMutableArray *taskLists;
@property (nonatomic) NSUInteger selectedTaskList;

+(TaskListsDataController *) sharedController;

-(NSUInteger) countOfTaskLists;
-(TaskList *) objectInTaskListsAtIndex:(NSUInteger)index;
@end
