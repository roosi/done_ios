//
//  TaskUtils.m
//  done
//
//  Created by Jouni Nurmi on 15/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import "TaskUtils.h"
#import "Task.h"

@implementation TaskUtils

+(UIImage*) getStatusImage:(Task*)task
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    
    NSDate *today = [calendar dateFromComponents:components];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setDay:-1];
    NSDate *yesterday = [calendar dateByAddingComponents:comp toDate:today options:0];
    
    if (task.completed == FALSE)
    {
        if([task.dueDate compare: today] == NSOrderedAscending) {
            //if (info.DueDate.Ticks <= DateTime.Today.Ticks) {
            return [UIImage imageNamed:@"status_due"];
        }
        else if([task.dueDate compare: yesterday] == NSOrderedAscending) {
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
