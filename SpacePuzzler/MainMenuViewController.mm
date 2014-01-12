//
//  MainMenuViewController.m
//  SpacePuzzler
//
//  Created by Zachary Reik on 9/18/13.
//
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"menuBG0.png"]]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

// Add new method
- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)startGame:(id)arg {
    if (_rootViewController == nil) {
        self.rootViewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    }
    [self.navigationController pushViewController:_rootViewController animated:YES];
}

- (IBAction)playTapped:(id)sender {
    NSLog(@"1");
    if (self.levelSelectViewController == nil){
        self.levelSelectViewController = [[LevelSelectViewController alloc] initWithNibName:nil bundle:nil];
    }
    [self.navigationController pushViewController:self.levelSelectViewController animated:YES];
}

@end
