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
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property Task *task;
@property NSDateFormatter *dateFormatter;
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
    self.notesTextView.text = self.task.notes;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.datePicker.date = self.task.dueDate;
    //self.dateButton.titleLabel.text = [self.dateFormatter stringFromDate:self.datePicker.date];
}

-(void)viewDidAppear:(BOOL)animated
{
    // observe keyboard hide and show notifications to resize the text view appropriately
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self setDateButtonText];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textViewDidChangeSelection:(UITextView *)textView
{
    [textView scrollRangeToVisible:textView.selectedRange];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)selectDateTapped:(id)sender {
    [self.datePicker setHidden: !self.datePicker.hidden];
}

- (IBAction)dateChanged:(id)sender {
    [self setDateButtonText];
}

-(void) setDateButtonText
{
    [self.dateButton setTitle:[self.dateFormatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
    [self.dateButton setTitle:[self.dateFormatter stringFromDate:self.datePicker.date] forState:UIControlStateSelected];
    [self.dateButton setTitle:[self.dateFormatter stringFromDate:self.datePicker.date] forState:UIControlStateHighlighted];
    //self.dateButton.titleLabel.text = [self.dateFormatter stringFromDate:self.datePicker.date];
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
    else if (sender == self.saveButton) {
        self.task.title = self.titleTextField.text;
        self.task.notes = self.notesTextView.text;
        self.task.dueDate = self.datePicker.date;
    }
}

#pragma mark - Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect rect = self.view.frame; rect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(rect, self.notesTextView.frame.origin))
    {
        CGPoint scrollPoint = CGPointMake(0.0, self.notesTextView.frame.origin.y - (keyboardSize.height - self.notesTextView.frame.size.height));
        [self.scrollView setContentOffset:scrollPoint animated:NO];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
