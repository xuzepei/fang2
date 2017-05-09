//
//  ShareView.m
//  TYAlertControllerDemo


#import "OpenAppView.h"
#import "UIView+TYAlertView.h"
#import "RCWebViewController.h"

@implementation OpenAppView

- (void)dealloc
{
    self.apps = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
        
        if(nil == _apps)
            self.apps = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if(nil == _apps)
        self.apps = [[NSMutableArray alloc] init];
}

- (IBAction)cancelAction:(id)sender {
    // hide view,or dismiss controller
    [self hideView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateContent:(NSArray*)apps
{
    [self.apps addObjectsFromArray:apps];
    
    if([apps count])
    {
        NSDictionary* appInfo = [apps objectAtIndex:0];
        NSString* imageName = [appInfo objectForKey:@"image"];
        NSString* appName = [appInfo objectForKey:@"name"];
        
        [self.button0 setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        self.lable0.text = appName;
    }
}

- (IBAction)clickedButton:(id)sender
{
    UIButton* button = (UIButton*)sender;
    
    switch (button.tag) {
        case 0:
        {
            [self hideView];
            
            NSDictionary* item = [self.apps objectAtIndex:button.tag];
            NSLog(@"item:%@",item);
            
            NSString* urlString = [item objectForKey:@"url"];
            if([urlString length])
            {
                RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
                temp.hidesBottomBarWhenPushed = YES;
                [temp updateContent:urlString title:self.titleLabel.text];
                
                UINavigationController* naviController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                [naviController pushViewController:temp animated:YES];
                return;
            }
            else
            {
                NSString* urlScheme = [item objectForKey:@"urlscheme"];
                if([urlScheme length])
                {
                    NSString* url = [NSString stringWithFormat:@"%@://",urlScheme];
                    NSLog(@"---Open url:%@", url);
                    if([[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]])
                    {
                        return;
                    }
                }
                
                NSString* appleId = [item objectForKey:@"apple_id"];
                if([appleId length])
                {
                    [self openAppStore:appleId];
                }
            }
            
            
            break;
        }
        default:
            break;
    }
}

- (void)openAppStore:(NSString*)appleId
{
    SKStoreProductViewController *storeController = [[SKStoreProductViewController alloc] init];
    storeController.delegate = [UIApplication sharedApplication].delegate;
    NSDictionary *productParameters = @{ SKStoreProductParameterITunesItemIdentifier : appleId };
    [storeController loadProductWithParameters:productParameters completionBlock:^(BOOL result, NSError *error) {
        //Handle response
    }];

    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:storeController animated:YES completion:nil];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideView];
}

@end
