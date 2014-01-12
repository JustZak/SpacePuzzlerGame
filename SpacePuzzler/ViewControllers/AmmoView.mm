//
//  AmmoSelectView.m
//  SpacePuzzler
//
//  Created by Zachary Reik on 10/10/13.
//
//

#import "AmmoView.h"

@implementation AmmoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.backgroundImage = [[UIImageView alloc] initWithFrame:rect];
        self.backgroundImage.image = [UIImage imageNamed:@"ammoBGsmall.png"];
        [self addSubview:self.backgroundImage];
        
        self.ammoButtons = [NSMutableArray array];
        
        float buttonWidth = frame.size.width /4;
        float buttonHeight = frame.size.height/2;
        float buttonX = 0;
        float buttonY = 0;
        float hGap = buttonWidth/4;
        float vGap = buttonHeight/3;
        float adjustedX;
        float adjustedY;
        CGRect buttonFrame;
        
        UIImage* buttonImage = [UIImage imageNamed:@"blueui3ww.png"];
        
        for (int i = 0; i < 3; i ++){
            adjustedX = buttonX + (buttonWidth * i) + (hGap * (i + 1));
            adjustedY = buttonY + vGap;
            buttonFrame = CGRectMake(adjustedX, adjustedY, buttonWidth, buttonHeight);
            
            UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
            [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
            NSString* title;
            switch (i) {
                case 0:
                    title = @"Bounce";
                    break;
                case 1:
                    title = @"Lazer";
                    break;
                case 2:
                    title = @"Grav";
                    break;
                default:
                    break;
            }
            [button setTitle:title forState:UIControlStateNormal];
            [button setTag:i];
            
            self.ammoButtons[i] = button;
            [self addSubview:button];
        }
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
