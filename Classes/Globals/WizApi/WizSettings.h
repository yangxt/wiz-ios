//
//  WizSettings.h
//  Wiz
//
//  Created by 朝 董 on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WizDbDelegate.h"


@interface WizSettings : NSObject
{
    id<WizDbDelegate> dbDeleagte;
}

@end