//
//  TaskListViewController.m
//  done
//
//  Created by Jouni Nurmi on 08/02/14.
//  Copyright (c) 2014 Jouni Nurmi. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskListsPickerController.h"
#import "TaskListsDataController.h"
#import "TasksDataController.h"
#import "TaskUtils.h"

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLServiceTasks.h"
#import "GTLQueryTasks.h"
#import "GTLTasksTaskLists.h"
#import "GTLTasksTaskList.h"
#import "GTLTasksTask.h"

@interface TaskListViewController ()
@property NSDateFormatter *dateFormatter;
@property GTMOAuth2Authentication *auth;
@end

@implementation TaskListViewController

static NSString *const kKeychainItemName = @"doneToken";

NSString *kClientID = @"552948890600.apps.googleusercontent.com";     // pre-assigned by service
NSString *kClientSecret = @"H_AA4PQQvKtmcHYubTd5SEHi"; // pre-assigned by service

NSString *scope = @"https://www.googleapis.com/auth/tasks"; // scope for Google+ API

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
    
    self.title = @"";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                              clientID:kClientID
                                                          clientSecret:kClientSecret];
    
    if (self.auth.canAuthorize == NO) {
        [self signIn];
    }
    else {
        [self setAuth];
    }
}

-(void)signIn
{
    GTMOAuth2ViewControllerTouch *viewController;
    viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:scope
                                                                clientID:kClientID
                                                            clientSecret:kClientSecret
                                                        keychainItemName:kKeychainItemName
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    //[[self navigationController] pushViewController:viewController animated:YES];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)signOut
{
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
    
    [GTMOAuth2ViewControllerTouch revokeTokenForGoogleAuthentication:self.auth];
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
      error:(NSError *)error {
    
    [self.parentViewController dismissViewControllerAnimated:NO completion:nil];
    [viewController removeFromParentViewController];
    
    if (error != nil) {
        // Authentication failed
        [self signIn];
    }
    else {
        // Authentication succeeded
        self.auth = auth;
    }
}

-(void)setAuth
{
    self.dataController = [TaskListsDataController sharedController];
    self.tasksDataController = [TasksDataController sharedController];
    [self.dataController setAuth:self.auth];
    [self.tasksDataController setAuth:self.auth];
    
    [self.dataController addObserver:self forKeyPath:@"taskLists" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
    [self.dataController addObserver:self forKeyPath:@"selectedTaskList" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
    [self.tasksDataController addObserver:self forKeyPath:@"tasks" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"taskLists"]) {
        
    }
    else if ([keyPath isEqualToString:@"selectedTaskList"])
    {
        [self updateUI];
    }
    else if ([keyPath isEqualToString:@"tasks"])
    {
        [self.tableView reloadData];
    }
}

-(void)updateUI
{
    GTLTasksTaskList *list = [self.dataController objectInTaskListsAtIndex:[self.dataController selectedTaskList]];
    self.title = list.title;
    [self.tasksDataController setTaskList:list];
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
        GTLTasksTaskList *list = [self.dataController objectInTaskListsAtIndex:0];
        [self.tasksDataController setTaskList:list];
        self.title = list.title;
    
        [self.tableView reloadData];
    }
}

- (IBAction)createNewListTapped:(id)sender {
    GTLTasksTaskList *list = [[GTLTasksTaskList alloc]init];
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
    GTLTasksTask *item = [self.tasksDataController objectInTasksAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:item.due.date];
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
        GTLTasksTask *item = [[GTLTasksTask alloc] init];
        
        //TODO
        //item.creationDate = [NSDate date];
        //item.dueDate = item.creationDate;
        
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

-(void)taskListPickerController:(TaskListsPickerController *)picker didFinishPickingTaskList:(GTLTasksTaskList *)taskList
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
