//
//  WDragableMenu.m
//  WDragableMenu
//
//  Created by Boo Kiao Wei on 22/3/19.
//

#import "WDragableMenu.h"

#define VCTitle @"目录"
#define HeaderTitle1 @"我的目录"
#define HeaderTitle2 @"更多的目录"
#define BtnTitle @"编辑"
#define DefaultNumIteminRow 4
#define DefaultNumItemFreeze 2
#define DefaultSpaceCell 7
#define HeightRatioCell 2.2
#define HeaderEditSubTitle1 @"   拖动进行排序"
#define HeaderSubTitle1 @"   点击进入目录"
#define HeaderSubTitle2 @"   点击添加目录"

@interface WDragableMenu ()
@property (nonatomic, strong) UIView *navBarView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@end

static NSString * const WDragableCellIdentifier = @"WdragableCellIdentifier";
static NSString * const WDragableHeaderIdentifier = @"WdragableHeaderIdentifier";
static CGFloat const WHeightNavBarView = 40.0;

@implementation WDragableMenu

BOOL isEditModeEnabled = NO;
BOOL isUpdated = NO;
BOOL isNavHidden = NO;

#pragma mark - Life Cycle
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setupDefault];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        [self setupDefault];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithNibName:nil bundle:nil];
}

- (void)setupDefault
{
    self.titleVC = VCTitle;
    self.titleForFirstSection = HeaderTitle1;
    self.titleForSecondSection = HeaderTitle2;
    self.titleBtnEdit = BtnTitle;
    self.numItemsPerRow = DefaultNumIteminRow;
    self.numItemsFreeze = DefaultNumItemFreeze;
    self.isCellAnimationEnabled = YES;
    self.typeMenu = OnlyReorder;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self addNavigationBarViewWithConstraint];
    [self addCollectionMenuViewWithConstraint];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
        } completion:NULL];
    } completion:NULL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //if the app do have its own navigation bar and app do not hide its navigationBar hidden
    if (self.navigationController && !self.navigationController.isNavigationBarHidden)
    {
        isNavHidden = YES;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //if the app do have its own navigation bar
    if (self.navigationController && isNavHidden)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark - Setter and Getter Methods
-(void)setNumItemsPerRow:(NSInteger)numItemsPerRow
{
    _numItemsPerRow = numItemsPerRow <= 0 ? DefaultNumIteminRow : numItemsPerRow;
}

-(void)setNumItemsFreeze:(NSInteger)numItemsFreeze
{
    _numItemsFreeze = numItemsFreeze < 0 ? DefaultNumItemFreeze : numItemsFreeze;
}

-(void)setTypeMenu:(WDragableMenuType)typeMenu
{
    _typeMenu = typeMenu == nil ? OnlyReorder : typeMenu;
}

#pragma mark - Lazy Methods
- (UIView *)navBarView
{
    if (!_navBarView)
    {
        _navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, WHeightNavBarView)];
        _navBarView.translatesAutoresizingMaskIntoConstraints = NO;

        //Add Title Label
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0, 20.0)];
        [lblTitle setText:_titleVC];
        [lblTitle setTextAlignment:NSTextAlignmentCenter];
        [lblTitle setTextColor:[UIColor blackColor]];
        [lblTitle setFont:[UIFont boldSystemFontOfSize:20.0]];
        [_navBarView addSubview:lblTitle];
        
        lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
        [lblTitle.centerYAnchor constraintEqualToAnchor:_navBarView.centerYAnchor].active = YES;
        [lblTitle.centerXAnchor constraintEqualToAnchor:_navBarView.centerXAnchor].active = YES;
        [lblTitle.widthAnchor constraintEqualToConstant:100.0].active = YES;
        [lblTitle.heightAnchor constraintEqualToConstant:20.0].active = YES;

        CGFloat buttonSize = 44.0;
        CGFloat buttonEdgeInset = buttonSize * 0.2;
        UIButton* btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnClose setFrame:CGRectMake(0, 0, buttonSize, buttonSize)];
        [btnClose setImage:[UIImage imageNamed:@"done-button.png"]  forState:UIControlStateNormal];
        [btnClose setImageEdgeInsets:UIEdgeInsetsMake(buttonEdgeInset, buttonEdgeInset, buttonEdgeInset, buttonEdgeInset)];
        [btnClose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(onTapCloseButton) forControlEvents:UIControlEventTouchDown];
        [_navBarView addSubview:btnClose];
        
        btnClose.translatesAutoresizingMaskIntoConstraints = NO;
        [btnClose.centerYAnchor constraintEqualToAnchor:lblTitle.centerYAnchor].active = YES;
        [btnClose.trailingAnchor constraintEqualToAnchor:_navBarView.trailingAnchor constant:-8].active = YES;
        [btnClose.widthAnchor constraintEqualToConstant:44.0].active = YES;
        [btnClose.heightAnchor constraintEqualToConstant:44.0].active = YES;
    }
    return _navBarView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        // 初始化UICollectionViewFlowLayout对象，设置集合视图滑动方向。
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumLineSpacing = 20;
        _flowLayout.minimumInteritemSpacing = 10;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, DefaultSpaceCell, 0, DefaultSpaceCell);
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:WDragableCellIdentifier];
        [_collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WDragableHeaderIdentifier];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (UILongPressGestureRecognizer *)longPressGesture
{
    if (!_longPressGesture)
    {
        _longPressGesture.minimumPressDuration = 0.1;
        _longPressGesture =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dragToReorderMenuWithGesture:)];
    }
    return _longPressGesture;
}

