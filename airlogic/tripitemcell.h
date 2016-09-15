//
//  tripitemcell.h
//  airlogic
//
//  Created by APPLE on 29/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tripitemcell : UITableViewCell
{
    
}
@property(nonatomic, strong) IBOutlet UILabel *lbltripname;
@property (nonatomic, strong) IBOutlet UILabel *fromcity;
@property (nonatomic, strong) IBOutlet UILabel *tocity;
@property(nonatomic,strong)IBOutlet UILabel *lblvolume;
@property(nonatomic,strong)IBOutlet UILabel *lbldate;
@property(nonatomic,strong)IBOutlet UILabel *lbltodate;
@property(nonatomic,strong)IBOutlet UILabel *lblweight;
@property(nonatomic,strong)IBOutlet UILabel *lblstar;
@property(nonatomic,strong)IBOutlet UILabel *lblservice;
@property(nonatomic,strong)IBOutlet UILabel *lblcategory;
@property(nonatomic,strong)IBOutlet UILabel *lbltripid;
@property(nonatomic,strong)IBOutlet UILabel *lbltripcost;
@property(nonatomic,strong)IBOutlet UILabel *lblairlogiqcost;
@property(nonatomic,strong)IBOutlet UILabel *lblflightname;
@property(nonatomic,strong)IBOutlet UILabel *lblflybeecost;
@property(nonatomic,strong)IBOutlet UILabel *lblmsg;
@property(nonatomic,strong)IBOutlet UIButton *btnshow;
@property(nonatomic,strong)IBOutlet UIButton *btnpickup;
@property(nonatomic,strong)IBOutlet UIButton *btntransporting;
@property(nonatomic,strong)IBOutlet UIButton *btndeliver;
@property(nonatomic,strong)IBOutlet UIButton *btnpayment;
@property(nonatomic,strong)IBOutlet UIButton *btnapproved;
@property(nonatomic,strong)IBOutlet UIButton *btncompleted;
@property(nonatomic,strong)IBOutlet UIImageView *imgprofile;
@property(nonatomic,strong)IBOutlet UIButton *btncancel;
@property(nonatomic,strong)IBOutlet UILabel *lbltrid;

@property(nonatomic,strong)IBOutlet UILabel *lbl1;
@property(nonatomic,strong) IBOutlet UILabel *lbl2;
@property(nonatomic,strong) IBOutlet UILabel *lbl3;
@property(nonatomic,strong)IBOutlet UILabel *lbl4;
@property(nonatomic,strong)IBOutlet UILabel *lbl5;
@property(nonatomic,strong)IBOutlet UILabel *lbl6;
@property(nonatomic,strong)IBOutlet UILabel *lbl7;


@end
