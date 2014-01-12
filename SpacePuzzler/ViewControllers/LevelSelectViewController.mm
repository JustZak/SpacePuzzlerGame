//
//  LevelSelectViewController.m
//  SpacePuzzler
//
//  Created by Zachary Reik on 9/19/13.
//
//

#import "LevelSelectViewController.h"

@interface LevelSelectViewController ()

@end

@implementation LevelSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (IBAction)levelTapped:(id)sender {
    UIButton* button = (UIButton*)sender;
    [self startGame:button.tag];
}

- (void)startGame:(NSInteger)levelNum {
    if (_rootViewController == nil) {
        self.rootViewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    }
    self.rootViewController.levelNum = levelNum;
    [self.navigationController pushViewController:_rootViewController animated:YES];
}
@end