#pragma mark - Add View
-(void)addNavigationBarViewWithConstraint
{
    [self.view addSubview:self.navBarView];
    
    //update constraint
    if (@available(iOS 11.0, *))
    {
        [self.navBarView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
        [self.navBarView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
        [self.navBarView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
    }
    else
    {
        [self.navBarView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
        [self.navBarView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
        [self.navBarView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    }
    [self.navBarView.heightAnchor constraintEqualToConstant:WHeightNavBarView].active = YES;
}

-(void)addCollectionMenuViewWithConstraint
{
    [self.view addSubview:self.collectionView];
    
    //update constraint
    [self.collectionView.topAnchor constraintEqualToAnchor:self.navBarView.bottomAnchor].active = YES;
    if (@available(iOS 11.0, *))
    {
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
    }
    else
    {
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    }
    [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

- (void)dragToReorderMenuWithGesture:(UILongPressGestureRecognizer *)longPressGesture
{
    CGPoint touchPoint = [longPressGesture locationInView:self.collectionView];
    NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:touchPoint];

    switch (longPressGesture.state)
    {
        case UIGestureRecognizerStateBegan:
            if ([selectedIndexPath section] == 0 && [selectedIndexPath item] >= self.numItemsFreeze)
            {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
            }
            break;
            
        case UIGestureRecognizerStateChanged:
            [self.collectionView updateInteractiveMovementTargetPosition:touchPoint];
            break;
            
        case UIGestureRecognizerStateEnded:
            if ([selectedIndexPath section] == 0 && [selectedIndexPath item] >= self.numItemsFreeze)
            {
                [self.collectionView endInteractiveMovement];
            }
            else
            {
                [self.collectionView cancelInteractiveMovement];
            }
            break;
            
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath
{
    if ([proposedIndexPath section] == 0 && [proposedIndexPath item] >= self.numItemsFreeze)
    {
        return proposedIndexPath;
    }
    else
    {
        return originalIndexPath;
    }
}

#pragma mark - UICollectionView - Section Header
#pragma mark Size for Section Header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), 75);
}


#pragma mark UICollectionReusableView for Section header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CollectionHeaderView *sectionHeaderView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        // 设置header内容。
        sectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WDragableHeaderIdentifier forIndexPath:indexPath];
        sectionHeaderView.sectionHeaderDelegate = self;
    }
    
    if ([indexPath section] == 1)
    {
        NSMutableAttributedString *attributeHeaderString = [[NSMutableAttributedString alloc] initWithString:self.titleForSecondSection attributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:18.0]}];
        if (isEditModeEnabled)
        {
            NSAttributedString *subTitle = [[NSAttributedString alloc] initWithString:HeaderSubTitle2 attributes:@{ NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
            [attributeHeaderString appendAttributedString:subTitle];
        }
        
        [sectionHeaderView.lblSectionTitle setAttributedText:attributeHeaderString];
        [sectionHeaderView.btnEdit setHidden:YES];
    }
    else
    {
        [sectionHeaderView.btnEdit setHidden:NO];
        [sectionHeaderView.btnEdit setSelected:isEditModeEnabled];
        
        NSMutableAttributedString *attributeHeaderString = [[NSMutableAttributedString alloc] initWithString:self.titleForFirstSection attributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:18.0]}];
        NSAttributedString *subTitle;
        if (isEditModeEnabled)
        {
            subTitle = [[NSAttributedString alloc] initWithString:HeaderEditSubTitle1 attributes:@{ NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
        }
        else
        {
            subTitle = [[NSAttributedString alloc] initWithString:HeaderSubTitle1 attributes:@{ NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
        }
        [attributeHeaderString appendAttributedString:subTitle];
        [sectionHeaderView.lblSectionTitle setAttributedText:attributeHeaderString];
    }
    return sectionHeaderView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.typeMenu == ReoderAndEditable)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.typeMenu == OnlyReorder)
    {
        return [self.dragableMenuDelegate totalItemsInPrimarySection];
    }
    else
    {
        if (section == 0)
        {
            return [self.dragableMenuDelegate totalItemsInPrimarySection];
        }
        else
        {
            return [self.dragableMenuDelegate totalItemsInSecondarySection];
        }
    }
}

#pragma mark - UICollectionView - UICollectionViewCell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger width = self.collectionView.frame.size.width;
    CGFloat widthCell = (width - self.numItemsPerRow * 2 * DefaultSpaceCell) / self.numItemsPerRow;
    return CGSizeMake(widthCell, widthCell/HeightRatioCell);
}

#pragma mark - UICollectionView - UICollectionViewCell
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WDragableCellIdentifier forIndexPath:indexPath];
    cell.cellDelegate = self;
    if ([indexPath section] == 0)
    {
        if ([indexPath item] > [self.dragableMenuDelegate totalItemsInPrimarySection]) { return nil; }
        
        NSString* menuText = [self.dragableMenuDelegate getTitleForCellInPrimarySection:[indexPath item]];
        
        BOOL isFreezeItem = [indexPath item] < self.numItemsFreeze;
        UIColor *textColour = isFreezeItem ? [UIColor redColor] : [UIColor blackColor];
        
        eCellMode cm = eCellModeView; //default cell mode
        if (isEditModeEnabled && self.typeMenu == OnlyReorder && !isFreezeItem)
        {
            cm = eCellModeOnlyReoderable;
        }
        else if (isEditModeEnabled && self.typeMenu == ReoderAndEditable && !isFreezeItem)
        {
            cm = eCellModeDeletable;
        }
        [cell configCellContentWithContent:menuText textColor:textColour cellMode:cm animation:self.isCellAnimationEnabled];
    }
    else
    {
        if ([indexPath item] > [self.dragableMenuDelegate totalItemsInSecondarySection]) { return nil; }
        
        NSString* menuText = [self.dragableMenuDelegate getTitleForCellInSecondarySection:[indexPath item]];
        
        eCellMode cm = isEditModeEnabled ? eCellModeAddable : eCellModeView;
        [cell configCellContentWithContent:menuText textColor:[UIColor blackColor] cellMode:cm animation:self.isCellAnimationEnabled];
    }
    return cell;
}


#pragma mark - Adjust Layout for UICollectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEditModeEnabled && self.typeMenu == ReoderAndEditable)
    {
        [self addSelectedItemToAnotherSection:indexPath];
    }
    else if (!isEditModeEnabled)
    {
        if ([indexPath section] == 0)
        {
            if (self.dragableMenuDelegate && [self.dragableMenuDelegate respondsToSelector:@selector(tapOnMenuItem:)])
            {
                [self onTapCloseButton];
                [self.dragableMenuDelegate tapOnMenuItem:[indexPath item]];
            }
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath item] >= self.numItemsFreeze)
    {
        return YES;
    }
    return NO;
}

/** Update sequence of array after reoder*/
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if ([sourceIndexPath item] > [self.dragableMenuDelegate totalItemsInPrimarySection]) { return; }

    if ([sourceIndexPath section] == [destinationIndexPath section])
    {
        isUpdated = YES;
        [self.dragableMenuDelegate updateSequenceOfArrayWithOriginalIndex:[sourceIndexPath item] withDestinationIndex:[destinationIndexPath item]];
    }
}

