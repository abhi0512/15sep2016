//
//  faqdetailvc.h
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface faqdetailvc : UIViewController<UITextViewDelegate>
{
    IBOutlet UITextView *txtdesc;
}

@property(nonatomic,strong)NSString *pagetitle;
@property(nonatomic,strong)NSString *pagedesc;
@end
