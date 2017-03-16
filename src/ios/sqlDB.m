//
//  sqlDB Implementation File
//  sqlDB Phonegap/Cordova Plugin
//
//  Created by Rahul on 4/14/14.
//
//

#import "sqlDB.h"

@implementation sqlDB


-(void)sendPluginResponse:(NSInteger*)code msg:(NSString*)msg err:(BOOL)error callBackID:(NSString*)cid
{
	CDVPluginResult *result = nil;
	NSMutableDictionary *response = [NSMutableDictionary dictionaryWithCapacity:2];
	[response setObject:[NSNumber numberWithUnsignedInteger:code] forKey:@"code"];
	[response setObject:msg forKey:@"message"];
	if(error){
		result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsDictionary:response];
	} else {
		result =  [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:response];
	}
	[self.commandDelegate sendPluginResult:result callbackId:cid];
}


-(void)copyDb:(int)location source:(NSString*)src db:(NSString*)dbname callBackID:(NSString*)cid
{
	
	// NSLog(@"[sqlDB] documentsDirectory = %@",documentsDirectory);
	// NSLog(@"[sqlDB] libraryDirectory = %@",libraryDirectory);
	NSError *error = nil;
	fileManager = [NSFileManager defaultManager];
	
	if (location == 2) {
		//set Document as default target directory
		documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		dbPath = [documentsDirectory stringByAppendingPathComponent:dbname];
	} else if(location == 1) {
		//set Library as default target directory
		libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		dbPath = [libraryDirectory stringByAppendingPathComponent:dbname];
	} else {
		//set Library/LocalDatabase as default target directory and disable iCloud backup
		libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *nosync = [libraryDirectory stringByAppendingPathComponent:@"LocalDatabase"];
		if ([fileManager fileExistsAtPath:nosync]) {
			dbPath = [nosync stringByAppendingPathComponent:dbname];
		} else {
			if ([fileManager createDirectoryAtPath: nosync withIntermediateDirectories:NO attributes: nil error:&error])
			{
				NSURL *nosyncURL = [ NSURL fileURLWithPath: nosync];
				if (![nosyncURL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error])
				{
					NSLog(@"Error Setting No Backup Flag: %@", error);
					NSLog(@"Ingnoring Error and Copying DB");
				}
				NSLog(@"No Backup Path: %@", nosync);
				dbPath = [nosync stringByAppendingPathComponent:dbname];
			}
		}
	}
	
	
	//Get Database from www directory
	NSString *sourceDB = @"";
	if([src rangeOfString:@"www"].location != NSNotFound){
		NSString *wwwDir = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"www"];
		sourceDB = [wwwDir stringByAppendingPathComponent:dbname];
	} else {
		if([src rangeOfString:@"file://"].location != NSNotFound){
			sourceDB = [src stringByReplacingOccurrencesOfString:@"file://" withString:@""];
			//sourceDB = [[src stringByReplacingOccurrencesOfString:@"file://" withString:@""] stringByAppendingPathComponent:dbname];
		} else {
			sourceDB = src;
			//sourceDB = [src stringByAppendingPathComponent:dbname];
		}
	}
	
	NSLog(@"[sqlDB] Source: %@",sourceDB);
	NSLog(@"[sqlDB] Destination: %@",dbPath);
	
	//copy database from www directory to target directory
	if (!([fileManager copyItemAtPath:sourceDB toPath:dbPath error:&error])) {
		NSLog(@"[sqlDB] Could not copy file from %@ to %@. Error = %@",sourceDB,dbPath,error);
		[self sendPluginResponse:error.code msg:error.description err:YES callBackID:cid];
		//        NSInteger ecode = [error code];
		
		//        [err setObject:[NSNumber numberWithUnsignedInteger:ecode] forKey:@"code"];
		//
		//        [err setObject:error.description forKey:@"message"];
		//
		//        result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsDictionary:err];
	} else {
		NSLog(@"File Copied objc");
		//        result =  [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"File Copied"];
		[self sendPluginResponse:200 msg:@"File Copied" err:NO callBackID:cid];
	}
	
}

