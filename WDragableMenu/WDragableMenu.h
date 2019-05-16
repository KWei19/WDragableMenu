//
//  WDragableMenu.h
//  WDragableMenu
//
//  Created by Boo Kiao Wei on 22/3/19.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
#import "CollectionHeaderView.h"

typedef enum WDragableMenuType{
    OnlyReorder, ReoderAndEditable
}WDragableMenuType;

@protocol WDragableMenuDelegate <NSObject>
@required
/**
 delegate to get total items display at first section
 */
- (NSInteger)totalItemsInPrimarySection
NS_SWIFT_NAME(totalItemsInPrimarySection());

/**
 delegate to get what text is going to display for menu cell at first section
 */
- (nonnull NSString *)getTitleForCellInPrimarySection:(NSInteger)selectedItem
NS_SWIFT_NAME(getTitleForCellInPrimarySection(selectedItem:));

/**
 to notify user when the sequence of menu is changed.
 */
- (void)userUpdatedMenuSequence
NS_SWIFT_NAME(userUpdatedMenuSequence());

/**
 Tap on menu item and give action.
 */
- (void)tapOnMenuItem:(NSInteger)selectedIndex
NS_SWIFT_NAME(tapOnMenuItem(selectedIndex:));

/**
 delegate to update the order of array in first section : reorder menu action is triggered
 */
- (void)updateSequenceOfArrayWithOriginalIndex:(NSInteger)originalIndex withDestinationIndex:(NSInteger) destinationIndex
NS_SWIFT_NAME(updateSequenceOfArrayWith(originalIndex:destinationIndex:));

@optional
/**
 WHEN WDragableMenuType is "ReoderAndEditable"
 delegate to get total items display at second section
 */
- (NSInteger)totalItemsInSecondarySection
NS_SWIFT_NAME(totalItemsInSecondarySection());

/**
 WHEN WDragableMenuType is "ReoderAndEditable"
 delegate to get what text is going to display for menu cell at second section
 */
- (nonnull NSString *)getTitleForCellInSecondarySection:(NSInteger)selectedItem
NS_SWIFT_NAME(getTitleForCellInSecondarySection(selectedItem:));

/**
 WHEN WDragableMenuType is "ReoderAndEditable"
 delegate to add menu item to first section
 */
- (void)addItemWithSelectedIndex:(NSInteger)selectedIndex
NS_SWIFT_NAME(addItemWith(selectedIndex:));

/**
 WHEN WDragableMenuType is "ReoderAndEditable"
 delegate to remove menu item from first section
 */
- (void)removeItemWithSelectedIndex:(NSInteger)selectedIndex
NS_SWIFT_NAME(removeItemWith(selectedIndex:));

@end

@interface WDragableMenu : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CollectionViewCellDelegate>

/** dragableMenuDelegate
 delegate function will be used when the ordering of items is changed
 */
@property (nonatomic, weak) id<WDragableMenuDelegate> dragableMenuDelegate;
@property (nonatomic, assign) NSString *titleVC;
@property (nonatomic, assign) NSString *titleForFirstSection;
@property (nonatomic, assign) NSString *titleForSecondSection;
@property (nonatomic, assign) NSString *titleBtnEdit;

/** numItemsPerRow
  A value to define how many items display per Row

  Default value is 4 if do not set any value for it
  If value is smaller than 0, default value will be taken
 */
@property (nonatomic, assign) NSInteger numItemsPerRow;

/** numItemsFreeze
 A value to define how many items are immovable
 
 Default value is 2 if do not set any value for it
 If value is smaller than 0, default value will be taken
*/
@property (nonatomic, assign) NSInteger numItemsFreeze;

/** typeMenu
 A enum value to decide how collectionMenu to display
 
 "OnlyReoder" - there's one section of menu to display, only able to reoder the sequence
 "ReoderAndEditable" - there's two sections of menu to display, able to reoder the sequence and add/remove for menu sequence

 Default value is "OnlyReoder" if do not set any value for it
*/
@property (nonatomic, assign) WDragableMenuType typeMenu;

/** isCellAnimationEnabled
 A value to control animation for menuitem
 
 Default value is YES if do not set any value for it
 */
@property (nonatomic, assign) BOOL isCellAnimationEnabled;

@end
