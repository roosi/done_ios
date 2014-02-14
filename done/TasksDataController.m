//
//  TasksDataController.m
//  done
//
//  Created by Jouni Nurmi on 11/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import "TasksDataController.h"
#import "Task.h"

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
        
        [self loadTestData];
    }
    
    return self;
}

-(void)setTaskList:(TaskList *)taskList
{
    if (_taskList != taskList) {
        [self.tasks removeAllObjects];
    }
}

-(void)setTasks:(NSMutableArray *)tasks
{
    if (_tasks != tasks) {
        _tasks = [tasks mutableCopy];
    }
}

-(void)loadTestData
{
    Task *item1 = [[Task alloc] init];
    item1.title = @"Lorem ipsum";
    item1.creationDate = [NSDate date];
    item1.dueDate = item1.creationDate;
    item1.notes = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi vitae fringilla lectus. Phasellus consectetur ultricies tellus, a luctus lectus tempor sit amet. Maecenas condimentum lobortis congue.";
    [self.tasks addObject:item1];
    
    Task *item2 = [[Task alloc] init];
    item2.title = @"Pellentesque elementum";
    item2.creationDate = [NSDate date];
    item2.dueDate = item1.creationDate;
    item2.notes = @"Cras pellentesque eleifend faucibus. Praesent euismod rutrum lorem non imperdiet. Etiam vel sapien arcu. In ullamcorper facilisis justo quis tincidunt.";
    [self.tasks addObject:item2];
    
    self.selectedTask = 0;
}

-(NSUInteger)countOfTasks
{
    return [self.tasks count];
}

-(Task *)objectInTasksAtIndex:(NSUInteger)index
{
    return [self.tasks objectAtIndex:index];
}


@end
