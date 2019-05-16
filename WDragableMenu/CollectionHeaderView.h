//
//  CollectionHeaderView.h
//  WDragableMenu
//
//  Created by Boo Kiao Wei on 22/3/19.
//

#import <UIKit/UIKit.h>

@protocol CollectionHeaderViewDelegate <NSObject>
-(void)actionForEditButton:(id)sender;
@end

@interface CollectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) UIButton *btnEdit;
@property (nonatomic, strong) UILabel *lblSectionTitle;
@property (nonatomic, weak) id<CollectionHeaderViewDelegate> sectionHeaderDelegate;

@end
