//
//  TaskListsDataController.m
//  done
//
//  Created by Jouni Nurmi on 10/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import "TaskListsDataController.h"
#import "TaskList.h"

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
        self.taskLists = [[NSMutableArray alloc] init];
        
        [self loadTestData];
        
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

- (void) loadTestData
{
    TaskList *item1 = [[TaskList alloc] init];
    item1.title = @"Dapibus nisl in purus";
    [self.taskLists addObject:item1];
    
    TaskList *item2 = [[TaskList alloc] init];
    item2.title = @"Porta imperdiet";
    [self.taskLists addObject:item2];
    
    TaskList *item3 = [[TaskList alloc] init];
    item3.title = @"Ut facilisis tellus vitae";
    [self.taskLists addObject:item3];
    
    TaskList *item4 = [[TaskList alloc] init];
    item4.title = @"Vitae neque feugiat dictum";
    [self.taskLists addObject:item4];
    
    TaskList *item5 = [[TaskList alloc] init];
    item5.title = @"Mattis convallis magna";
    [self.taskLists addObject:item5];
    
    self.selectedTaskList = 0;
}

-(NSUInteger)countOfTaskLists
{
    return [self.taskLists count];
}

-(TaskList*)objectInTaskListsAtIndex:(NSUInteger)index
{
    return [self.taskLists objectAtIndex:index];
}

@end
