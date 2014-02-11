//
//  TaskViewController.h
//  done
//
//  Created by Jouni Nurmi on 08/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TasksDataController;

@interface TaskViewController : UIViewController

@property (nonatomic,strong) TasksDataController *dataController;

@end
