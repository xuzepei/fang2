//
//  ShareView.h
//  TYAlertControllerDemo


#import <UIKit/UIKit.h>


@interface OpenAppView : UIView

@property(nonatomic,strong)NSMutableArray* apps;

@property(nonatomic, weak)IBOutlet UILabel* titleLabel;
@property(nonatomic, weak)IBOutlet UIButton* button0;
@property(nonatomic, weak)IBOutlet UILabel* lable0;

- (void)updateContent:(NSArray*)apps;
- (IBAction)clickedButton:(id)sender;

@end
