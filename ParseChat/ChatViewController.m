//
//  ChatViewController.m
//  ParseChat
//
//  Created by Raghav Sreeram on 6/19/21.
//

#import "ChatViewController.h"
#import "Parse/Parse.h"
#import "ChatCellTableViewCell.h"


@interface ChatViewController ()
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfMessages;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (IBAction)onSend:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_fbu2020"];
    chatMessage[@"text"] = self.messageTextField.text;
    chatMessage[@"user"] = PFUser.currentUser;
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            self.messageTextField.text = @"";
            [self.arrayOfMessages insertObject:chatMessage atIndex:0];
            [self.tableView reloadData];
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
}

-(void) refreshData {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Message_fbu2020"];
    [query includeKey:@"user"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];

    // fetch data asynchronously
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects != nil) {
            // do something with the array of object returned by the call
            self.arrayOfMessages = objects;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.tableView reloadData];
        
    }];
    
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    NSDictionary *message = self.arrayOfMessages[indexPath.row];
    cell.messageText.text = message[@"text"];
    PFUser *user = message[@"user"];
    NSLog(@"%@", user.username);
    if (user != nil) {
        
        cell.username.text = user.username;
    } else {
        // No user found, set default username
        cell.username.text = @"🤖";
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfMessages.count;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
