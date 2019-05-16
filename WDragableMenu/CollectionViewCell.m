//
//  CollectionViewCell.m
//  WDragableMenu
//
//  Created by Boo Kiao Wei on 22/3/19.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
static NSString * const animationKey = @"animation";

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:230/255.0 green:236/255.0 blue:250/255.0 alpha:1];

        self.contentView.layer.borderWidth = 1.0f;
        self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2.0f);
        self.layer.cornerRadius = 15.0f;

        CGFloat cellWidth = self.bounds.size.width;
        CGFloat cellHeight = self.bounds.size.height;

        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
        self.lblTitle.textAlignment = NSTextAlignmentCenter;
        [self.lblTitle setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:self.lblTitle];
        
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
        [self.lblTitle.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:4.0].active = YES;
        [self.lblTitle.topAnchor constraintEqualToAnchor:self.topAnchor constant:4.0].active = YES;
        [self.lblTitle.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-4.0].active = YES;
        [self.lblTitle.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-4.0].active = YES;
        
        //Remove icon for cell
        self.btnRemove = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnRemove setFrame:CGRectMake(0, 0, 15.0, 15.0)];

        UITapGestureRecognizer *tapRemoveGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeItem:)];
        [self.btnRemove addGestureRecognizer:tapRemoveGestureRecognizer];

        UIImage *imageClose = [UIImage imageNamed:@"close-button"];
        [self.btnRemove setBackgroundImage:imageClose forState:UIControlStateNormal];
        [self addSubview:self.btnRemove];
        
        self.btnRemove.translatesAutoresizingMaskIntoConstraints = NO;
        [self.btnRemove.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:5.0].active = YES;
        [self.btnRemove.topAnchor constraintEqualToAnchor:self.topAnchor constant:-5.0].active = YES;
        [self.btnRemove.widthAnchor constraintEqualToConstant:15.0].active = YES;
        [self.btnRemove.heightAnchor constraintEqualToConstant:15.0].active = YES;
    }
    return self;
}

-(void)configCellContentWithContent:(NSString *)title textColor:(UIColor *)textColour cellMode:(eCellMode)cellMode animation:(BOOL)isAnimatedOn
{
    switch (cellMode)
    {
        case eCellModeView:
        {
            [self.lblTitle setText:title];
            [self.lblTitle setTextColor:textColour];
            [self.btnRemove setHidden:YES];
            if (isAnimatedOn)
            {
                [self stopAnimation];
            }
            break;
        }
        case eCellModeOnlyReoderable:
        {
            [self.lblTitle setText:title];
            [self.lblTitle setTextColor:textColour];
            [self.btnRemove setHidden:YES];
            if (isAnimatedOn)
            {
                [self addAnimation];
            }
            break;
        }
        case eCellModeAddable:
        {
            NSString *updatedTitle = [NSString stringWithFormat:@"+ %@", title];
            [self.lblTitle setAttributedText:[self addAttributeForTitle:updatedTitle]];
            [self.btnRemove setHidden:YES];
            break;
        }
        case eCellModeDeletable:
        {
            [self.lblTitle setText:title];
            [self.lblTitle setTextColor:textColour];
            [self.btnRemove setHidden:NO];
            if (isAnimatedOn)
            {
                [self addAnimation];
            }
            break;
        }
        default: break;
    }
}

-(NSMutableAttributedString *) addAttributeForTitle:(NSString *) titleString
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:titleString attributes:@{ NSForegroundColorAttributeName:[UIColor blackColor]}];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 1)];
    return attributeString;
}

#pragma mark - Cell Animation Function
-(void)addAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.autoreverses = YES;
    animation.duration = 0.3;
    animation.repeatCount = 99999;
    
    float startAngle = -0.05 ;
    float stopAngle = -startAngle;
    
    animation.fromValue = [NSNumber numberWithFloat:startAngle];
    animation.toValue = [NSNumber numberWithFloat:stopAngle];
    
    [self.layer addAnimation:animation forKey:animationKey];
}

-(void)stopAnimation
{
    [self.layer removeAnimationForKey:animationKey];
}

#pragma mark - CollectionViewCellDelegate
-(void)removeItem:(id)sender
{
    [self.cellDelegate actionRemoveItem:sender];
}

@end
