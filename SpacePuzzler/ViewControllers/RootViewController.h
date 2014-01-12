//
//  RootViewController.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 6/13/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmmoSelectViewController.h"
#import "AmmoView.h"

@interface RootViewController : UIViewController {

}

@property (assign) NSInteger levelNum;
@property (strong, nonatomic) IBOutlet AmmoView *ammoView;
@property (weak, nonatomic) IBOutlet UIButton *ammoSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *moveLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *moveRightButton;
@property (weak, nonatomic) IBOutletCollection(UIButton) NSMutableArray *ammoSelectButtons;

- (IBAction)ammoTapped:(id)sender;
- (IBAction)moveStart:(id)sender;
- (IBAction)moveEnd:(id)sender;

@end
