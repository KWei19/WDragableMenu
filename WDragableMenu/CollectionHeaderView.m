//
//  CollectionHeaderView.m
//  WDragableMenu
//
//  Created by Boo Kiao Wei on 22/3/19.
//

#import "CollectionHeaderView.h"

@implementation CollectionHeaderView

//life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化label，设置文字颜色，最后添加label到重用视图。
        self.btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnEdit.layer.borderWidth = 1.0f;
        self.btnEdit.layer.borderColor = [UIColor clearColor].CGColor;
        self.btnEdit.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.btnEdit.layer.shadowOffset = CGSizeMake(0, 2.0f);
        self.btnEdit.layer.cornerRadius = 12.0f;
        
        [self.btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
        [self.btnEdit setTitle:@"完成" forState:UIControlStateSelected];
        [self.btnEdit setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.btnEdit setBackgroundColor:[UIColor colorWithRed:255/255.0 green:230/255.0 blue:240/255.0 alpha:1]];
        [self.btnEdit addTarget:self action:@selector(onTapEditButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnEdit.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [self addSubview:self.btnEdit];
        
        self.btnEdit.translatesAutoresizingMaskIntoConstraints = NO;
        [self.btnEdit.widthAnchor constraintEqualToConstant:65].active = YES;
        [self.btnEdit.heightAnchor constraintEqualToConstant:30].active = YES;

        [self.btnEdit.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8].active = YES;
        [self.btnEdit.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-20].active = YES;

        self.lblSectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200, 10.0)];
        [self.lblSectionTitle setTextColor:[UIColor redColor]];
        [self addSubview:self.lblSectionTitle];
        
        self.lblSectionTitle.translatesAutoresizingMaskIntoConstraints = NO;
        [self.lblSectionTitle.trailingAnchor constraintEqualToAnchor:self.btnEdit.leadingAnchor constant:-20].active = YES;
        [self.lblSectionTitle.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8].active = YES;
        [self.lblSectionTitle.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-20].active = YES;
        [self.lblSectionTitle.heightAnchor constraintEqualToConstant:15.0].active = YES;
    }
    return self;
}

-(void)onTapEditButton:(id)sender
{
    [self.sectionHeaderDelegate actionForEditButton:sender];
}

@end
