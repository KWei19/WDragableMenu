//
//  ViewController.m
//  Example
//
//  Created by Boo Kiao Wei on 22/3/19.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *data1;
@property (strong, nonatomic) NSMutableArray *data2;
@property (strong, nonatomic) WDragableMenu *menuVC;
@property (strong, nonatomic) UITextView *textView;
@end

@implementation ViewController

- (WDragableMenu *)menuVC {
    if (!_menuVC)
    {
        _menuVC = [[WDragableMenu alloc] init];
        [_menuVC setTypeMenu:ReoderAndEditable];
        [_menuVC setIsCellAnimationEnabled:YES];
        [_menuVC setDragableMenuDelegate:self];
    }
    return _menuVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.navigationController setNavigationBarHidden:YES];
    [self setTitle:@"My App"];
    NSArray *sectionArray = @[@"首页", @"即时", @"视频", @"系列节目", @"播客", @"娱乐", @"生活", @"财经", @"言论", @"互动新闻"];
    
    //first type of data
    self.data1 = [NSMutableArray array];
    for (NSString *str in sectionArray)
    {
        [self.data1 addObject: str];
    }
    
    //second type of data
    self.data2 = [NSMutableArray array];
    for (NSInteger i = 11; i <= 90; i++)
    {
        NSString *menu = [NSString stringWithFormat:@"%lu", i];
        [self.data2 addObject: menu];
    }

    UIButton *btnShowMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShowMenu setFrame:CGRectMake(10, 10, 100, 30)];
    [btnShowMenu setBackgroundColor:[UIColor redColor]];
    [btnShowMenu setTitle:@"Show Menu" forState:UIControlStateNormal];
    [btnShowMenu addTarget:self action:@selector(displayCollectionMenuView) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnShowMenu];
    
    btnShowMenu.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat topConstant = UIApplication.sharedApplication.statusBarFrame.size.height +  self.navigationController.navigationBar.frame.size.height+10;
    [btnShowMenu.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:topConstant].active = YES;
    [btnShowMenu.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [btnShowMenu.widthAnchor constraintEqualToConstant:100.0].active = YES;
    [btnShowMenu.heightAnchor constraintEqualToConstant:30.0].active = YES;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(10, 10, 100, 30)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"Print Array" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(printArray) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn.topAnchor constraintEqualToAnchor:btnShowMenu.bottomAnchor constant:10.0].active = YES;
    [btn.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [btn.widthAnchor constraintEqualToConstant:100.0].active = YES;
    [btn.heightAnchor constraintEqualToConstant:30.0].active = YES;
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [self.view addSubview:self.textView];
    
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.textView.topAnchor constraintEqualToAnchor:btn.bottomAnchor constant:40.0].active = YES;
    [self.textView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.textView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:10.0].active = YES;
    [self.textView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
}

-(void)displayCollectionMenuView
{
    [self presentViewController:self.menuVC animated:YES completion:nil];
//    [self.navigationController pushViewController:self.menuVC animated:YES];
}

-(void)printArray
{
    NSMutableArray *sectionArray1 = [NSMutableArray array];
    for (NSString* menu in self.data1)
    {
        [sectionArray1 addObject:menu];
    }
    
    NSMutableArray *sectionArray2 = [NSMutableArray array];
    for (NSString* menu in self.data2)
    {
        [sectionArray2 addObject:menu];
    }
    
    [self.textView setText: [NSString stringWithFormat:@"%@\n%@", sectionArray1 , sectionArray2]];
}

#pragma mark - WDragablemenuDelegate Method
- (void)userUpdatedMenuSequence
{
    [self printArray];
}

-(void)tapOnMenuItem:(NSInteger)selectedIndex
{
    NSString* selectedMenu = [self.data1 objectAtIndex:selectedIndex];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已选目录：" message:selectedMenu preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleCancel
                                handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)totalItemsInPrimarySection
{
    return self.data1.count;
}

- (NSInteger)totalItemsInSecondarySection
{
    return self.data2.count;
}

- (NSString *)getTitleForCellInPrimarySection:(NSInteger)selectedItem
{
    return [self.data1 objectAtIndex:selectedItem];
}

- (NSString *)getTitleForCellInSecondarySection:(NSInteger)selectedItem
{
    return [self.data2 objectAtIndex:selectedItem];
}

- (void)updateSequenceOfArrayWithOriginalIndex:(NSInteger)originalIndex withDestinationIndex:(NSInteger)destinationIndex
{
    NSString* sourceObject = [self.data1 objectAtIndex:originalIndex];
    [self.data1 removeObjectAtIndex:originalIndex];
    [self.data1 insertObject:sourceObject atIndex:destinationIndex];
}

- (void)addItemWithSelectedIndex:(NSInteger)selectedIndex
{
    //add new item to primary section
    NSString* addItem = [self.data2 objectAtIndex:selectedIndex];
    [self.data1 addObject:addItem];
    
    //remove item from secondary section
    [self.data2 removeObjectAtIndex:selectedIndex];
}

-(void)removeItemWithSelectedIndex:(NSInteger)selectedIndex
{
    NSString* removeObject = [self.data1 objectAtIndex:selectedIndex];
    [self.data1 removeObject:removeObject];
    [self.data2 insertObject:removeObject atIndex:0];
}



@end
