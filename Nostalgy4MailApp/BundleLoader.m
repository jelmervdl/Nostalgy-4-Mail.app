//
//  BundleLoader.m
//  Nostalgy4MailApp
//
//  Created by Hajo Nils Krabbenhöft on 30.05.09.
//  Copyright 2009 Hajo Nils Krabbenhöft. All rights reserved.
//
#include "BundleLoader.h"
#include "SearchManager.h"
#include "Mail.h"
#include "NSArray+reverse.h"

@implementation BundleLoader

+ (void)initialize
{
    [NSBundle loadNibNamed:@"SearchManager" owner:[SearchManager alloc]];
    
//    [self experiment];
}

NSString *fullPathNameForMailbox(MailboxUid *mailbox)
{
    NSMutableArray *stack = [NSMutableArray array];
    
    while (mailbox) {
        [stack addObject:[mailbox displayName]];
        mailbox = [mailbox parent];
    }
    
    return [[stack reversed] componentsJoinedByString:@"/"];
}

+ (void)experiment
{
    MailApp *mailApp = (MailApp*)[NSApplication sharedApplication];
    
    for (MailAccount *account in [mailApp accounts])
        if ([account isActive])
            for (MailboxUid *mailbox in [account mailboxes])
                NSLog(@"%@", fullPathNameForMailbox(mailbox));
}

@end
 