//
//  DbHandler.m
//  Bible
//
//  Created by MaDdy on 19/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DbHandler.h"



@implementation DbHandler

static sqlite3 *database = nil;

#pragma mark - DB Setup Functions -

+(void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"see >>>%@",[paths objectAtIndex:0]);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DbName];
    NSLog(@"%@",writableDBPath);
    success = [fileManager fileExistsAtPath:writableDBPath];
     if (success) {
		NSLog(@"Database file already exist, so returning...");
        [DbHandler openDatabase];
		return;
	}
    
	NSLog(@"CREATING A NEW COPY OF THE DATABASE...");
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DbName];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
		//Some serious problem...
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    [DbHandler openDatabase];
}

+(NSString *) dataFilePath:(NSString *)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:path];
}

+(NSString *)GetAirportId:(NSString *)airportname
{
    
    NSString *result2;
    
    if (database != nil)
    {
        NSString *aname=[airportname stringByReplacingOccurrencesOfString:@"'" withString:@"##"];
        
        NSString *selectSql =[NSString stringWithFormat:@"select airport_id from airportmaster where (city_name||','||airport_name)='%@'",aname];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                result2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    
    return result2 ;
}

+(NSString *)GetId:(NSString *)strqry
{
    
    NSString *result2;
    
    if (database != nil)
    {
        NSString *selectSql =strqry;
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                result2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    
    return result2 ;
}



+(void)openDatabase
{
	NSString *dbpath = [DbHandler dataFilePath:DbName];
    
	if (sqlite3_open([dbpath UTF8String], &database) == SQLITE_OK)
	{
        NSLog(@"Databse opened");
    }
}
+(void)closeDatabase
{
    sqlite3_close(database);
}
+(BOOL)isDatabaseOpened
{
    return (database != nil);
}

+(NSMutableArray *)FetchCategory
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        NSString *selectSql =@"select * from category";
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *result=[NSMutableDictionary dictionary];
                
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"id"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"category"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] forKey:@"sum"];
                
                [result2 addObject:result];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error While Fetching  Data");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    //NSLog(@"%d",[result2 count]);
    
    return result2 ;
}



+(NSMutableArray *)FetchItemdetail
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        NSString *selectSql =@"select * from createitem";
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *result=[NSMutableDictionary dictionary];
                
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"id"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"fromcity"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] forKey:@"tocity"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] forKey:@"fromdate"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] forKey:@"todate"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] forKey:@"category"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] forKey:@"itemname"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] forKey:@"itemdesc"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] forKey:@"itemcost"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)] forKey:@"volume"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)] forKey:@"insurance"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)] forKey:@"commercial"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)] forKey:@"subcommercial"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)] forKey:@"mutual"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)] forKey:@"userid"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)] forKey:@"catid"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)] forKey:@"insuranceid"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)] forKey:@"zipcode"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)] forKey:@"charity"];
               [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)] forKey:@"tozipcode"];
                [result2 addObject:result];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error While Fetching  Data");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    //NSLog(@"%d",[result2 count]);
    
    return result2 ;
}


+(NSMutableArray *)ToAirport:(NSString *)airportname
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        NSString *selectSql =[NSString stringWithFormat:@"SELECT  city_name||','||replace(airport_name, '##', \"'\")as airport_name FROM airportmaster where country_name not in('%@') order by airport_name asc",airportname];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *winetype=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                [result2 addObject:[NSString stringWithFormat:@"%@", winetype]];
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    NSLog(@"%d",[result2 count]);
    
    return result2 ;
}

+(NSMutableArray *)FetchAirport:(NSString *)airportname
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        NSString *selectSql =[NSString stringWithFormat:@"SELECT city_name||','||replace( airport_name, '##', \"'\")as airport_name FROM airportmaster where country_name not in('%@') order by airport_name asc",airportname];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *winetype=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                [result2 addObject:[NSString stringWithFormat:@"%@", winetype]];
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    NSLog(@"%d",[result2 count]);
    
    return result2 ;
}

+(NSString *)FetchAirportcountry:(NSString *)airportname
{
    NSString *country;
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql =[NSString stringWithFormat:@"SELECT country_name FROM airportmaster where city_name||','||replace(airport_name, \"'\",'##')as airport_name='%@'",airportname];

        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                country=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return country;
}
+(NSMutableArray *)FetchCitydata:(NSString *)cntryname
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        NSString *selectSql =[NSString stringWithFormat:@"select (ct.city_name || ' , ' || cnt.country_name)as c from citymaster as ct join statemaster  as s on s.state_id=ct.state_id join countrymaster as cnt on cnt.country_id=s.countryid where cnt.country_name not in ('%@')",cntryname];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *winetype=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                [result2 addObject:[NSString stringWithFormat:@"%@", winetype]];
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    NSLog(@"%d",[result2 count]);
    
    return result2 ;
}

