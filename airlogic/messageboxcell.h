//
//  messageboxcell.h
//  airlogic
//
//  Created by APPLE on 04/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface messageboxcell : UITableViewCell
{
    
}
@property(nonatomic, strong)  IBOutlet UILabel *lbltripuser;
@property (nonatomic, strong) IBOutlet UILabel *lblitemuser;
@property (nonatomic, strong) IBOutlet UILabel *lblname;
@property(nonatomic,strong)IBOutlet UIImageView *imgprofile;
@end
