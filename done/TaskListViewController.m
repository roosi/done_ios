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

@interface TaskListViewController ()

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
    
    self.dataController = [TaskListsDataController sharedController];
    self.title = [self.dataController objectInTaskListsAtIndex:[self.dataController selectedTaskList]].title;
    
    self.tasks = [[NSMutableArray alloc] init];
    [self loadTestData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) loadTestData
{
    Task *item1 = [[Task alloc] init];
    item1.title = @"Lorem ipsum";
    item1.notes = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi vitae fringilla lectus. Phasellus consectetur ultricies tellus, a luctus lectus tempor sit amet. Maecenas condimentum lobortis congue.";
    [self.tasks addObject:item1];
    
    Task *item2 = [[Task alloc] init];
    item2.title = @"Pellentesque elementum";
    item2.notes = @"Cras pellentesque eleifend faucibus. Praesent euismod rutrum lorem non imperdiet. Etiam vel sapien arcu. In ullamcorper facilisis justo quis tincidunt.";
    [self.tasks addObject:item2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Task *item = [self.tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.notes;
    
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
        TaskListsPickerController *destinationViewController = [segue destinationViewController];
        destinationViewController.delegate = self;
    }
}

-(void)taskListPickerController:(TaskListsPickerController *)picker didFinishPickingTaskList:(TaskList *)taskList
{
    [self setTitle:taskList.title];
    
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion: nil];
}

@end
