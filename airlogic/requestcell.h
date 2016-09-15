//
//  requestcell.h
//  airlogic
//
//  Created by APPLE on 24/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface requestcell : UITableViewCell
{
    
}
@property(nonatomic, strong) IBOutlet UILabel *lbltripname;
@property (nonatomic, strong) IBOutlet UILabel *lblusername;
@property(nonatomic, strong) IBOutlet UILabel *lblid;
@property (nonatomic, strong) IBOutlet UILabel *lbl;
@property (nonatomic, strong) IBOutlet UILabel *lblstatus;
@property(nonatomic,strong)IBOutlet UILabel *lbldate;
@property(nonatomic,strong)IBOutlet UITextView *txtmesage;
@property(nonatomic,strong)IBOutlet UIImageView *imgprofile ,*imgstar,*imgaircraft;
@property(nonatomic,strong)IBOutlet UIButton *btncancel;
@property(nonatomic,strong)IBOutlet UILabel *lblmonth ,*lblstar,*lblflydate;
@end
