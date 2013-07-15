//
//  RestaurantsViewController.m
//  gatrozgz
//
//  Created by Daniel Vela on 6/25/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "RestaurantsViewController.h"
#import "RestaurantCell.h"
#import "RestaurantDetailViewController.h"

@interface RestaurantsViewController ()

@property (nonatomic, strong) NSArray* array;

@end

@implementation RestaurantsViewController

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
    
    self.array = @[
                   @{@"imageUrl":@"http://livedesignonline.com/site-files/livedesignonline.com/files/archive/blog.livedesignonline.com/briefingroom/wp-content/uploads/2010/05/restaurant-t-buenos-aires.jpg",
                     @"title":@"Restaurante cola cola",
                     @"description":@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras sit amet faucibus ante, vitae consectetur diam. Pellentesque elementum, nisl quis ultrices pretium, nisl quam gravida odio, vitae placerat risus tortor tempor ipsum. Praesent scelerisque condimentum lacus. Pellentesque venenatis pharetra arcu, nec venenatis orci ornare non. Ut commodo rutrum nisl. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec euismod nunc eu vulputate consectetur. Nullam nec eros ac ligula fermentum adipiscing. Sed at nibh risus. Nulla facilisi. Donec vel rhoncus enim. Etiam lobortis accumsan pellentesque. Donec iaculis urna nec interdum placerat. Suspendisse ornare tristique sollicitudin.",
                     @"address":@"Plaza España, 4",
                     @"longitude":@"-0.863471",
                     @"latitude":@"41.6499120"},
                   @{@"imageUrl":@"http://eofdreams.com/data_images/dreams/restaurant/restaurant-07.jpg",
                     @"title":@"La bola de queso",
                     @"description":@"Proin venenatis ultricies laoreet. Vestibulum auctor commodo velit. Nam arcu diam, hendrerit a nisi ac, sagittis condimentum sem. Etiam at enim id nunc ullamcorper tempor eget sed purus. Morbi aliquet iaculis tempor. Nam metus felis, ornare eget purus a, ultrices imperdiet libero. Nullam turpis risus, molestie ac placerat sit amet, venenatis vitae urna. Curabitur a tincidunt mi. Phasellus lacinia hendrerit erat sed blandit. Curabitur feugiat tristique accumsan. Maecenas varius lorem sed viverra congue. Suspendisse a aliquet neque. Sed auctor dolor malesuada egestas luctus. Nullam luctus accumsan diam in semper. Suspendisse potenti.",
                     @"address":@"Miguel Servet, 44",
                     @"longitude":@"-0.877780",
                     @"latitude":@"41.651242"},
                   @{@"imageUrl":@"http://3.bp.blogspot.com/_E45GAZrJ4h4/SjRyAX93k_I/AAAAAAAAAAM/t7rl33qfVa4/s1600-h/gertrudes-colorado-springs-375x281.jpg",
                     @"title":@"LA Trattoria",
                     @"description":@"Donec hendrerit consequat ligula ut accumsan. Phasellus accumsan turpis a sem vulputate, quis venenatis metus facilisis. Interdum et malesuada fames ac ante ipsum primis in faucibus. Mauris ac justo sed nibh sodales feugiat tincidunt vitae leo. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Fusce cursus porta lectus scelerisque mollis. Pellentesque consectetur at eros et dictum. Aenean adipiscing egestas ultricies. Morbi cursus tellus urna, eu cursus risus consequat non. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Maecenas bibendum mi eros, nec feugiat purus ultrices nec. Fusce id tortor vel lorem tempus placerat nec at est. Aliquam lacus quam, mattis sit amet interdum at, semper sit amet velit. Etiam vulputate dignissim mollis. Cras semper porttitor sem dictum placerat.",
                     @"address":@"Gran Vía, 8",
                     @"longitude":@"-0.881661",
                     @"latitude":@"41.644714"},
                   @{@"imageUrl":@"http://cdn5.business-opportunities.biz/wp-content/uploads/2013/01/restaurant.jpg",
                     @"title":@"La ruta Maya",
                     @"description":@"Phasellus venenatis mattis leo, a rhoncus augue consequat quis. Integer a venenatis magna. Curabitur egestas lacus at justo facilisis dignissim. Nullam a tempor lectus. Nunc vitae tortor interdum nibh tincidunt convallis. Donec vitae urna quis odio fermentum rutrum. Nulla blandit, felis eu lacinia condimentum, felis orci scelerisque augue, quis blandit neque dui ac eros. In auctor magna sit amet risus auctor facilisis.",
                     @"address":@"Paseo Independencia, 17",
                     @"longitude":@"-0.889492",
                     @"latitude":@"41.653496"}
                   ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RestaurantCell";
    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary* object = self.array[indexPath.row];
    cell.title.text = object[@"title"];
    cell.description.text = object[@"description"];
    [cell.image setImageWithURL:[NSURL URLWithString:object[@"imageUrl"]]
               placeholderImage:[UIImage imageNamed:@"copa_placeholder"]];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RestaurantDetail"]) {
        UITableViewCell* cell = (UITableViewCell*)sender;
        RestaurantDetailViewController* controller =
        (RestaurantDetailViewController*)segue.destinationViewController;
        NSIndexPath* index = [self.tableView indexPathForCell:cell];
        controller.object = self.array[index.row];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
