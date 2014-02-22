//
//  TaskListsDataController.m
//  done
//
//  Created by Jouni Nurmi on 10/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import "TaskListsDataController.h"

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLServiceTasks.h"
#import "GTLQueryTasks.h"
#import "GTLTasksTaskLists.h"
#import "GTLTasksTaskList.h"

@interface TaskListsDataController()
@property GTLServiceTasks *service;
@end

@implementation TaskListsDataController

static TaskListsDataController *instance;

+(TaskListsDataController *)sharedController
{
    if (instance == nil) {
        instance = [[TaskListsDataController alloc] init];
    }
    return instance;
}

-(id)init
{
    if (self = [super init]) {
        self.service = [[GTLServiceTasks alloc] init];
        
        self.taskLists = [[NSMutableArray alloc] init];
        
        //[self loadTestData];
        
        return self;
    }
    
    return self;
}

-(void)setTaskLists:(NSMutableArray *)taskLists
{
    if (_taskLists != taskLists) {
        _taskLists = [taskLists mutableCopy];
    }
}

-(void)setAuth:(GTMOAuth2Authentication *)auth
{
    if (_auth != auth) {
        _auth = auth;

        self.service.authorizer = self.auth;
        
        [self refresh];
    }
}

-(void) refresh
{
    [self willChangeValueForKey:@"taskLists"];
    [self.taskLists removeAllObjects];
    [self didChangeValueForKey:@"taskLists"];
    
    GTLQueryTasks *query = [GTLQueryTasks queryForTasklistsList];
    
    GTLServiceTicket *taskListsTicket = [self.service executeQuery:query
                                                 completionHandler:^(GTLServiceTicket *ticket,
                                                                     id taskLists, NSError *error) {
                                                     // callback
                                                     if (error == nil) {
                                                         GTLTasksTaskLists *lists = taskLists;
                                                         for(GTLTasksTaskList *list in lists)
                                                         {
                                                             [self insertObject:list inTaskListsAtIndex:[self countOfTaskLists]];
                                                         }
                                                         self.selectedTaskList = 0;
                                                     }
                                                     else {
                                                         // error
                                                         UIAlertView *aboutAlert = [[UIAlertView alloc] initWithTitle:@"Network error" message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                         [aboutAlert show];
                                                     }
                                                 }];
}

-(GTLTasksTaskList*)createTaskList:(NSString *)title
{
    GTLTasksTaskList *newList = [[GTLTasksTaskList alloc]init];
    newList.title = title;
    
    GTLQueryTasks *query = [GTLQueryTasks queryForTasklistsInsertWithObject:newList];
    
    GTLServiceTicket *taskListsTicket = [self.service executeQuery:query
                                                 completionHandler:^(GTLServiceTicket *ticket,
                                                                     id object, NSError *error) {
                                                     // callback
                                                     if (error == nil) {
                                                         GTLTasksTaskLists *list = object;
                                                         [self.taskLists addObject:list];
                                                         [self setSelectedTaskList:[self countOfTaskLists] - 1];
                                                     }
                                                     else {
                                                         // error
                                                         UIAlertView *aboutAlert = [[UIAlertView alloc] initWithTitle:@"Network error" message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                         [aboutAlert show];
                                                     }
                                                 }];
    

    
    return newList;
}

-(void)deleteTaskList:(GTLTasksTaskList *)taskList
{
    
}

- (void) loadTestData
{
    GTLTasksTaskList *item1 = [[GTLTasksTaskList alloc] init];
    item1.title = @"Dapibus nisl in purus";
    [self.taskLists addObject:item1];
    
    GTLTasksTaskList *item2 = [[GTLTasksTaskList alloc] init];
    item2.title = @"Porta imperdiet";
    [self.taskLists addObject:item2];
    
    GTLTasksTaskList *item3 = [[GTLTasksTaskList alloc] init];
    item3.title = @"Ut facilisis tellus vitae";
    [self.taskLists addObject:item3];
    
    GTLTasksTaskList *item4 = [[GTLTasksTaskList alloc] init];
    item4.title = @"Vitae neque feugiat dictum";
    [self.taskLists addObject:item4];
    
    GTLTasksTaskList *item5 = [[GTLTasksTaskList alloc] init];
    item5.title = @"Mattis convallis magna";
    [self.taskLists addObject:item5];
    
    self.selectedTaskList = 0;
}

-(NSUInteger)countOfTaskLists
{
    return [self.taskLists count];
}

-(GTLTasksTaskList*)objectInTaskListsAtIndex:(NSUInteger)index
{
    return [self.taskLists objectAtIndex:index];
}

//KVC
-(void)insertObject:(GTLTasksTaskList *)object inTaskListsAtIndex:(NSUInteger)index
{
    [self.taskLists insertObject:object atIndex:index];
}

-(void)removeObjectFromTaskListsAtIndex:(NSUInteger)index
{
    [self.taskLists removeObjectAtIndex:index];
}

@end
