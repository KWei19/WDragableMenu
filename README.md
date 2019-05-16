# WDragableMenu

WDragableMenu is able reorder the position of item by drag and drop action.  WDragableMenu also provide two sections for user, user able to add/remove item to/from first section. 

## Preview

<img src="ihttps://github.com/KWei19/WDragableMenu/blob/master/demo.gif" width="222" height="480"/>


## Installation
Clone the repo, and run *pod install* at *Example* directory.


## Introduction

### Initialization for **WDragableMenu** 
At First, need to init WDragableMenu class and set delegate

```objective-c
- (WDragableMenu *)menuVC {
if (!_menuVC)
{
    _menuVC = [[WDragableMenu alloc] init];
    [_menuVC setTypeMenu:ReoderAndEditable];
    [_menuVC setIsCellAnimationEnabled:NO];
    [_menuVC setDragableMenuDelegate:self];
}
return _menuVC;
}
```

```swift
private lazy var menuVC: WDragableMenu = {
    let menuVC = WDragableMenu()
    menuVC.typeMenu = OnlyReorder
    menuVC.dragableMenuDelegate = self
    return menuVC
}()
```

### Protocol **WDragableMenuDelegate**

`@required`
1. `- (NSInteger)totalItemsInPrimarySection` - Delegate to get total items to display at primary section

2. `- (nonnull NSString *)getTitleForCellInPrimarySection:(NSInteger)selectedItem` - Delegate to get what text is going to display for menu cell at first section

3. `- (void)userUpdatedMenuSequence` - to notify user when the sequence of menu is changed

4. `- (void)tapOnMenuItem:(NSInteger)selectedIndex` - delegate action when click on menu item

5. `- (void)updateSequenceOfArrayWithOriginalIndex:(NSInteger)originalIndex withDestinationIndex:(NSInteger) destinationIndex` - delegate to update the order of array in first section : reorder menu action is triggered

`@optional` - Is needed WHEN WDragableMenuType is **ReoderAndEditable**

6. `- (NSInteger)totalItemsInSecondarySection` - delegate to get total items display at second section

7. `- (nonnull NSString *)getTitleForCellInSecondarySection:(NSInteger)selectedItem` - delegate to get what text is going to display for menu cell at second section

8. `- (void)addItemWithSelectedIndex:(NSInteger)selectedIndex` - delegate to add menu item from second second to first section

9. `- (void)removeItemWithSelectedIndex:(NSInteger)selectedIndex` - delegate to remove menu item from first section



### Property of WDragableMenu 
#### WDragableMenuType
`@property (nonatomic, assign) WDragableMenuType typeMenu;`
A enum value to decide how collectionMenu to display

**OnlyReoder** - there's one section of menu to display, only able to reoder the sequence
**ReoderAndEditable** - there's two sections of menu to display, able to reoder the sequence and add/remove for menu sequence

Default value is "OnlyReoder" if do not set any value for it


#### numItemsFreeze
`@property (nonatomic) NSInteger numItemsFreeze;`
*numItemsFreeze* provided a control to app to decide how many items of first section to be freezed. *Default is **first two items***
Example:
````objective-c
self.numItemsFreeze = 3;
````

#### numItemsinRow
`@property (nonatomic) NSInteger numItemsinRow;`
*numItemsinRow* provided a control to display how many items in one row. *Default is **4***
Example:
````objective-c
self.numItemsinRow = 3;
````

#### isCellAnimationEnabled
`@property (nonatomic, assign) BOOL isCellAnimationEnabled;`
*isCellAnimationEnabled* is a value to control animation for menuitem. *Default value is **YES***
Example:
````objective-c
self.isCellAnimationEnabled = NO;
````


## Reference 
https://mobikul.com/ios-longpress-drag-and-drop-using-uicollectionview-with-animation/


## License 
WDragableMenu is available under the MIT license. See the LICENSE file for more info.