- (void)copy:(CDVInvokedUrlCommand*)command
{
	
	// BOOL success;
	int location = 0;
	
	//CDVPluginResult *result = nil;
	
	NSString *dbname = [command argumentAtIndex:0];
	location = [[command argumentAtIndex:1] intValue];
	//NSMutableDictionary *err = [NSMutableDictionary dictionaryWithCapacity:2];
	
	NSLog(@"[sqlDB] Dbname = %@",dbname);
	NSLog(@"[sqlDB] location = %d",location);
	
	[self copyDb:location source:@"www" db:dbname callBackID:command.callbackId];
	
	// [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)checkDbOnStorage : (CDVInvokedUrlCommand *) command {
	NSString *dbname = [command argumentAtIndex:0];
	NSString *source = [command argumentAtIndex:1];
	NSString *src;
	if([source rangeOfString:@"file://"].location != NSNotFound){
		//sourceDB = [src stringByReplacingOccurrencesOfString:@"file://" withString:@""];
		src = [[source stringByReplacingOccurrencesOfString:@"file://" withString:@""] stringByAppendingPathComponent:dbname];
	} else {
		//sourceDB = src;
		src = [source stringByAppendingPathComponent:dbname];
	}
	
	if([fileManager fileExistsAtPath:src]) {
		[self sendPluginResponse:200 msg:@"File Exists" err:NO callBackID:command.callbackId];
	} else {
		[self sendPluginResponse:400 msg:@"File Doesn't Exists" err:NO callBackID:command.callbackId];
	}
}