+(NSMutableArray *)FetchToCity:(NSString *)cntryname
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        NSString *selectSql =[NSString stringWithFormat:@"select (ct.city_name || ' , ' || cnt.country_name)as c from citymaster as ct join statemaster  as s on s.state_id=ct.state_id join countrymaster as cnt on cnt.country_id=s.countryid where cnt.country_name not in ('%@')",cntryname];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *winetype=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                [result2 addObject:[NSString stringWithFormat:@"%@", winetype]];
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    NSLog(@"%d",[result2 count]);
    
    return result2 ;
}

+(NSMutableArray *)Fetchcancelpolicy
{

    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        NSString *selectSql =@"select * from cancellation";
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *result=[NSMutableDictionary dictionary];
                
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"id"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"type"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] forKey:@"description"];
                
                [result2 addObject:result];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error While Fetching  Data");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    //NSLog(@"%d",[result2 count]);
    
    return result2 ;

}


+(NSMutableArray *)FetchCountry
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        NSString *selectSql =[NSString stringWithFormat:@"SELECT country_name from countrymaster"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *winetype=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                [result2 addObject:[NSString stringWithFormat:@"%@", winetype]];
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    NSLog(@"%d",[result2 count]);
    
    return result2 ;
}

+(NSMutableArray *)FetchState:(NSString *)cntryid
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        NSString *selectSql =[NSString stringWithFormat:@"SELECT state_name from statemaster where countryid='%@'",cntryid];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *winetype=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                [result2 addObject:[NSString stringWithFormat:@"%@", winetype]];
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    NSLog(@"%d",[result2 count]);
    
    return result2 ;
}

+(NSMutableArray *)FetchCity:(NSString *)stateid
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        NSString *selectSql =[NSString stringWithFormat:@"SELECT city_name from citymaster where state_id='%@'",stateid];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *winetype=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                [result2 addObject:[NSString stringWithFormat:@"%@", winetype]];
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    NSLog(@"%d",[result2 count]);
    
    return result2 ;
}



+(BOOL)deleteDatafromtable:(NSString *)query
{
    BOOL  result = NO;
    if (database != nil)
    {
        NSString *selectSql = query;
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Data deleted from table");
                result = YES;
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
        
    }
    else
    {
        NSLog(@"Database not opening");
    }
    return result;
}

+(BOOL)Insertuser:(NSString *)address city:(NSString *)_city country:(NSString *)_country emailid:(NSString *)_emailid firstname:(NSString *)_firstname gender:(NSString *)_gender uid:(NSString *)_id lastname:(NSString *)_lastname phone:(NSString *)_phone profilepic:(NSString *)_profilepic state:(NSString *)_state status:(NSString *)_status thumbprofilepic:(NSString *)_thumbprofilepic usertype:(NSString *)_usertype zip:(NSString *)_zip push:(NSString *)_push sound:(NSString *)_sound promocode:(NSString *)_promocode currency:(NSString *)_currency
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql = [NSString stringWithFormat:@"INSERT INTO usermaster (address,city,country,emailid,firstname,gender,id,lastname,phone,profilepic,state,status,thumbprofilepic,usertype,zip,pushnotification,sound,promocode,currency)values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",address,_city,_country,_emailid,_firstname,_gender,_id,_lastname,_phone,_profilepic,_state,_status,_thumbprofilepic,_usertype,_zip,_push,_sound,_promocode,_currency];
        
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user inserted successful");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}


+(BOOL)Insertairport:(NSString *)airport_address aid:(NSString *)_airport_id airport_name:(NSString *)_airport_name azip:(NSString *)_airport_zipcode city:(NSString *)_cityid cityname:(NSString *)_cityname countryid:(NSString *)_countryi_id country:(NSString *)_country_name stateid:(NSString *)_state_id state:(NSString *)_state_name
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        NSString *airport= [_airport_name stringByReplacingOccurrencesOfString: @"'" withString:@"##"];
        
        selectSql = [NSString stringWithFormat:@"INSERT INTO airportmaster (airport_address,airport_id,airport_name,airport_zipcode,city_id,city_name,country_id,country_name,state_id,state_name)values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",airport_address,_airport_id,airport,_airport_zipcode,_cityid,_cityname,_countryi_id,_country_name,_state_id,_state_name];
        
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"airport inserted successful");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}






+(BOOL)updateuser:(NSString *)address city:(NSString *)_city country:(NSString *)_country emailid:(NSString *)_emailid firstname:(NSString *)_firstname gender:(NSString *)_gender lastname:(NSString *)_lastname phone:(NSString *)_phone state:(NSString *)_state status:(NSString *)_status usertype:(NSString *)_usertype zip:(NSString *)_zip userid:(NSString *)_id thumbprofilepic:(NSString *)_thumbprofilepic
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
    
        selectSql= [NSString stringWithFormat:@"update usermaster set address='%@',city='%@',country='%@',emailid='%@',firstname='%@',gender='%@',lastname='%@',phone='%@',state='%@',status='%@',usertype='%@',zip='%@',thumbprofilepic='%@' where id='%@'",address,_city,_country,_emailid,_firstname,_gender,_lastname,_phone,_state,_status,_usertype,_zip,_thumbprofilepic,_id];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}

