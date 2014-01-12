//
//  AmmoSelectViewController.m
//  SpacePuzzler
//
//  Created by Zachary Reik on 9/26/13.
//
//

#import "AmmoSelectViewController.h"

@interface AmmoSelectViewController ()

@end

@implementation AmmoSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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

- (IBAction)buttonTapped:(id)sender {
    UIButton* button = (UIButton*)sender;
    [self.delegate selectAmmo:button.tag controller:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
