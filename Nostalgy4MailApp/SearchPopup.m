//
//  SearchPopup.m
//  Nostalgy4MailApp
//
//  Created by Hajo Nils Krabbenhöft on 30.05.09.
//  Copyright 2009 Hajo Nils Krabbenhöft. All rights reserved.
//

#import "SearchPopup.h"
#import "Ranker.h"
#import "PrivateMailHeaders.h"
#import "NSArray+reverse.h"

NSString *fullPathNameForMailbox(MFMailbox *mailbox)
{
    NSMutableArray *stack = [NSMutableArray array];
    
    while (mailbox) {
        NSString *name = mailbox.name;
        
        if (name == nil)
            //name = [mailbox displayName];
            break; // because account name, not interesting.
        
        [stack addObject:name];
        mailbox = mailbox.parent;
    }
    
    return [[stack reversed] componentsJoinedByString:@"/"];
}

@implementation SearchPopup

+ (id)popupWithDelegate:(NSObject *)delegate
{
    SearchPopup* popup = [[SearchPopup alloc] init];
    
    [delegate retain];
	popup->delegate = delegate;
    
    [NSBundle loadNibNamed: @"SearchPopup" owner:popup];
    
    return popup;
}

- (void)addMailboxesToDictionary:(NSMutableDictionary *)dict
{
    MailApp *mailApp = (MailApp*)[NSApplication sharedApplication];
    
    for (MFMailAccount *account in mailApp.accounts) {
        if (account.isActive) {
            for (MFMailbox *mailbox in account.mailboxes) {
                if (mailbox.isValid && mailbox.isVisible) {
                    NSString *name = fullPathNameForMailbox(mailbox);
                    [dict setObject:mailbox forKey:name];
                }
            }
        }
    }
    
    MessageViewer *viewer = [[mailApp messageViewers] firstObject];
    
    if (viewer.junkMailbox != nil)
        [dict setObject:viewer.junkMailbox forKey:viewer.junkMailbox.name];
    
    if (viewer.sentMailbox != nil)
        [dict setObject:viewer.sentMailbox forKey:viewer.sentMailbox.name];
    
    if (viewer.draftsMailbox != nil)
        [dict setObject:viewer.draftsMailbox forKey:viewer.draftsMailbox.name];
    
    if (viewer.outbox != nil)
        [dict setObject:viewer.outbox forKey:viewer.outbox.name];
    
    if (viewer.inbox != nil)
        [dict setObject:viewer.inbox forKey:viewer.inbox.name];
}

- (id) init
{
    self = [super init];
        
    currentResults = [NSMutableArray array];
    [currentResults retain];
    
    // All the available folders will be collected in here.
    folders = [NSMutableDictionary dictionary];
    [folders retain];
    [self addMailboxesToDictionary:folders];
    
    return self;
}

- (void) dealloc
{
    [folders release];
    [currentResults release];
    [delegate release];
    [super dealloc];
}

- (void)showWithSender:(id)sender andTitle: (NSString *)title
{
	[searchWindow setTitle:title];
	[searchWindow makeKeyAndOrderFront: sender];
    [searchField becomeFirstResponder];
}

NSInteger compareMatch(id l_row, id r_row, void *query)
{
    double l_rank = calculate_rank(
        (NSString *)[(NSDictionary*)l_row objectForKey:@"path"],
        (NSString *)query);
    
    double r_rank = calculate_rank(
        (NSString *)[(NSDictionary*)r_row objectForKey:@"path"],
        (NSString *)query);
    
    if (l_rank == r_rank)
        return NSOrderedSame;    
    else
        return l_rank > r_rank
        ? NSOrderedAscending
        : NSOrderedDescending;
}

- (IBAction)doSearch: sender
{
	NSString *searchString = [searchField stringValue];
    //NSLog(@"### Search string is %@", searchString);

    // Clear all previous results.
    [currentResults removeAllObjects];
    
    //NSLog(@"### Folders found: %lu", [folders count]);
    
    // Filter the folders to only include folders that somehow match.
    for (NSString *path in folders)
    {
        if ([searchString length] == 0 || is_subset(searchString, path)) {
            [currentResults addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                       path, @"path",
                                       [folders objectForKey:path], @"mailbox",
                                       nil]];
        }
    }
    
    // Sort the folders according to how well they match with the search string.
    [currentResults sortUsingFunction:compareMatch context:searchString];
    
    selectedResult = [currentResults count] > 0
        ? [currentResults objectAtIndex:0]
        : nil;
	
	[resultViewer reloadData];
}

- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector
{
    BOOL result = NO;
    if (commandSelector == @selector(insertNewline:))
    {
		if (selectedResult != nil)
        {
			NSLog(@"#N4M Invoking %@ on %@", [selectedResult objectForKey:@"mailbox"], delegate);
            [delegate mailboxSelected:[selectedResult objectForKey:@"mailbox"]];
		}
        
		[searchWindow orderOut:nil];
		result = YES;
    }
	else if (commandSelector == @selector(cancelOperation:))
    {
		[searchWindow orderOut:nil];
		result = YES;
	}
	else if (commandSelector == @selector(moveUp:))
    {
		 if (selectedResult != nil)
         {
			 NSUInteger index = [currentResults indexOfObject:selectedResult];

			 if (index > 0)
                 index -= 1;
			 
             selectedResult = [currentResults objectAtIndex:index];
			 [resultViewer selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:FALSE];
			 [resultViewer scrollRowToVisible:index];
		 }
		 result = YES;
	}
	else if (commandSelector == @selector(moveDown:))
    {
		 if (selectedResult != nil)
         {
			 NSUInteger index = [currentResults indexOfObject: selectedResult];
             
			 if (index < [currentResults count])
                 index += 1;
             
			 selectedResult = [currentResults objectAtIndex:index];
			 [resultViewer selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:FALSE];
			 [resultViewer scrollRowToVisible:index];
		 }
		 result = YES;
	}
    
    return result;
}

- (id)tableView:(NSTableView *)table objectValueForTableColumn:(NSTableColumn *)column row:(int)rowIndex
{	
    NSParameterAssert(rowIndex >= 0 && rowIndex < [currentResults count]);
    NSDictionary* row = [currentResults objectAtIndex:rowIndex];
    
    if ([[column identifier] isEqualToString: @"image"]) {
        Class MailboxesController = NSClassFromString(@"MailboxesController");
        return [MailboxesController iconForMailbox:[row objectForKey:@"mailbox"] size:1 style:5];
    }
    
    
    if ([[column identifier] isEqualToString: @"title"])
        return [row objectForKey:@"path"];
    
    return nil;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [currentResults count];
}

- (IBAction)changeSelection:sender
{
	NSInteger i = [resultViewer selectedRow];
    
	if (i >= 0 && i < [currentResults count])
		selectedResult = [currentResults objectAtIndex: i];
	else 
		selectedResult = nil;
}

@end
