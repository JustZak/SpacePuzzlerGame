//
//  RootViewController.m
//  SpacePuzzler
//
//  Created by Zachary Reik on 6/13/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"

#import "RootViewController.h"
#import "GameConfig.h"
#import "GameLayer.h"
#import "AmmoSelectViewController.h"
#import "ShootingGameLayer.h"

@implementation RootViewController

- (void)setupCocos2D {
    EAGLView *glView = [EAGLView viewWithFrame:self.view.bounds
                                   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
                                   depthFormat:0                        // GL_DEPTH_COMPONENT16_OES
                        ];
    glView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:glView atIndex:0];
    [[CCDirector sharedDirector] setOpenGLView:glView];
    CCScene *scene = [GameLayer scene:self level:self.levelNum];
    [[CCDirector sharedDirector] runWithScene:scene];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ammoView = [[AmmoView alloc] initWithFrame:CGRectMake(0, 1200, 400, 120)];
    self.ammoSelectButtons = self.ammoView.ammoButtons;
    for (UIButton* button in self.ammoSelectButtons){
        [button addTarget:self action:@selector(selectAmmo:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self setupCocos2D];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	// Custom initialization
	}
	return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	[super viewDidLoad];
 }
 */


// Override to allow orientations other than the default portrait orientation
//valid for iOS 4 and 5, IMPORTANT, for iOS6 also modify supportedInterfaceOrientations
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	//
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	//
	// EAGLView will be rotated by cocos2d
	//
	// Sample: Autorotate only in landscape mode
	//
	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	}
	
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	//
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in portrait mode
	//
	// return YES for the supported orientations
	
	return ( UIInterfaceOrientationIsPortrait( interfaceOrientation ) );
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	// Shold not happen
	return NO;
}

// these methods are needed for iOS 6
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000

-(NSUInteger)supportedInterfaceOrientations{
    //Modify for supported orientations, put your masks here, trying to mimic behavior of shouldAutorotate..
    #if GAME_AUTOROTATION==kGameAutorotationNone
	    return UIInterfaceOrientationMaskPortrait;
    #elif GAME_AUTOROTATION==kGameAutorotationCCDirector
    	NSAssert(NO, @"RootviewController: kGameAutorotation isn't supported on iOS6");
	    return UIInterfaceOrientationMaskLandscape;
    #elif GAME_AUTOROTATION == kGameAutorotationUIViewController
    	return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    	//for both landscape orientations return UIInterfaceOrientationLandscape
    #else 
    #error Unknown value in GAME_AUTOROTATION
	
	#endif // GAME_AUTOROTATION
}

#if GAME_AUTOROTATION==kGameAutorotationUIViewController
- (BOOL)shouldAutorotate {
    return YES;
}
#else 
- (BOOL)shouldAutorotate {
    return NO;
}
#endif

//__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
#else //deprecated in iOS6, so call only < 6. 
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[CCDirector sharedDirector] end];
}

#endif //__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
#endif 

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


// *************** NEW STUFF

- (IBAction)ammoTapped:(id)sender {
    
    [self.view addSubview:self.ammoView];
    
    CGRect ammoViewFrame = self.ammoView.frame;
    ammoViewFrame.origin.y = 850;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.ammoView.frame = ammoViewFrame;
    
    [UIView commitAnimations];
}

- (IBAction)moveStart:(id)sender {
    CCScene* scene = [[CCDirector sharedDirector] runningScene];
    GameLayer* layer = [scene.children objectAtIndex:0];
    UIButton* btn = (UIButton*)sender;
    [layer startMove: btn.tag];
}

- (IBAction)moveEnd:(id)sender {
    CCScene* scene = [[CCDirector sharedDirector] runningScene];
    GameLayer* layer = [scene.children objectAtIndex:0];
    [layer endMove];
}


- (void)selectAmmo:(UIButton*)sender {
    CCScene* scene = [[CCDirector sharedDirector] runningScene];
    GameLayer* layer = [scene.children objectAtIndex:0];
    NSLog(@"tag:%d", sender.tag);
    [layer selectAmmo:sender.tag];
    
    CGRect ammoViewFrame = self.ammoView.frame;
    ammoViewFrame.origin.y = 1200;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.ammoView.frame = ammoViewFrame;
                     }
                     completion:^(BOOL finished){
                         [self.ammoView removeFromSuperview];
                     }];
}


@end
