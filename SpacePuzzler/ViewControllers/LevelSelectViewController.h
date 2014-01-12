//
//  LevelSelectViewController.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 9/19/13.
//
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface LevelSelectViewController : UIViewController

@property (strong) RootViewController *rootViewController;

- (IBAction)levelTapped:(id)sender;

@end
