//
//  flybeehomeviewcellTableViewCell.h
//  airlogic
//
//  Created by APPLE on 15/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface flybeehomeviewcellTableViewCell : UITableViewCell
{
    
}
@property(nonatomic,strong)IBOutlet UILabel *lbltripname;
@property(nonatomic,strong)IBOutlet UILabel *lblto;

@property(nonatomic,strong)IBOutlet UILabel *fromcity;
@property(nonatomic,strong)IBOutlet UILabel *tocity;
@property(nonatomic,strong)IBOutlet UILabel *lblvolume;
@property(nonatomic,strong)IBOutlet UILabel *lbldate;
@property(nonatomic,strong)IBOutlet UILabel *lbltodate;
@property(nonatomic,strong)IBOutlet UILabel *lblweight;
@property(nonatomic,strong)IBOutlet UILabel *lblitemprice;
@property(nonatomic,strong)IBOutlet UILabel *lblcur1;
@property(nonatomic,strong)IBOutlet UILabel *lblcur2;
@property(nonatomic,strong)IBOutlet UILabel *lblid;
@property(nonatomic,strong)IBOutlet UILabel *lblrating;
@property(nonatomic,strong)IBOutlet UIImageView *imgprofile;
@property(nonatomic,strong)IBOutlet UIImageView *imgstar;
@end
