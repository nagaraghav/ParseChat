//
//  ChatCellTableViewCell.h
//  ParseChat
//
//  Created by Raghav Sreeram on 6/19/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *messageText;

@end

NS_ASSUME_NONNULL_END
