//
//  DKAppDelegate.m
//  NSLogKiller
//
//  Created by Devarshi Kulshreshtha on 07/09/12.
//  Copyright (c) 2012 DaemonConstruction. All rights reserved.
//

#import "DKAppDelegate.h"

@interface DKAppDelegate ()

- (IBAction)selectAction:(id)sender;
- (IBAction)deleteLogStmntsAction:(id)sender;
//- (void)executeTopsWithPath:(NSString *)path;
@end

@implementation DKAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.isProcessing = NO;
}

- (IBAction)selectAction:(id)sender {
    NSOpenPanel *anOpenPanel = [NSOpenPanel openPanel];
    [anOpenPanel setCanChooseDirectories:YES];
    [anOpenPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        self.selectedPath = [[anOpenPanel URLs] objectAtIndex:0];
      }];
}

- (IBAction)deleteLogStmntsAction:(id)sender {
    
    self.isProcessing = YES;
    BOOL isDirectory;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self.selectedPath path] isDirectory:&isDirectory] && isDirectory)
    {
        // directory selected
        
        // now navigate through each directory within it
        // and apply tops for each
        
        NSFileManager *fileManager =[NSFileManager defaultManager];
        NSArray *keys = [NSArray arrayWithObjects:NSURLIsDirectoryKey,NSURLPathKey,NSURLNameKey,nil];
        
        NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtURL:self.selectedPath includingPropertiesForKeys:keys options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:^BOOL(NSURL *url, NSError *error) {
            
            return YES;
        }];
        
        for (NSURL *url in directoryEnumerator)
        {
            NSNumber *isDirectory;
            [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
            
            if ([isDirectory boolValue]) {
                NSString *directoryName;
                [url getResourceValue:&directoryName forKey:NSURLPathKey error:NULL];
                
                NSRange substringRange = [directoryName rangeOfString:@"."];
                if (substringRange.location != NSNotFound) {
                    
                    [directoryEnumerator skipDescendants];
                }
            }
            else
            {
                [self executeTopsWithPath:[url path]];
            }
        }
    }
    else
    {
        // file selected
        [self executeTopsWithPath:[self.selectedPath path]];
    }
    self.isProcessing = NO;
}

- (void)executeTopsWithPath:(NSString *)path
{
    NSTask *theTopsCommand = [[NSTask alloc] init];
    [theTopsCommand setLaunchPath:@"/usr/bin/tops"];
    
    [theTopsCommand setArguments:[[NSArray alloc] initWithObjects:@"-semiverbose",@"replace", @"NSLog(<a args>);", @"with", @"", path,nil]];
    
    [theTopsCommand launch];
    [theTopsCommand waitUntilExit];
}
@end
