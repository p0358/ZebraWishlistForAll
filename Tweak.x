typedef enum : NSUInteger {
    ZBPackageExtraActionShowUpdates,
    ZBPackageExtraActionHideUpdates,
    ZBPackageExtraActionAddWishlist,
    ZBPackageExtraActionRemoveWishlist,
    ZBPackageExtraActionBlockAuthor,
    ZBPackageExtraActionUnblockAuthor,
    ZBPackageExtraActionShare,
} ZBPackageExtraActionType;

@interface ZBBasePackage : NSObject
@property (nonatomic) NSString *authorName;
@property (nonatomic) NSString *identifier;
@property (nonatomic) NSDate   *lastSeen;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *packageDescription;
@property (nonatomic) int16_t role;
@property (nonatomic) NSString *section;
@property (nonatomic) NSString *uuid;
@property (nonatomic) NSString *version;
@end

@interface ZBPackage : ZBBasePackage
- (NSArray *_Nullable)possibleExtraActions;
@end

@interface ZBSettings : NSObject
+ (NSArray *)wishlist;
+ (void)setWishlist:(NSArray *)wishlist;
@end

@interface ZBConsoleViewController
- (void)finishTasks;
@end

%hook ZBPackage
- (NSArray *_Nullable)possibleExtraActions {
	NSMutableArray *actions = [%orig() mutableCopy];

	if (![actions containsObject:@(ZBPackageExtraActionAddWishlist)] && ![actions containsObject:@(ZBPackageExtraActionRemoveWishlist)]) {
		if (![[%c(ZBSettings) wishlist] containsObject:[self identifier]]) {
            [actions addObject:@(ZBPackageExtraActionAddWishlist)];
        }
        else {
            [actions addObject:@(ZBPackageExtraActionRemoveWishlist)];
        }
	}

	return [actions sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
}
%end

%hook ZBConsoleViewController
- (void)finishTasks {
	NSMutableArray *wishlist = [[%c(ZBSettings) wishlist] mutableCopy];
	%orig;
	[%c(ZBSettings) setWishlist:wishlist];
	// note that the orig currently doesn't remove installed packages from the whitelist
	// but it is unintended ommission on their part, so I do this future-proofly, in case that changes in the future
}
%end
