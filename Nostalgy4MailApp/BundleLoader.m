//
//  BundleLoader.m
//  Nostalgy4MailApp
//
//  Created by Hajo Nils Krabbenhöft on 30.05.09.
//  Copyright 2009 Hajo Nils Krabbenhöft. All rights reserved.
//
#include "BundleLoader.h"
#include "SearchManager.h"
#include "objc/runtime.h"

@implementation BundleLoader

+ (void)initialize
{
//    Class MailboxesController = NSClassFromString(@"MailboxesController");
//    NSLog(@"Class found: %p", MailboxesController);
//    Method iconForMailbox = class_getClassMethod(MailboxesController, @selector(iconForMailbox:size:style:));
//    NSLog(@"Method found: %p", iconForMailbox);
//    
//    if (iconForMailbox) {
//        // Add a new reference to the original
//        class_addMethod(MailboxesController,
//                        @selector(_iconForMailbox:size:style:),
//                        class_getMethodImplementation([BundleLoader class], @selector(alternativeIconForMailbox:size:style:)),
//                        method_getTypeEncoding(iconForMailbox));
//        
//        // Replace the original with the alternative
//        Method alternativeIconForMailbox = class_getClassMethod([BundleLoader class], @selector(alternativeIconForMailbox:size:style:));
//        method_exchangeImplementations(iconForMailbox, alternativeIconForMailbox);
//        NSLog(@"N4M Swizzled %p with %p", iconForMailbox, alternativeIconForMailbox);
//    }
    
//    Class MessageViewer = NSClassFromString(@"MessageViewer");
//    NSLog(@"MessageViewer found at %p", MessageViewer);
//    Method selectMailbox = class_getInstanceMethod(MessageViewer, @selector(setSelectedMailboxes:));
//    Method debugSelectMailbox = class_getInstanceMethod([BundleLoader class], @selector(debugSelectMailbox:));
//    NSLog(@"Replacing %p with %p", selectMailbox, debugSelectMailbox);
//    method_exchangeImplementations(selectMailbox, debugSelectMailbox);

    [NSBundle loadNibNamed:@"SearchManager" owner:[[SearchManager alloc] init]];
}

//- (void)debugSelectMailbox:(id)arg {
//    NSLog(@"Called debugSelectMailbox with %@", arg);
//}

//+ (id) alternativeIconForMailbox:(id)mailbox size:(long long)size style:(long long) style {
//    NSLog(@"Calling iconForMailbox with mailbox:'%@' size:%lld and style:%lld", [mailbox name], size, style);
//    return nil;
//}

@end
 