//
//  TaskUtils.h
//  done
//
//  Created by Jouni Nurmi on 15/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Task;

@interface TaskUtils : NSObject

+(UIImage*)getStatusImage:(Task*)task;

@end
