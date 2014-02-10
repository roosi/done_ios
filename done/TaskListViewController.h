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

@interface TaskListViewController : UITableViewController <TaskListPickerControllerDelegate>

@property NSMutableArray *tasks;

@property (nonatomic,strong) TaskListsDataController *dataController;

@end