#pragma mark - IBAction Function
-(void)onTapCloseButton
{
    if (self.navigationController) { [self.navigationController popViewControllerAnimated:YES]; }
    else if (self.presentingViewController) { [self dismissViewControllerAnimated:YES completion:NULL]; }
}

#pragma mark - Delegate method from CollectionSectionHeaderView
-(void)actionForEditButton:(id)sender
{
    isEditModeEnabled = !isEditModeEnabled;
    if (isEditModeEnabled)
    {
        [self.collectionView addGestureRecognizer: self.longPressGesture];
    }
    else
    {
        [self.collectionView removeGestureRecognizer:self.longPressGesture];
        if (isUpdated)
        {
            isUpdated = false;
            if (self.dragableMenuDelegate && [self.dragableMenuDelegate respondsToSelector:@selector(userUpdatedMenuSequence)])
            {
                [self.dragableMenuDelegate userUpdatedMenuSequence];
            }
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - Delegate from CollectionViewCell
-(void)actionRemoveItem:(id)sender
{
    UITapGestureRecognizer * gesture = sender;
    CGPoint point = [gesture locationInView:self.collectionView];

    NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:point];
    [self addSelectedItemToAnotherSection:selectedIndexPath];
}

-(void)addSelectedItemToAnotherSection:(NSIndexPath *)indexPath
{
    isUpdated = YES;
    NSIndexPath *newIndexPath;
    
    if ([indexPath section] == 0)
    {
        if ([indexPath item] < 0 || [indexPath item] > [self.dragableMenuDelegate totalItemsInPrimarySection]) { return; }

        [self.dragableMenuDelegate removeItemWithSelectedIndex:[indexPath item]];
        newIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    else
    {
        if ([indexPath item] < 0 || [indexPath item] > [self.dragableMenuDelegate totalItemsInSecondarySection]) { return; }
        
        isUpdated = YES;
        [self.dragableMenuDelegate addItemWithSelectedIndex:[indexPath item]];
        //create new item index path
        newIndexPath = [NSIndexPath indexPathForRow:[self.dragableMenuDelegate totalItemsInPrimarySection]-1 inSection:0];
    }
    
    //check newIndexPath to avoid crash
    if (newIndexPath)
    {
        __weak WDragableMenu *weakSelf = self;
        [self.collectionView performBatchUpdates:^{
            [weakSelf.collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
        } completion:^(BOOL finished) {
            [weakSelf.collectionView reloadItemsAtIndexPaths:@[newIndexPath]];
        }];
    }
}

@end
