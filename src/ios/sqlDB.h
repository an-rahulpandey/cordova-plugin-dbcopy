//
//  sqlDB.h
//
//  sqlDB Phonegap/Cordova Plugin
//
//  Created by Rahul on 4/14/14.
//
//

#import <Foundation/Foundation.h>

#import <Cordova/CDVPlugin.h>
#import <Cordova/CDV.h>

@interface sqlDB : CDVPlugin
{
    NSFileManager* fileManager;
    NSString* dbPath;
    NSString* documentsDirectory;
    NSString* libraryDirectory;
}

- (void)copy:(CDVInvokedUrlCommand*)command;

- (void)remove:(CDVInvokedUrlCommand*)command;

@end