-(void)remove:(CDVInvokedUrlCommand *)command
{
	int location = 0;
	NSString *filename = [command argumentAtIndex:0];
	location = [[command argumentAtIndex:1] intValue];
	//CDVPluginResult *result = nil;
	
	documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	fileManager = [NSFileManager defaultManager];
	
	if (location == 2) {
		dbPath = [documentsDirectory stringByAppendingPathComponent:filename];
	} else if(location == 1) {
		dbPath = [libraryDirectory stringByAppendingPathComponent:filename];
	} else {
		NSString *nosync = [libraryDirectory stringByAppendingPathComponent:@"LocalDatabase"];
		dbPath = [nosync stringByAppendingPathComponent:filename];
	}
	
	NSLog(@"[sqlDB] dbPath for deletion= %@",dbPath);
	
	// NSMutableDictionary *err = [NSMutableDictionary dictionaryWithCapacity:2];
	
	if([fileManager fileExistsAtPath:dbPath])
	{
		NSError *error = nil;
		[fileManager removeItemAtPath:dbPath error:&error];
		if (error) {
			//            [err setObject:err.description forKey:@"message"];
			//            [err setObject:[NSNumber numberWithUnsignedInteger:error.code] forKey:@"code"];
			//            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:err];
			[self sendPluginResponse:error.code msg:error.description err:YES callBackID:command.callbackId];
		} else {
			//            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
			[self sendPluginResponse:200 msg:@"Removed" err:NO callBackID:command.callbackId];
		}
	}
	else
	{
		//result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"File Doesn't Exists"];
		[self sendPluginResponse:404 msg:@"File Does Not Exists" err:YES callBackID:command.callbackId];
	}
	
	//    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}


-(void) copyDbFromStorage:(CDVInvokedUrlCommand *)command
{
	
	// BOOL success;
	int location = 0;
	
	//CDVPluginResult *result = nil;
	
	NSString *dbname = [command argumentAtIndex:0];
	location = [[command argumentAtIndex:1] intValue];
	NSString *src = [command argumentAtIndex:2];
	BOOL deleteolddb = [[command argumentAtIndex:3] boolValue];
	BOOL copyContinue = YES;
	NSError *error = nil;
	NSLog(@"deleteolddb = %d",deleteolddb);
	if(deleteolddb) {
		documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		
		libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		
		fileManager = [NSFileManager defaultManager];
		
		if (location == 0) {
			NSString *nosync = [libraryDirectory stringByAppendingPathComponent:@"LocalDatabase"];
			dbPath = [nosync stringByAppendingPathComponent:dbname];
			
		} else if(location == 1) {
			dbPath = [libraryDirectory stringByAppendingPathComponent:dbname];
		} else {
			dbPath = [documentsDirectory stringByAppendingPathComponent:dbname];
		}
		
		if(([fileManager fileExistsAtPath:dbPath]) == YES){
			if(!([fileManager removeItemAtPath:dbPath error:&error])) {
				[self sendPluginResponse:error.code msg:error.description err:YES callBackID:command.callbackId];
				copyContinue = NO;
			}
		}
	}
	//NSMutableDictionary *err = [NSMutableDictionary dictionaryWithCapacity:2];
	NSLog(@"[sqlDB] Dbname = %@",dbname);
	NSLog(@"[sqlDB] location = %d",location);
	if(copyContinue) {
		[self copyDb:location source:src db:dbname callBackID:command.callbackId];
	}
}

-(void) copyDbToStorage:(CDVInvokedUrlCommand *) command
{
	int location = 0;
	
	//CDVPluginResult *result = nil;
	
	NSString *dbname = [command argumentAtIndex:0];
	location = [[command argumentAtIndex:1] intValue];
	NSString *dest = [command argumentAtIndex:2];
	BOOL overwrite = [[command argumentAtIndex:3] boolValue];
	//NSMutableDictionary *err = [NSMutableDictionary dictionaryWithCapacity:2];
	
	NSLog(@"[sqlDB] Dbname = %@",dbname);
	NSLog(@"[sqlDB] location = %d",location);
	// NSLog(@"[sqlDB] documentsDirectory = %@",documentsDirectory);
	// NSLog(@"[sqlDB] libraryDirectory = %@",libraryDirectory);
	NSError *error = nil;
	fileManager = [NSFileManager defaultManager];
	
	if (location == 2) {
		//set Document as default target directory
		documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		dbPath = [documentsDirectory stringByAppendingPathComponent:dbname];
	} else if(location == 1) {
		//set Library as default target directory
		libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		dbPath = [libraryDirectory stringByAppendingPathComponent:dbname];
	} else {
		//set Library/LocalDatabase as default target directory and disable iCloud backup
		libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *nosync = [libraryDirectory stringByAppendingPathComponent:@"LocalDatabase"];
		if ([fileManager fileExistsAtPath:nosync]) {
			dbPath = [nosync stringByAppendingPathComponent:dbname];
		} else {
			if ([fileManager createDirectoryAtPath: nosync withIntermediateDirectories:NO attributes: nil error:&error])
			{
				NSURL *nosyncURL = [ NSURL fileURLWithPath: nosync];
				if (![nosyncURL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error])
				{
					NSLog(@"Error Setting No Backup Flag: %@", error);
					NSLog(@"Ingnoring Error and Copying DB");
				}
				NSLog(@"No Backup Path: %@", nosync);
				dbPath = [nosync stringByAppendingPathComponent:dbname];
			}
		}
	}
	
	NSString *destination = dest;
	
	if([dest rangeOfString:@"file://"].location != NSNotFound){
		destination = [dest stringByReplacingOccurrencesOfString:@"file://" withString:@""];
	}
	
	NSLog(@"[sqlDB] destination = %@",destination);
//	NSLog(@"[sqlDB] dest = %@",dest);
	BOOL isDir = YES;
	BOOL dirExists = [fileManager fileExistsAtPath:destination isDirectory:&isDir];
	NSLog(@"[sqlDB] destination = %@",destination);
	if(!dirExists){
		[[NSFileManager defaultManager] createDirectoryAtPath:destination withIntermediateDirectories:YES attributes:nil error:&error];
	}
	
	destination = [destination stringByAppendingPathComponent:dbname];
	
	NSLog(@"[sqlDB] Source: %@",dbPath);
	NSLog(@"[sqlDB] Destination: %@",destination);
	BOOL copyContinue = YES;
	
	if([fileManager fileExistsAtPath:destination] == YES) {
		NSLog(@"Ovwerwrite = %d",overwrite);
		if(overwrite) {
			if(!([fileManager removeItemAtPath:destination error:&error])) {
				[self sendPluginResponse:error.code msg:error.description err:YES callBackID:command.callbackId];
				copyContinue = NO;
			}
		}
	}
	if(copyContinue) {
		//copy database from www directory to target directory
		if (!([fileManager copyItemAtPath:dbPath toPath:destination error:&error])) {
			NSLog(@"[sqlDB] Could not copy file from %@ to %@. Error = %@",dbPath,destination,error);
			[self sendPluginResponse:error.code msg:error.description err:YES callBackID:command.callbackId];
			//        NSInteger ecode = [error code];
			
			//        [err setObject:[NSNumber numberWithUnsignedInteger:ecode] forKey:@"code"];
			//
			//        [err setObject:error.description forKey:@"message"];
			//
			//        result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsDictionary:err];
		} else {
			NSLog(@"File Copied objc");
			//        result =  [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"File Copied"];
			[self sendPluginResponse:200 msg:@"File Copied" err:NO callBackID:command.callbackId];
		}
	}
}

@end
