//
//  DKAppDelegate.h
//  NSLogKiller
//
//  Created by Devarshi Kulshreshtha on 07/09/12.
//  Copyright (c) 2012 DaemonConstruction. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DKAppDelegate : NSObject <NSApplicationDelegate>
@property (readwrite,strong) NSURL *selectedPath;
@property (assign) IBOutlet NSWindow *window;
@property (assign) BOOL isProcessing;
@end
