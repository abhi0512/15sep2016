//
//  homeviewcell.h
//  airlogic
//
//  Created by APPLE on 02/01/16.
//  Copyright (c) 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface homeviewcell : UITableViewCell
{
    
}
@property(nonatomic, strong) IBOutlet UILabel *lbltripname;
@property (nonatomic, strong) IBOutlet UILabel *fromcity;
@property (nonatomic, strong) IBOutlet UILabel *tocity;
@property(nonatomic,strong)IBOutlet UILabel *lblvolume;
@property(nonatomic,strong)IBOutlet UILabel *lbldate;
@property(nonatomic,strong)IBOutlet UILabel *lblweight;
@property(nonatomic,strong)IBOutlet UILabel *lblmonth;
@property(nonatomic,strong)IBOutlet UILabel *lblticket;
@property(nonatomic,strong)IBOutlet UIImageView *imgprofile;

@property(nonatomic,strong)IBOutlet UIImageView *imgstar;
@property(nonatomic,strong)IBOutlet UILabel *lblflightname;
@property(nonatomic,strong)IBOutlet UIImageView *imgticket;
@property(nonatomic,strong)IBOutlet UILabel *lblrating;
@end
