//
//  sqlDB Implementation File
//  sqlDB Phonegap/Cordova Plugin
//
//  Created by Rahul on 4/14/14.
//
//

#import "sqlDB.h"

@implementation sqlDB

- (void)copy:(CDVInvokedUrlCommand*)command
{

   // BOOL success;
    int location = 0;
    NSError *error = nil;
    CDVPluginResult *result = nil;
    
    NSString *dbname = [command argumentAtIndex:0];
    location = [[command argumentAtIndex:1] intValue];
    NSMutableDictionary *err = [NSMutableDictionary dictionaryWithCapacity:2];
    
   // NSLog(@"[sqlDB] Dbname = %@",dbname);
   // NSLog(@"[sqlDB] location = %d",location);
    
    documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
   // NSLog(@"[sqlDB] documentsDirectory = %@",documentsDirectory);
   // NSLog(@"[sqlDB] libraryDirectory = %@",libraryDirectory);
    
    fileManager = [NSFileManager defaultManager];
    
    if (location == 0) {
        //set Document as default target directory
        dbPath = [documentsDirectory stringByAppendingPathComponent:dbname];
    } else if(location == 1) {
        //set Library as default target directory
        dbPath = [libraryDirectory stringByAppendingPathComponent:dbname];
    } else {
        //set Library/LocalDatabase as default target directory and disable iCloud backup
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
    NSString *wwwDir = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"www"];
    NSString *dbPathFromApp = [wwwDir stringByAppendingPathComponent:dbname];

    NSLog(@"[sqlDB] Source: %@",dbPathFromApp);
    NSLog(@"[sqlDB] Destinatiion: %@",dbPath);

    //copy database from www directory to target directory
    if (!([fileManager copyItemAtPath:dbPathFromApp toPath:dbPath error:&error])) {
        NSLog(@"[sqlDB] Could not copy file from %@ to %@. Error = %@",dbPathFromApp,dbPath,error);
        
        NSInteger ecode = [error code];
        
        [err setObject:[NSNumber numberWithUnsignedInteger:ecode] forKey:@"code"];
        
        [err setObject:error.description forKey:@"message"];
        
        result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsDictionary:err];
    } else {
        result =  [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"File Copied"];
    }
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void)remove:(CDVInvokedUrlCommand *)command
{
    int location = 0;
    NSString *filename = [command argumentAtIndex:0];
    location = [[command argumentAtIndex:1] intValue];
    CDVPluginResult *result = nil;
    
    documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    fileManager = [NSFileManager defaultManager];
    
    if (location == 0) {
        dbPath = [documentsDirectory stringByAppendingPathComponent:filename];
    } else if(location == 1) {
        dbPath = [libraryDirectory stringByAppendingPathComponent:filename];
    } else {
        NSString *nosync = [libraryDirectory stringByAppendingPathComponent:@"LocalDatabase"];
        dbPath = [nosync stringByAppendingPathComponent:filename];
    }
    
    NSLog(@"[sqlDB] dbPath for deletion= %@",dbPath);

    NSMutableDictionary *err = [NSMutableDictionary dictionaryWithCapacity:2];
    
    if([fileManager fileExistsAtPath:dbPath])
    {
        NSError *error = nil;
        [fileManager removeItemAtPath:dbPath error:&error];
        if (error) {
            [err setObject:err.description forKey:@"message"];
            [err setObject:[NSNumber numberWithUnsignedInteger:error.code] forKey:@"code"];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:err];
        } else {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
        }
    }
    else
    {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"File Doesn't Exists"];
    }
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
