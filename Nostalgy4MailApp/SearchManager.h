//
//  SearchManager.h
//  Nostalgy4MailApp
//
//  Created by Hajo Nils Krabbenhöft on 30.05.09.
//  Copyright 2009 Hajo Nils KrabbenhöftHajo Nils Krabbenhöft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PrivateMailHeaders.h"

@interface NSObject(SearchManagerDelegate)
- (void) mailboxSelected:(id)mailbox;
@end

@interface MoveMessageDelegate : NSObject {
    MessageViewer* viewer;
}
- (instancetype) initForMessageViewer:(MessageViewer*)viewer;
- (void) mailboxSelected:(id)mailbox;
@end

@interface CopyMessageDelegate : NSObject {
    MessageViewer *viewer;
}
- (instancetype) initForMessageViewer:(MessageViewer*)viewer;
- (void) mailboxSelected:(id)mailbox;
@end

@interface SelectMailboxDelegate : NSObject {
    MessageViewer *viewer;
}
- (instancetype) initForMessageViewer:(MessageViewer*)viewer;
- (void) mailboxSelected:(id)mailbox;
@end

@interface SearchManager : NSObject
- (IBAction)moveToFolder:(id)sender;
- (IBAction)copyToFolder:(id)sender;
- (IBAction)goToFolder:(id)sender;
@end
