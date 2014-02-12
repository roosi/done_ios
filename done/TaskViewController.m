//
//  TaskViewController.m
//  done
//
//  Created by Jouni Nurmi on 08/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import "TaskViewController.h"
#import "TasksDataController.h"
#import "Task.h"

@interface TaskViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;

@property Task* task;
@end

@implementation TaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.dataController = [TasksDataController sharedController];
    self.task = [self.dataController objectInTasksAtIndex:[self.dataController selectedTask]];
    
    self.titleTextField.text = self.task.title;
}

- (IBAction)saveTaskTapped:(id)sender {
}

- (IBAction)finishTaskTapped:(id)sender {
    self.task.completed = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender == self.deleteButton) {
        [self.dataController.tasks removeObjectAtIndex:[self.dataController selectedTask]];
    }
}

@end
