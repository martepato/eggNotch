
static UIView* blackView(void) {

    // I stole this idea from @LaughingQuoll
    // Thanks tho

    CGRect screenBounds = [UIScreen mainScreen].bounds;

    CGRect frame = CGRectMake(-40.5, -10, screenBounds.size.width + 81, screenBounds.size.height+200); //this is the border which will cover the notch

    UIView *blackView = [[UIView alloc] initWithFrame:frame];
    blackView.layer.borderColor = [UIColor blackColor].CGColor;
    blackView.layer.borderWidth = 40.0f;

    [blackView setClipsToBounds:YES];
    [blackView.layer setMasksToBounds:YES];
    blackView.layer.cornerRadius = 75;

    return blackView;
}

@interface _UIStatusBar : UIView
@property (nonatomic, retain) UIColor *foregroundColor;
@end

@interface SBControlCenterController
+ (id)sharedInstance;
- (UIWindow*)_controlCenterWindow;
@property(readonly, nonatomic, getter=isVisible) _Bool visible;
@end


// To Do : Add blackView to the control center

%hook _UIStatusBar

-(void)layoutSubviews {

    SBControlCenterController* ccController = (SBControlCenterController*)[%c(SBControlCenterController) sharedInstance];

    // Avoid adding the notch removing view to the control center
    if (!ccController.visible) {
        [self removeNotch];
    }

    %orig;
}

%new
-(void)removeNotch {
    self.foregroundColor = [UIColor whiteColor];
    [self setBackgroundColor:[UIColor blackColor]];

    UIView* notchHidingView = blackView();

    [self addSubview: notchHidingView];
    [self sendSubviewToBack: notchHidingView];
}

//Make the Statusbar slightly smaller

- (void)setFrame:(CGRect)frame {
    frame.size.height = 32;
    %orig(frame);
}
- (CGRect)bounds {
    CGRect frame = %orig;
    frame.size.height = 32;
    return frame;
}
%end