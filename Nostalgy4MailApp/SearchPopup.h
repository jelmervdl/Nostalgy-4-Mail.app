//
//  SearchPopup.h
//  Nostalgy4MailApp
//
//  Created by Hajo Nils Krabbenhöft on 30.05.09.
//  Copyright 2009 Hajo Nils Krabbenhöft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "SearchManager.h"

@class MFMailbox;

NSString *fullPathNameForMailbox(MFMailbox *mailbox);

@interface SearchPopup : NSObject {
	IBOutlet NSSearchField* searchField;
	IBOutlet NSWindow* searchWindow;
	NSMutableArray* currentResults;
	NSDictionary* selectedResult;
	IBOutlet NSTableView* resultViewer;
    NSObject *delegate;
    NSMutableDictionary *folders;
}

+ (id)popupWithDelegate:(id)delegate;
- (id)init;
- (void)showWithSender: sender andTitle:(NSString *)title;
- (IBAction)doSearch: sender;
- (IBAction)changeSelection: sender;

@end
