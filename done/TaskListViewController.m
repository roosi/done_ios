//
//  TaskListViewController.m
//  done
//
//  Created by Jouni Nurmi on 08/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskListsPickerController.h"
#import "Task.h"
#import "TaskList.h"
#import "TaskListsDataController.h"
#import "TasksDataController.h"
#import "TaskUtils.h"

@interface TaskListViewController ()
@property NSDateFormatter *dateFormatter;
@end

@implementation TaskListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.dataController = [TaskListsDataController sharedController];
    self.tasksDataController = [TasksDataController sharedController];
    
    self.title = [self.dataController objectInTaskListsAtIndex:[self.dataController selectedTaskList]].title;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteListTapped:(id)sender {
    
    if ([self.dataController countOfTaskLists] > 1) {
        [self.dataController.taskLists removeObjectAtIndex:[self.dataController selectedTaskList]];
    
        [self.dataController setSelectedTaskList:0];
        TaskList *list = [self.dataController objectInTaskListsAtIndex:0];
        [self.tasksDataController setTaskList:list];
        self.title = list.title;
    
        [self.tableView reloadData];
    }
}

- (IBAction)createNewListTapped:(id)sender {
    TaskList *list = [[TaskList alloc]init];
    list.title = @"new list";
    
    [self.dataController.taskLists addObject:list];
    [self.dataController setSelectedTaskList:[self.dataController countOfTaskLists] - 1];
    [self.tasksDataController setTaskList:list];
    self.title = list.title;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tasksDataController countOfTasks];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Task *item = [self.tasksDataController objectInTasksAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:item.dueDate];
    [cell.imageView setImage:[TaskUtils getStatusImage:item]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"SelectTaskList"])
    {        
        UINavigationController *navigationController = segue.destinationViewController;
        TaskListsPickerController *pickerController = [navigationController viewControllers][0];
        pickerController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"NewTask"])
    {
        Task *item = [[Task alloc] init];
        item.creationDate = [NSDate date];
        item.dueDate = item.creationDate;
        
        [self.tasksDataController.tasks insertObject:item atIndex:0];
        [self.tasksDataController setSelectedTask:0];
        
        [self.tableView reloadData];
        
    }
    else if ([[segue identifier] isEqualToString:@"ShowTask"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [self.tasksDataController setSelectedTask:indexPath.row];
    }
    
}

-(void)taskListPickerController:(TaskListsPickerController *)picker didFinishPickingTaskList:(TaskList *)taskList
{
    if (taskList != nil) {
        [self setTitle:taskList.title];
        [self.tasksDataController setTaskList:taskList];
        [self.tableView reloadData];
    }
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    [self.tableView reloadData];
}

@end
