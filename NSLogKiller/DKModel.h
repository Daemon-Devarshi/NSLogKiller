//
//  DKModel.h
//  NSLogKiller
//
//  Created by Devarshi Kulshreshtha on 07/09/12.
//  Copyright (c) 2012 DaemonConstruction. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKModel : NSObject
@property (readwrite, retain) NSString *selectedFolderOrFile;
- (void)executeTopCommand;
@end
