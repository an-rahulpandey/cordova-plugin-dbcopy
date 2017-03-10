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

- (void) copyDbToStorage:(CDVInvokedUrlCommand *) command;

- (void) copyDbFromStorage:(CDVInvokedUrlCommand *)command;

- (void)checkDbOnStorage : (CDVInvokedUrlCommand *) command;

- (void)sendPluginResponse:(NSInteger*)code msg:(NSString*)msg err:(BOOL)error callBackID:(NSString*)cid;

@end
