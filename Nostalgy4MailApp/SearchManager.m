//
//  SearchManager.m
//  Nostalgy4MailApp
//
//  Created by Hajo Nils Krabbenhöft on 30.05.09.
//  Copyright 2009 Hajo Nils Krabbenhöft. All rights reserved.
//

#import "SearchManager.h"
#import "SearchPopup.h"
#import "PrivateMailHeaders.h"
#import "objc/runtime.h"

@interface RepresentedObject : NSObject
@property(strong) id representedObject;
@end

@implementation RepresentedObject
// Empty
@end

@implementation MoveMessageDelegate

- (instancetype) initForMessageViewer:(MessageViewer *)target {
    viewer = target;
    return self;
}

- (void) mailboxSelected:(id)mailbox {
    RepresentedObject *container = [[RepresentedObject alloc] init];
    [container setRepresentedObject:mailbox];
    
    [viewer moveMessagesToMailbox:container];
    
    [container dealloc];
}

@end

@implementation CopyMessageDelegate

- (instancetype) initForMessageViewer:(MessageViewer *)target {
    viewer = target;
    return self;
}

- (void) mailboxSelected:(id)mailbox {
    RepresentedObject *container = [[RepresentedObject alloc] init];
    [container setRepresentedObject:mailbox];
    
    [viewer copyMessagesToMailbox:container];
    
    [container dealloc];
}

@end

@implementation SelectMailboxDelegate

- (instancetype) initForMessageViewer:(MessageViewer *)target {
    viewer = target;
    return self;
}

- (void) mailboxSelected:(id) mailbox {
    viewer.selectedMailboxes = [NSArray arrayWithObject:mailbox];
}

@end

@implementation SearchManager

- (MessageViewer*) frontmostMessageViewer {
    MailApp *mailApp = (MailApp*)[NSApplication sharedApplication];
    NSWindow *keyWindow = [mailApp keyWindow];
    
    if (keyWindow == nil)
        return nil;
    
    Class MessageViewerClass = objc_lookUpClass("MessageViewer");
    
    if ([[keyWindow delegate] isKindOfClass:MessageViewerClass])
        return (MessageViewer*)[keyWindow delegate];
    else
        return nil;
}

- (IBAction)moveToFolder:(id)sender {
    MessageViewer *viewer = [self frontmostMessageViewer];
    if (viewer != nil) {
        id delegate = [[[MoveMessageDelegate alloc] initForMessageViewer:viewer] autorelease];
        [[SearchPopup popupWithDelegate:delegate] showWithSender:sender andTitle:@"Move to folder"];
    }
}

- (IBAction)copyToFolder:(id)sender {
    MessageViewer *viewer = [self frontmostMessageViewer];
    if (viewer != nil) {
        id delegate = [[[CopyMessageDelegate alloc] initForMessageViewer:viewer] autorelease];
        [[SearchPopup popupWithDelegate:delegate] showWithSender:sender andTitle:@"Copy to folder"];
    }
}

- (IBAction)goToFolder:(id)sender {
    MessageViewer *viewer = [self frontmostMessageViewer];
    if (viewer != nil) {
        id delegate = [[[SelectMailboxDelegate alloc] initForMessageViewer:viewer] autorelease];
        [[SearchPopup popupWithDelegate:delegate] showWithSender:sender andTitle:@"Go to folder"];
    }
}

- (IBAction)archiveMessages:(id)sender {
    MessageViewer *viewer = [self frontmostMessageViewer];
    [viewer archiveMessages:nil];
}

- (IBAction)replyAllMessage:(id)sender {
    MessageViewer *viewer = [self frontmostMessageViewer];
    [viewer replyAllMessage:nil];
}

- (IBAction)forwardMessage:(id)sender {
    MessageViewer *viewer = [self frontmostMessageViewer];
    [viewer forwardMessage:nil];
}

- (IBAction)toggleFlag:(id)sender {
    MessageViewer *viewer = [self frontmostMessageViewer];
    [viewer toggleFlag:nil];
}

- (IBAction)newMessage:(id)sender {
    MessageViewer *viewer = [self frontmostMessageViewer];
    [viewer showComposeWindow:nil];
}

-(IBAction)nextMessage:(id)sender {
    MessageViewer *viewer = [self frontmostMessageViewer];
    [viewer.tableManager selectNextMessage:NO];
}

-(IBAction)previousMessage:(id)sender {
    MessageViewer *viewer = [self frontmostMessageViewer];
    [viewer.tableManager selectPreviousMessage:NO];
}

-(IBAction)focusSearchField:(id)sender {
    MessageViewer *viewer = [self frontmostMessageViewer];
    if ([viewer.searchField acceptsFirstResponder])
        [viewer.window makeFirstResponder:viewer.searchField];
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
	}
	NSLog(@"### Nostalgy 4 Mail.app: submenu in place <Nostalgy>");
}


@end
