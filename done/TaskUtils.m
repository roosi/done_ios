//
//  TaskUtils.m
//  done
//
//  Created by Jouni Nurmi on 15/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import "TaskUtils.h"

#import "GTLTasksTask.h"

// Constants that ought to be defined by the API
NSString *const kTaskStatusCompleted = @"completed";
NSString *const kTaskStatusNeedsAction = @"needsAction";

@implementation TaskUtils

+(UIImage*) getStatusImage:(GTLTasksTask*)task
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    
    NSDate *today = [calendar dateFromComponents:components];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setDay:1];
    NSDate *tommorrow = [calendar dateByAddingComponents:comp toDate:today options:0];
    
    if ([task.status isEqualToString:kTaskStatusCompleted] == FALSE)
    {
        if([task.due.date compare: today] == NSOrderedAscending) {
            //if (info.DueDate.Ticks <= DateTime.Today.Ticks) {
            return [UIImage imageNamed:@"status_due"];
        }
        else if([task.due.date compare: tommorrow] == NSOrderedAscending) {
            //else if (info.DueDate.AddDays(-1).Ticks <= DateTime.Today.Ticks) {
            return [UIImage imageNamed:@"status_due_closing"];
        }
        else {
            return [UIImage imageNamed:@"status_needs_action"];
        }
    }
    else {
        return [UIImage imageNamed:@"status_completed"];
    }
}

@end