+(BOOL)updatenotificationsetting:(NSString *)push sound:(NSString *)_sound userid:(NSString *)_id
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql= [NSString stringWithFormat:@"update usermaster set pushnotification='%@',sound='%@' where id='%@'",push,_sound,_id];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}


+(BOOL)updatepromocode:(NSString *)phone userid:(NSString *)_id promocode:(NSString*)_promocode
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql= [NSString stringWithFormat:@"update usermaster set phone='%@',promocode='%@' where id='%@'",phone,_promocode,_id];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}


+(BOOL)updateusephone:(NSString *)phone userid:(NSString *)_id
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql= [NSString stringWithFormat:@"update usermaster set phone='%@' where id='%@'",phone,_id];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}


+(BOOL)updateusertype:(NSString *)usertype userid:(NSString *)_id
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql= [NSString stringWithFormat:@"update usermaster set usertype='%@' where id='%@'",usertype,_id];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}

+(BOOL)InsertItem:(NSString *)fromcity tocity:(NSString *)_tocity fromdt:(NSString *)_fromdt todate:(NSString *)_todate userid:(NSString *)_id zipcode:(NSString *)_zipcode charity:(NSString *)_charity tozipcode:(NSString *)_tozipcode
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql = [NSString stringWithFormat:@"INSERT INTO createitem (fromcity,tocity,fromdate,todate,userid,category,itemname,itemdesc,volume,insurance,commercial,subcommercial,mutual,catid,insuranceid,itemcost,zipcode,charity,tozipcode)values('%@','%@','%@','%@','%@','','','','','','','','','','','','%@','','%@')",fromcity,_tocity,_fromdt,_todate,_id,_zipcode,_tozipcode];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user inserted successful");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}

+(BOOL)UpdateItemCategory:(NSString *)catname categoryid:(NSString *)catid
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql = [NSString stringWithFormat:@"update createitem set category='%@',catid='%@'",catname,catid];
        
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"updated successful");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}

+(BOOL)UpdateItemdetail:(NSString *)itemname itemcost:(NSString *)_itemcost itemdesc:(NSString *)_itemdesc
{
    bool result = NO;
  
    NSString *newVar =[_itemdesc stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql = [NSString stringWithFormat:@"update createitem set itemname='%@',itemcost='%@',itemdesc='%@'",itemname,_itemcost,newVar];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"updated successful");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}

+(BOOL)UpdateItemvolume:(NSString *)volume
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql = [NSString stringWithFormat:@"update createitem set volume='%@'",volume];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"updated successful");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}

+(BOOL)UpdateItemInsurance:(NSString *)insurance insid:(NSString*)_insid
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql = [NSString stringWithFormat:@"update createitem set insurance='%@',insuranceid='%@'",insurance,_insid];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"updated successful");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}

+(BOOL)UpdateItemService:(NSString *)commercial subcommercial:(NSString*)_sub mutual:(NSString *)_mutual charity:(NSString *)_charity
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql = [NSString stringWithFormat:@"update createitem set commercial='%@',subcommercial='%@', mutual='%@', charity='%@'",commercial,_sub,_mutual,_charity];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"updated successful");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}


+(BOOL)InsertuserCategory:(NSString *)catname value:(NSString *)sum catid:(NSString *)_id date:(NSString *)_date
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql = [NSString stringWithFormat:@"INSERT INTO usersavecategory (categoryid,sum,date,catid)values('%@' ,'%@','%@','%@')",catname,sum,_date,_id];
        
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"usersavecategory inserted successful");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}



//+(BOOL)InsertServiceProvider:(NSString *)key value:(NSString *)value
//{
//    bool result = NO;
//    
//    if (database != nil)
//    {
//        NSString *selectSql;
//        sqlite3_stmt *statement1;
//        
//        selectSql = [NSString stringWithFormat:@"INSERT INTO service (carkey,carvalue)values('%@' ,'%@')",key,value];
//        
//        
//        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
//        {
//            if (sqlite3_step(statement1) == SQLITE_DONE)
//            {
//                result = YES;
//                NSLog(@"service inserted successful");
//            }
//            sqlite3_finalize(statement1);
//        }
//        else
//        {
//            NSLog(@"Sql Preparing Error");
//        }
//    }
//    return result;
//}



+(NSMutableArray *)Fetchuserdetail:(NSString *)userid
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        NSString *selectSql=[NSString stringWithFormat:@"select * from usermaster where id='%@'",userid];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *result=[NSMutableDictionary dictionary];
                
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"tid"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"address"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] forKey:@"city"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] forKey:@"country"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] forKey:@"emailid"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] forKey:@"firstname"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] forKey:@"gender"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] forKey:@"id"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] forKey:@"lastname"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)] forKey:@"phone"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)] forKey:@"profilepic"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11)] forKey:@"state"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)] forKey:@"status"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)] forKey:@"thumbprofilepic"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)] forKey:@"usertype"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)] forKey:@"zip"];
                
                [result2 addObject:result];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error While Fetching  Data");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    //NSLog(@"%d",[result2 count]);
    
    return result2 ;
}


+(NSString *)checkuserexist
{
    NSString *userid;
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select id from usermaster"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                userid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return userid;
}


@end
