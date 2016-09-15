//
//  DbHandler.h
//  Bible
//
//  Created by MaDdy on 19/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define DbName @"dbairlogiq.sqlite"

@interface DbHandler : NSObject {
    
}

+(void)createEditableCopyOfDatabaseIfNeeded;
+(NSString *) dataFilePath:(NSString *)path;
+(void)openDatabase;
+(void)closeDatabase;
+(BOOL)isDatabaseOpened;
+(BOOL)deleteDatafromtable:(NSString *)query;
+(BOOL)InsertCategory:(NSString *)catname value:(NSString *)sum;
+(NSMutableArray *)FetchCategory;
+(BOOL)UpdateCategory:(NSString *)catname value:(NSString *)sum _id:(NSString *)sid;
+(BOOL)InsertuserCategory:(NSString *)catname value:(NSString *)sum catid:(NSString *)_id date:(NSString *)_date;
+(BOOL)updatenotificationsetting:(NSString *)push sound:(NSString *)_sound userid:(NSString *)_id;
+(BOOL)Insertuser:(NSString *)address city:(NSString *)_city country:(NSString *)_country emailid:(NSString *)_emailid firstname:(NSString *)_firstname gender:(NSString *)_gender uid:(NSString *)_id lastname:(NSString *)_lastname phone:(NSString *)_phone profilepic:(NSString *)_profilepic state:(NSString *)_state status:(NSString *)_status thumbprofilepic:(NSString *)_thumbprofilepic usertype:(NSString *)_usertype zip:(NSString *)_zip push:(NSString *)_push sound:(NSString *)_sound promocode:(NSString *)_promocode;
+(BOOL)Insertairport:(NSString *)airport_address aid:(NSString *)_airport_id airport_name:(NSString *)_airport_name azip:(NSString *)_airport_zipcode city:(NSString *)_cityid cityname:(NSString *)_cityname countryid:(NSString *)_countryi_id country:(NSString *)_country_name stateid:(NSString *)_state_id state:(NSString *)_state_name;
+(BOOL)updatepromocode:(NSString *)phone userid:(NSString *)_id promocode:(NSString*)_promocode;
+(BOOL)updateusephone:(NSString *)phone userid:(NSString *)_id;
+(NSString *)checkuserexist;
+(NSMutableArray *)Fetchuserdetail:(NSString *)userid;
+(NSMutableArray *)FetchAirport:(NSString *)airportname;
+(NSMutableArray *)ToAirport:(NSString *)airportname;
+(NSString *)GetAirportId:(NSString *)airportname;
+(NSMutableArray *)FetchCountry;
+(NSMutableArray *)Fetchcancelpolicy;
+(NSMutableArray *)FetchState:(NSString *)cntryid;
+(NSMutableArray *)FetchCity:(NSString *)stateid;
+(NSString *)GetId:(NSString *)strqry;
+(NSString *)FetchAirportcountry:(NSString *)airportname;
+(NSMutableArray *)FetchCitydata :(NSString *)cntryname;
+(BOOL)updateuser:(NSString *)address city:(NSString *)_city country:(NSString *)_country emailid:(NSString *)_emailid firstname:(NSString *)_firstname gender:(NSString *)_gender lastname:(NSString *)_lastname phone:(NSString *)_phone state:(NSString *)_state status:(NSString *)_status usertype:(NSString *)_usertype zip:(NSString *)_zip userid:(NSString *)_id thumbprofilepic:(NSString *)_thumbprofilepic;
+(BOOL)updateusertype:(NSString *)usertype userid:(NSString *)_id;
+(BOOL)InsertItem:(NSString *)fromcity tocity:(NSString *)_tocity fromdt:(NSString *)_fromdt todate:(NSString *)_todate userid:(NSString *)_id zipcode:(NSString *)_zipcode charity:(NSString *)_charity tozipcode:(NSString *)_tozipcode;
+(BOOL)UpdateItemCategory:(NSString *)catname categoryid:(NSString *)catid;
+(NSMutableArray *)FetchItemdetail;
+(BOOL)UpdateItemdetail:(NSString *)itemname itemcost:(NSString *)_itemcost itemdesc:(NSString *)_itemdesc;
+(BOOL)UpdateItemvolume:(NSString *)volume;
+(BOOL)UpdateItemInsurance:(NSString *)insurance insid:(NSString*)_insid;
+(BOOL)UpdateItemService:(NSString *)commercial subcommercial:(NSString*)_sub mutual:(NSString *)_mutual charity:(NSString *)_charity;
+(NSMutableArray *)FetchToCity:(NSString *)cntryname;
@end
