//
// Headers for classes in Mail.app used by Nostalgy4Mail.
//

@interface MailApp : NSApplication
{}
- (NSArray *)accounts;
@end

@interface MailAccount : NSObject
{}
- (bool) isActive;
- (NSArray *)mailboxes;
@end

@interface MailboxUid : NSObject
{}
- (MailboxUid *)parent;
- (NSString *)displayName;
@end
