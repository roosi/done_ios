//
//  TaskListViewController.h
//  done
//
//  Created by Jouni Nurmi on 08/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskListsPickerController.h"

@interface TaskListViewController : UITableViewController <TaskListPickerControllerDelegate>

@property NSMutableArray *tasks;

@end
