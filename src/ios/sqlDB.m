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
    NSError *error = nil;
    CDVPluginResult *result = nil;
    NSString *dbname = [command argumentAtIndex:0];
    NSMutableDictionary *err = [NSMutableDictionary dictionaryWithCapacity:2];
    
    //NSLog(@"[sqlDB] Dbname = %@",dbname);
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbname];
    
    
    fileManager = [NSFileManager defaultManager];
    
   // success = [fileManager fileExistsAtPath:dbPath isDirectory:NO];
    
    //if (!success) {
      //  NSLog(@"[sqlDB] copying db file");
        
    
    
        NSString *wwwDir = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"www"];
        NSString *dbPathFromApp = [wwwDir stringByAppendingPathComponent:dbname];
    
        //NSLog(@"[sqlDB] Source: %@",dbPathFromApp);
        //NSLog(@"[sqlDB] Destinatiion: %@",dbPath);
    
        if (!([fileManager copyItemAtPath:dbPathFromApp toPath:dbPath error:&error])) {
            NSLog(@"[sqlDB] Could not copy file from %@ to %@. Error = %@",dbPathFromApp,dbPath,error);
            
            NSInteger ecode = [error code];
            
            [err setObject:[NSNumber numberWithUnsignedInteger:ecode] forKey:@"code"];
            
            [err setObject:error.description forKey:@"message"];
            
            result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsDictionary:err];
        } else {
            result =  [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"File Copied"];
        }
        
        
  //  }
//    else
//    {
//        NSLog(@"[sqlDB] File Aready Exists");
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"File Already Exists"];
//    }
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void)remove:(CDVInvokedUrlCommand *)command
{
    NSString *filename = [command argumentAtIndex:0];
    CDVPluginResult *result = nil;
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:filename];
    NSMutableDictionary *err = [NSMutableDictionary dictionaryWithCapacity:2];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:dbPath])
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:dbPath error:&error];
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
