//
//  iPhoneSpects.m
//  Hi
//
//  Created by Joaquin Pereira on 25/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "iPhoneSpects.h"

@implementation iPhoneSpects


+(NSString *)language
{
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

@end
