//
//  TaskListViewController.h
//  done
//
//  Created by Jouni Nurmi on 08/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskListsPickerController.h"

@class TaskListsDataController;
@class TasksDataController;

@interface TaskListViewController : UITableViewController <TaskListPickerControllerDelegate>

@property (nonatomic,strong) TaskListsDataController *dataController;

@property (nonatomic,strong) TasksDataController *tasksDataController;
@end
