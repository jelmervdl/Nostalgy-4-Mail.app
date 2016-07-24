//
// Headers for classes in Mail.app used by Nostalgy4Mail.
//

@interface MailboxesController : NSObject
+ (id)iconForMailbox:(id)arg1 size:(long long)arg2 style:(unsigned long long)arg3;
@end

@interface MailApp : NSApplication
{}
@property(readonly, copy, nonatomic) NSArray *selection;
- (NSArray *)accounts;
- (NSMutableArray *)messageViewers;
- (id)mailboxes;
- (void)selectMailbox:(id)arg1;
@end

@interface MFMailAccount : NSObject
{}
- (bool) isActive;
- (NSArray *)mailboxes;
@end

@interface MFMailbox : NSObject
{}
- (MFMailbox *)parent;
- (NSString *)displayName;
@property(copy) NSString *name; // @synthesize name=_name;
@property(readonly, nonatomic) NSImage *accountIcon;
@property(readonly, nonatomic) BOOL isVisible;
@property(readonly) BOOL isValid;
@end

@interface TableViewManager : NSObject
- (void)selectNextMessage:(BOOL)arg1;
- (void)selectPreviousMessage:(BOOL)arg1;
@end

@interface MessageListController : NSViewController
@property(retain, nonatomic) TableViewManager *tableViewManager;
@end

@interface MessageViewer : NSResponder
@property(readonly, nonatomic) TableViewManager *tableManager;
- (void)copyMessagesToMailbox:(id)arg1;
- (void)moveMessagesToMailbox:(id)arg1;
- (void)archiveMessages:(id)arg1;
- (void)replyAllMessage:(id)arg1;
- (void)replyMessage:(id)arg1;
- (void)forwardMessage:(id)arg1;
- (void)showComposeWindow:(id)arg1;
- (void)toggleFlag:(id)arg1;
- (MFMailbox*)junkMailbox;
- (MFMailbox*)trashMailbox;
- (MFMailbox*)sentMailbox;
- (MFMailbox*)draftsMailbox;
- (MFMailbox*)outbox;
- (MFMailbox*)inbox;
@property(copy, nonatomic) NSArray *selectedMailboxes;
@property(retain, nonatomic) NSSearchField *searchField;
@property(retain, nonatomic) NSWindow *window;
@end