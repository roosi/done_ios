//
//  Task.h
//  done
//
//  Created by Jouni Nurmi on 08/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property NSString *title;
@property BOOL completed;
@property (readonly) NSDate *creationDate;
@property NSString *notes;

@end
