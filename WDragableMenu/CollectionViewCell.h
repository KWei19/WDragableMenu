//
//  CollectionViewCell.h
//  WDragableMenu
//
//  Created by Boo Kiao Wei on 22/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum eCellMode {
    eCellModeView, eCellModeOnlyReoderable, eCellModeDeletable, eCellModeAddable
} eCellMode;

@protocol CollectionViewCellDelegate <NSObject>
-(void)actionRemoveItem:(id)sender;
@end

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIButton *btnRemove;
@property (nonatomic, weak) id<CollectionViewCellDelegate> cellDelegate;

-(void)configCellContentWithContent:(NSString *)title textColor:(UIColor *)textColour cellMode:(eCellMode)cellMode animation:(BOOL)isAnimatedOn;

@end

NS_ASSUME_NONNULL_END
