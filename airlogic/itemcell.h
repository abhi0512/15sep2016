//
//  itemcell.h
//  airlogic
//
//  Created by APPLE on 01/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface itemcell : UITableViewCell
{
    
}
@property(nonatomic, strong) IBOutlet UILabel *lbltripname;
@property (nonatomic, strong) IBOutlet UILabel *fromcity;
@property (nonatomic, strong) IBOutlet UILabel *tocity;
@property (nonatomic, strong) IBOutlet UILabel *lblotp;
@property(nonatomic,strong)IBOutlet UILabel *lblvolume;
@property(nonatomic,strong)IBOutlet UILabel *lbldate;
@property(nonatomic,strong)IBOutlet UILabel *lblstar;
@property(nonatomic,strong)IBOutlet UILabel *lbltodate;
@property(nonatomic,strong)IBOutlet UILabel *lblweight;
@property(nonatomic,strong)IBOutlet UILabel *lblsenderid;
@property(nonatomic,strong)IBOutlet UILabel *lbltripcost;
@property(nonatomic,strong)IBOutlet UIButton *btnpickup;
@property(nonatomic,strong)IBOutlet UIButton *btntransporting;
@property(nonatomic,strong)IBOutlet UIButton *btndeliver;
@property(nonatomic,strong)IBOutlet UIButton *btnpayment;
@property(nonatomic,strong)IBOutlet UIButton *btnapproved;
@property(nonatomic,strong)IBOutlet UIButton *btncompleted;
@property(nonatomic,strong)IBOutlet UIButton *btncancel;
@property(nonatomic,strong)IBOutlet UIImageView *imgprofile;
@property(nonatomic,strong)IBOutlet UILabel *lblpayment;
@property(nonatomic,strong)IBOutlet UILabel *lblcurrecy;
@property(nonatomic,strong)IBOutlet UILabel *lbl1;
@property(nonatomic,strong)IBOutlet UILabel *lbl2;
@property(nonatomic,strong)IBOutlet UILabel *lbl3;
@property(nonatomic,strong)IBOutlet UILabel *lbl4;
@property(nonatomic,strong)IBOutlet UILabel *lbl5;
@property(nonatomic,strong)IBOutlet UILabel *lblitemid;
@end
