//
//  BundleLoader.m
//  Nostalgy4MailApp
//
//  Created by Hajo Nils Krabbenhöft on 30.05.09.
//  Copyright 2009 Hajo Nils Krabbenhöft. All rights reserved.
//
#include "BundleLoader.h"
#include "SearchManager.h"

@implementation BundleLoader

+ (void)initialize
{
    [NSBundle loadNibNamed:@"SearchManager" owner:[SearchManager alloc]];
}

@end
 