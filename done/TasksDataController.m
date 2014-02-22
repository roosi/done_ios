//
//  TasksDataController.m
//  done
//
//  Created by Jouni Nurmi on 11/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import "TasksDataController.h"
#import "TaskUtils.h"

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLServiceTasks.h"
#import "GTLTasksTaskList.h"
#import "GTLQueryTasks.h"
#import "GTLTasksTasks.h"
#import "GTLTasksTask.h"

@interface TasksDataController()
@property GTLServiceTasks *service;
@end

@implementation TasksDataController

static TasksDataController *instance;

+(TasksDataController *)sharedController
{
    if (instance == nil) {
        instance = [[TasksDataController alloc]init];
    }
    return instance;
}

-(id)init
{
    if (self = [super init] ) {
        self.tasks = [[NSMutableArray alloc]init];
        
        self.service = [[GTLServiceTasks alloc]init];
        
        //[self loadTestData];
    }
    
    return self;
}

-(void)setAuth:(GTMOAuth2Authentication *)auth
{
    if (_auth != auth) {
        _auth = auth;
        self.service.authorizer = auth;
    }
}

-(void)setTaskList:(GTLTasksTaskList *)taskList
{
    if (_taskList != taskList) {
        _taskList = taskList;
        if (self.auth != nil) {
            [self refresh];
        }
    }
}

-(void)refresh
{
    [self willChangeValueForKey:@"tasks"];
    [self.tasks removeAllObjects];
    [self didChangeValueForKey:@"tasks"];
    
    GTLQueryTasks *query = [GTLQueryTasks queryForTasksListWithTasklist:self.taskList.identifier];
    
    GTLServiceTicket *ticket = [self.service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (error == nil) {
            GTLTasksTasks *tasks = object;
            for (GTLTasksTask *task in tasks)
            {
                [self insertObject:task inTasksAtIndex:[self countOfTasks]];
            }
            
        }
        else {
            // error
        }
    }];
}

-(void)setTasks:(NSMutableArray *)tasks
{
    if (_tasks != tasks) {
        _tasks = [tasks mutableCopy];
    }
}

-(GTLTasksTask*)createNewTask
{
    GTLTasksTask *newTask = [[GTLTasksTask alloc] init];
    newTask.due = [GTLDateTime dateTimeWithDate:[NSDate date] timeZone:[NSTimeZone defaultTimeZone]];
    
    [self.tasks insertObject:newTask atIndex:0];
    [self setSelectedTask:0];
    
    GTLQueryTasks *query = [GTLQueryTasks queryForTasksInsertWithObject:newTask tasklist:self.taskList.identifier];
    
    GTLServiceTicket *ticket = [self.service executeQuery:query
                                        completionHandler:^(GTLServiceTicket *ticket,
                                                            id item, NSError *error) {
                                            // callback
                                            GTLTasksTask *task = item;
                                            if (error == nil) {
                                                [self willChangeValueForKey:@"tasks"];
                                                [self.tasks replaceObjectAtIndex:self.selectedTask withObject:task];
                                                [self didChangeValueForKey:@"tasks"];
                                            } else {
                                                //error
                                                [self.tasks removeObject:newTask];
                                                UIAlertView *aboutAlert = [[UIAlertView alloc] initWithTitle:@"Network error"
                                                                                                     message:error.description
                                                                                                    delegate:self
                                                                                           cancelButtonTitle:@"OK"
                                                                                           otherButtonTitles:nil];
                                                [aboutAlert show];
                                            }
                                        }];
    return newTask;
}

-(void)patchSelectedTask:(GTLTasksTask *)patch
{    
    GTLTasksTask *task = [self.tasks objectAtIndex:self.selectedTask];

    GTLQueryTasks *query = [GTLQueryTasks queryForTasksPatchWithObject:patch
                                                              tasklist:self.taskList.identifier
                                                                  task:task.identifier];

    GTLServiceTicket *ticket = [self.service executeQuery:query
                              completionHandler:^(GTLServiceTicket *ticket,
                                                  id item, NSError *error) {
                                  // callback
                                  GTLTasksTask *task = item;
                                  if (error == nil) {
                                      [self willChangeValueForKey:@"tasks"];
                                      [self.tasks replaceObjectAtIndex:self.selectedTask withObject:task];
                                      [self didChangeValueForKey:@"tasks"];
                                  } else {
                                      //error
                                      UIAlertView *aboutAlert = [[UIAlertView alloc] initWithTitle:@"Network error"
                                                                                           message:error.description
                                                                                          delegate:self
                                                                                 cancelButtonTitle:@"OK"
                                                                                 otherButtonTitles:nil];
                                      [aboutAlert show];
                                  }
                              }];
}

-(void)loadTestData
{
    NSDate *today = [NSDate date];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setDay:-1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *yesterday = [calendar dateByAddingComponents:comp toDate:today options:0];
    [comp setDay:2];
    NSDate *tommorrow = [calendar dateByAddingComponents:comp toDate: today options:0];
    
    GTLTasksTask *item1 = [[GTLTasksTask alloc] init];
    item1.title = @"Lorem ipsum";
    item1.due = [GTLDateTime dateTimeForAllDayWithDate:today];
    item1.notes = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi vitae fringilla lectus. Phasellus consectetur ultricies tellus, a luctus lectus tempor sit amet. Maecenas condimentum lobortis congue.";
    [self.tasks addObject:item1];
    
    GTLTasksTask *item2 = [[GTLTasksTask alloc] init];
    item2.title = @"Pellentesque elementum";
    item2.due = [GTLDateTime dateTimeForAllDayWithDate:yesterday];
    item2.notes = @"Cras pellentesque eleifend faucibus. Praesent euismod rutrum lorem non imperdiet. Etiam vel sapien arcu. In ullamcorper facilisis justo quis tincidunt.";
    [self.tasks addObject:item2];
    
    GTLTasksTask *item3 = [[GTLTasksTask alloc] init];
    item3.title = @"Aenean auctor dolor";
    item3.due = [GTLDateTime dateTimeForAllDayWithDate:tommorrow];
    item3.notes = @"Cras imperdiet dignissim facilisis. Donec feugiat ac erat et mattis.";
    [self.tasks addObject:item3];
    
    GTLTasksTask *item4 = [[GTLTasksTask alloc] init];
    item4.title = @"In tellus diam";
    item4.due = [GTLDateTime dateTimeForAllDayWithDate:yesterday];
    item4.notes = @"Curabitur vel velit euismod, venenatis odio quis, scelerisque lectus.";
    item4.status = kTaskStatusCompleted;
    [self.tasks addObject:item4];
    
    self.selectedTask = 0;
}

-(NSUInteger)countOfTasks
{
    return [self.tasks count];
}

-(GTLTasksTask *)objectInTasksAtIndex:(NSUInteger)index
{
    return [self.tasks objectAtIndex:index];
}

//KVC
-(void)insertObject:(GTLTasksTask *)task inTasksAtIndex:(NSUInteger)index
{
    [self.tasks insertObject:task atIndex:index];
}

-(void)removeObjectFromTasksAtIndex:(NSUInteger)index
{
    [self.tasks removeObjectAtIndex:index];
}

@end
