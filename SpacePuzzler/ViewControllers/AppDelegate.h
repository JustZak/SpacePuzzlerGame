//
//  AppDelegate.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 6/13/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
