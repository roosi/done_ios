//
//  TaskListsPickerController.h
//  done
//
//  Created by Jouni Nurmi on 08/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskList;
@class TaskListsDataController;

@protocol TaskListPickerControllerDelegate;

@interface TaskListsPickerController : UITableViewController <UIBarPositioningDelegate>

@property (nonatomic, assign) id<TaskListPickerControllerDelegate> delegate;

@property (nonatomic) NSUInteger selectedIndex;

@property (nonatomic,strong) TaskListsDataController *dataController;

@end

@protocol TaskListPickerControllerDelegate <NSObject>

// The picker does not dismiss itself; the client dismisses it in these callbacks.
// The delegate will receive one or the other, but not both, depending whether the user
// confirms or cancels.
- (void)taskListPickerController:(TaskListsPickerController *)picker didFinishPickingTaskList:(TaskList *)taskList;
@end
