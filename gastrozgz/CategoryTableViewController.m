//
//  CategoryTableViewController.m
//  gastrozgz
//
//  Created by Daniel Vela on 10/6/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "OSDatabase.h"
#import "CategoryCell.h"
#import "Categorias.h"

@interface CategoryTableViewController ()

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CategoryTableViewController

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

    self.title = NSLocalizedString(@"Establecimientos", @"");

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count =
    [[[self fetchedResultsController] sections] count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    NSFetchedResultsController *fetchController =
    [self fetchedResultsController];
    NSArray *sections = fetchController.sections;
    if(sections.count > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    float rows = (float)numberOfRows / 2.0f;
    numberOfRows = ceilf(rows);
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSUInteger index = indexPath.row * 2;
    NSIndexPath* indexPath2 = [NSIndexPath indexPathForRow:index
                                                 inSection:indexPath.section];
    Categorias* categoria = [self.fetchedResultsController
                             objectAtIndexPath:indexPath2];
    [cell.leftButton setTitle:categoria.categoria
                     forState:UIControlStateNormal];
    cell.leftButton.tag = index;
    NSFetchedResultsController *fetchController =
    [self fetchedResultsController];
    NSArray *sections = fetchController.sections;
    id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:indexPath.section];
    NSInteger numberOfRows = [sectionInfo numberOfObjects];
    if (numberOfRows > index + 1) {
        indexPath2 = [NSIndexPath indexPathForRow:index + 1
                                        inSection:indexPath.section];
        categoria = [self.fetchedResultsController
                                 objectAtIndexPath:indexPath2];
        [cell.rightButton setTitle:categoria.categoria
                         forState:UIControlStateNormal];
        cell.rightButton.hidden = NO;
        cell.rightButton.tag = index + 1;
    } else {
        cell.rightButton.hidden = YES;
    }
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - Fetched result controller for search

#pragma mark - Fetched result

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    
    
    NSManagedObjectContext* managedObjectContext= [[OSDatabase defaultDatabase]
                                                   managedObjectContext];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"categoria"
                                                               ascending:YES]]; // your sort descriptors here
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *callEntity = [NSEntityDescription entityForName:
                                       @"Categorias"
                                                  inManagedObjectContext:
                                       managedObjectContext];
    [fetchRequest setEntity:callEntity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:managedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIButton* button = (UIButton*)sender;
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:button.tag
                                                inSection:0];
    Categorias* categoria = [self.fetchedResultsController
                             objectAtIndexPath:indexPath];
    
    for (Categorias* cat in self.fetchedResultsController.fetchedObjects) {
        cat.selected = @(NO);
    }
    categoria.selected = @(YES);
    
    [[OSDatabase defaultDatabase] save];
}

@end
