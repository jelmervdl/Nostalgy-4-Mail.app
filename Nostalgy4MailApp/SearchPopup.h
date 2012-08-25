//
//  SearchPopup.h
//  Nostalgy4MailApp
//
//  Created by Hajo Nils Krabbenhöft on 30.05.09.
//  Copyright 2009 Hajo Nils Krabbenhöft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "SearchManager.h"

@interface SearchPopup : NSObject {
	IBOutlet NSSearchField* searchField;
	IBOutlet NSWindow* searchWindow;
    NSMenu* submenu;
	NSMutableArray* currentResults;
	NSDictionary* selectedResult;
	IBOutlet NSTableView* resultViewer;
	SearchManager* parent;
}

+ (id)popupWithSubmenu:(NSMenu *)submenu andParent:(SearchManager*) parent;
- (id)init;
- (void)addMenu:(NSMenu *)menu toDictionary:(NSMutableDictionary*)dict withPath:(NSMutableArray *)array atLevel:(int)level;
- (void)showWithSender: sender andTitle:(NSString *)title;
- (IBAction)doSearch: sender;
- (IBAction)changeSelection: sender;

@end
