//
//  AmmoSelectViewController.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 9/26/13.
//
//

#import <UIKit/UIKit.h>

@class AmmoSelectViewController;

@protocol AmmoSelectVCDelegate <NSObject>

-(void)selectAmmo:(NSInteger)ammo controller:(AmmoSelectViewController*)controller;

@end

@interface AmmoSelectViewController : UIViewController

@property (nonatomic, weak) id<AmmoSelectVCDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *button;

- (IBAction)buttonTapped:(id)sender;

@end
