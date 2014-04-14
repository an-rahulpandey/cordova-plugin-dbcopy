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

    BOOL success;
    NSError *error = nil;
    CDVPluginResult *result = nil;
    NSString *dbname = [command argumentAtIndex:0];
    
    NSLog(@"[sqlDB] Dbname = %@",dbname);
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbname];
    
    
    fileManager = [NSFileManager defaultManager];
    
    success = [fileManager fileExistsAtPath:dbPath isDirectory:NO];
    
    if (!success) {
        NSLog(@"[sqlDB] copying db file");
        
        NSString *dbPathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbname];
        NSLog(@"[sqlDB] Source: %@",dbPathFromApp);
        NSLog(@"[sqlDB] Destinatiion: %@",dbPath);
        if (!([fileManager copyItemAtPath:dbPathFromApp toPath:dbPath error:&error])) {
            NSLog(@"[sqlDB] Could not copy file from %@ to %@. Error = %@",dbPathFromApp,dbPath,error);
            result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:error.description];
        } else {
            result =  [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"File Copied"];
        }
        
        
    }
    else
    {
        NSLog(@"[sqlDB] File Aready Exists");
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"File Already Exists"];
    }
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}


@end
