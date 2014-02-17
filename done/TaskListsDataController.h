//
//  TaskListsDataController.h
//  done
//
//  Created by Jouni Nurmi on 10/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTLTasksTaskList;
@class GTMOAuth2Authentication;

@interface TaskListsDataController : NSObject
@property (nonatomic, copy) NSMutableArray *taskLists;
@property (nonatomic) NSUInteger selectedTaskList;

@property (nonatomic) GTMOAuth2Authentication *auth;

+(TaskListsDataController *) sharedController;

-(NSUInteger) countOfTaskLists;
-(GTLTasksTaskList *) objectInTaskListsAtIndex:(NSUInteger)index;
@end
