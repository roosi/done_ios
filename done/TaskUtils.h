//
//  TaskUtils.h
//  done
//
//  Created by Jouni Nurmi on 15/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTLTasksTask;

// Constants that ought to be defined by the API
extern NSString *const kTaskStatusCompleted;
extern NSString *const kTaskStatusNeedsAction;

@interface TaskUtils : NSObject

+(UIImage*)getStatusImage:(GTLTasksTask*)task;

@end
