//
//  CalloutView.h
//  JOINTLY
//
//  Created by Upendra Patel on 06/02/14.
//  Copyright (c) 2014 Upendra Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalloutViewDelegate <NSObject>

-(void)btnCalloutDelegateAction:(id) obj;
-(void)btnGetDestinationDelegateAction:(id) obj;
@end


@interface CalloutView : UIView
{
    IBOutlet UIButton *btnDetail;
    IBOutlet UILabel *lblProblem;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblDistance;
    IBOutlet UIImageView *imgPhoto;
    IBOutlet UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic,assign)id delegate;
@property (strong,nonatomic) NSOperationQueue *queue;
- (IBAction)btnGetDestination:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

-(void)initializeDetail:(NSMutableDictionary *)dictData;
-(IBAction)btnCalloutAction:(id)sender;

@end
