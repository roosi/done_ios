//
//  TasksDataController.h
//  done
//
//  Created by Jouni Nurmi on 11/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Task;
@class GTMOAuth2Authentication;
@class GTLTasksTaskList;
@class GTLTasksTask;

@interface TasksDataController : NSObject
@property (nonatomic,strong) GTLTasksTaskList* taskList;

@property (nonatomic,copy) NSMutableArray *tasks;
@property (nonatomic) NSUInteger selectedTask;

@property (nonatomic) GTMOAuth2Authentication *auth;

+(TasksDataController *) sharedController;

-(NSUInteger)countOfTasks;
-(GTLTasksTask *) objectInTasksAtIndex:(NSUInteger)index;

-(void)patchSelectedTask:(GTLTasksTask*) patch;
-(GTLTasksTask*)createNewTask;

-(void)refresh;
@end
