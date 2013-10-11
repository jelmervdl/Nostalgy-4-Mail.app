//
//  SearchManager.m
//  Nostalgy4MailApp
//
//  Created by Hajo Nils Krabbenhöft on 30.05.09.
//  Copyright 2009 Hajo Nils Krabbenhöft. All rights reserved.
//

#import "SearchManager.h"
#import "SearchPopup.h"

@implementation SearchManager
 

- (IBAction)moveToFolder: sender {
	NSMenu* menu = [submenuMove submenu];
	[[SearchPopup popupWithSubmenu: menu andParent: self ] showWithSender: sender andTitle: @"Move to folder ..." ];
}

- (IBAction)moveToLastFolder: sender {
	NSMenu* menu = [submenuMove submenu];
	[self invokeLastFolder: menu];
}

- (IBAction)copyToFolder: sender {
	NSMenu* menu = [submenuCopy submenu];
	[[SearchPopup popupWithSubmenu: menu andParent: self ] showWithSender: sender andTitle: @"Copy to folder ..." ];
}

- (IBAction)copyToLastFolder: sender {
	NSMenu* menu = [submenuCopy submenu];
	[self invokeLastFolder: menu];
}

- (void)invokeLastFolder:(NSMenu*) submenu {
	if( [submenu numberOfItems] == 0 ) [[submenu delegate] menuNeedsUpdate: submenu ];
	[submenu update];
	
	NSArray     *items = [submenu itemArray];
    for(int iI = 0; iI < [items count]; iI++){
        NSMenuItem*  menuItem = [items objectAtIndex:iI];
		if(! [menuItem isEnabled] ) continue;
		
		NSString* title = [menuItem title];
		if( [title isEqualToString: lastFolder] ) {
			[submenu performActionForItemAtIndex: iI ];
			return;
		}
    }   
}




- (NSMenuItem *) newMenuItemWithTitle:(NSString *)title action:(SEL)action andKeyEquivalent:(NSString *)keyEquivalent inMenu:(NSMenu *)menu relativeToItemWithSelector:(SEL)selector offset:(int)offset
// Taken from /System/Developer/Examples/EnterpriseObjects/AppKit/ModelerBundle/EOUtil.m
{
	// Simple utility category which adds a new menu item with title, action
	// and keyEquivalent to menu (or one of its submenus) under that item with
	// selector as its action.  Returns the new addition or nil if no such 
	// item could be found.
	
    NSMenuItem  *menuItem;
    NSArray     *items = [menu itemArray];
    int         iI;
	
    if(!keyEquivalent)
        keyEquivalent = @"";
	
    for(iI = 0; iI < [items count]; iI++){
        menuItem = [items objectAtIndex:iI];
        
        if([menuItem action] == selector)
            return ([menu insertItemWithTitle:title action:action keyEquivalent:keyEquivalent atIndex:iI + offset]);
        else if([[menuItem target] isKindOfClass:[NSMenu class]]){
            menuItem = [self newMenuItemWithTitle:title action:action andKeyEquivalent:keyEquivalent inMenu:[menuItem target] relativeToItemWithSelector:selector offset:offset];
            if(menuItem)
                return menuItem;
        }
    }   
	
    return nil;
}


- (void) setContextMenu:(NSMenu *)menu {
	
	NSMenuItem* firstMenuItem =  [self newMenuItemWithTitle:@"Nostalgy" action:NULL andKeyEquivalent:@"" inMenu:[[NSApplication sharedApplication] mainMenu] relativeToItemWithSelector:@selector(addSenderToContacts:) offset:1];
	

	if(!firstMenuItem)
		NSLog(@"### Nostalgy 4 Mail.app: unable to add submenu <Nostalgy>");
	else{
		[[firstMenuItem menu] insertItem:[NSMenuItem separatorItem] atIndex:[[firstMenuItem menu] indexOfItem:firstMenuItem]];
		[[firstMenuItem menu] setSubmenu:menu forItem:firstMenuItem];
		// [messageMenu setSubmenu:menu forItem:firstMenuItem];
	}
	NSLog(@"### Nostalgy 4 Mail.app: submenu in place <Nostalgy>");
	
	NSMenu* messagesMenu = [firstMenuItem menu];
    NSArray     *items = [messagesMenu itemArray];
    for(int iI = 0; iI < [items count]; iI++){
        NSMenuItem*  menuItem = [items objectAtIndex:iI];
		
        if([menuItem hasSubmenu]) {
			if([menuItem tag] == 105) submenuMove = menuItem;
            if([menuItem tag] == 106) submenuCopy = menuItem;
        }
    }   
	
	NSLog(@"### Nostalgy 4 Mail.app: submenuMove: %@", submenuMove);
	NSLog(@"### Nostalgy 4 Mail.app: submenuCopy: %@", submenuCopy);
	
}

- (void) setLastFolder: (NSString*) folder {
	lastFolder = folder;
	[menuitemLastMove setHidden:FALSE];
	[menuitemLastMove setTitle: [NSString stringWithFormat:@"Move selected messages to \"%@\"", folder]];
	[menuitemLastCopy setHidden:FALSE];
	[menuitemLastCopy setTitle: [NSString stringWithFormat:@"Copy selected messages to \"%@\"", folder]];
}

- (NSString*) lastFolder {
	return lastFolder;
}

- (NSMenuItem*) dbgSubmenuMove {
	return submenuMove;
}
- (NSMenuItem*) dbgSubmenuCopy{
	return submenuCopy;
}


@end
