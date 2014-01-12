//
//  MainMenuViewController.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 9/18/13.
//
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "LevelSelectViewController.h"

@interface MainMenuViewController : UIViewController

@property (strong) RootViewController *rootViewController;
@property (strong) LevelSelectViewController *levelSelectViewController;

- (IBAction)playTapped:(id)sender;

@end
