//
//  BuyTaptViewController.m
//  Tapt
//
//  Created by TriState  on 7/23/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "BuyTaptViewController.h"
#import "SharedResourceLoader.h"
#import "Constants.h"
#import "UIAlertView+utils.h"
#import "MBProgressHUD.h"

@interface BuyTaptViewController ()
{
       NSString *strRestoredIds;
}
@end

@implementation BuyTaptViewController
@synthesize strProductId;

- (void)viewDidLoad {
    [super viewDidLoad];
    [appDelegate setShouldRotate:NO];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if (result.height == 480) {
            // 3.5 inch display - iPhone 4S and below
            [self.lblNote1 setFont: [self.lblNote1.font fontWithSize:15]];
            [self.lblNote2 setFont: [self.lblNote2.font fontWithSize:15]];
            [self.lblNote3 setFont: [self.lblNote3.font fontWithSize:15]];
            [self.lblNote4 setFont: [self.lblNote4.font fontWithSize:15]];
            [self.lbltaptaviailable setFont: [self.lbltaptaviailable.font fontWithSize:14]];
           
        }
        
        else if (result.height == 568) {
            // 4 inch display - iPhone 5
            [self.lblNote1 setFont: [self.lblNote1.font fontWithSize:16]];
            [self.lblNote2 setFont: [self.lblNote2.font fontWithSize:16]];
            [self.lblNote3 setFont: [self.lblNote3.font fontWithSize:16]];
            [self.lblNote4 setFont: [self.lblNote4.font fontWithSize:15]];
            [self.lbltaptaviailable setFont: [self.lbltaptaviailable.font fontWithSize:14]];
        }
        
        else if (result.height == 667) {
            // 4.7 inch display - iPhone 6
            [self.lblNote1 setFont: [self.lblNote1.font fontWithSize:17]];
            [self.lblNote2 setFont: [self.lblNote2.font fontWithSize:17]];
            [self.lblNote3 setFont: [self.lblNote3.font fontWithSize:17]];
            [self.lblNote4 setFont: [self.lblNote4.font fontWithSize:17]];
            [self.lbltaptaviailable setFont: [self.lbltaptaviailable.font fontWithSize:18]];
        }
        
        else if (result.height == 736) {
            // 5.5 inch display - iPhone 6 Plus
            [self.lblNote1 setFont: [self.lblNote1.font fontWithSize:17]];
            [self.lblNote2 setFont: [self.lblNote2.font fontWithSize:17]];
            [self.lblNote3 setFont: [self.lblNote3.font fontWithSize:17]];
            [self.lblNote4 setFont: [self.lblNote4.font fontWithSize:17]];
            [self.lbltaptaviailable setFont: [self.lbltaptaviailable.font fontWithSize:18]];
        }
    }

    strProductId =@"";
    
    self.btnOk.layer.cornerRadius=self.btnOk.frame.size.height/2;
    self.btnOk.layer.masksToBounds=YES;
    self.btnOk.layer.borderWidth = 1;
    self.btnOk.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.btnBuy.layer.cornerRadius=5;
    
    self.lblOr.layer.masksToBounds = YES;
    self.lblOr.layer.cornerRadius = 8.0;

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productLoaded:) name:@"ProductDetailLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseDone:) name:@"PurchaseDone" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseCancel:) name:@"cancelTransaction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseRestore:) name:@"restoreComplete" object:nil];
    
    
    //keybord
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

#pragma mark - button action method
- (IBAction)btnBuyAction:(id)sender {
    
   
    self.strProductId=BUYALL_PRODUCT_ID;
    
   /* if ([self isNetworkReachable])
    {
        [[SharedResourceLoader shareObject] requestForProducts:[NSSet setWithObjects:strProductId, nil]];
        [self showHud];
        
        // Show the HUD while the provided method executes in a new thread
        [HUD showWhileExecuting:@selector(startPurchasing) onTarget:self withObject:nil animated:YES];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }  */

    
}
- (IBAction)btnOKAction:(id)sender {
    
    [self.txtPromoCode resignFirstResponder];
    if ([self.txtPromoCode  validate]) {
        
        [self callWebserviceBuytapt:[NSString stringWithFormat:@"%@",self.txtPromoCode.text]];
    }
    else
    {
        [UIAlertView infoAlertWithMessage:@"Please Enter Promo Code" andTitle:APP_NAME];

    }
    
 }

#pragma mark - calling webservice
-(void)callWebserviceBuytapt:(NSString*)Promocode{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"buyApp" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:Promocode forKey:@"purchaseCode"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"id"];
      
        NSLog(@"%@",dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            [self hidHud];
            NSLog(@"%@",dict);
            if([[dict objectForKey:@"Response"]isEqualToString:@"Ok"])
            {
               [userDefault setObject:[dict objectForKey:@"Expiry"] forKey:@"isBuy"];
                [UIAlertView infoAlertWithMessage:@"Thank you!\n"
                 "you have successfully purchased" andTitle:APP_NAME];
                self.txtPromoCode.text=@"";
            }
            else
            {
              [UIAlertView infoAlertWithMessage:[dict objectForKey:@"Response"] andTitle:APP_NAME];
              self.txtPromoCode.text=@"";
            }
  
        }
        onFailure:^(NSError *error)
        {
            NSLog(@"%@",error.localizedDescription);
            [self hidHud];
        }];
    }
    else
    {
        [UIAlertView infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APP_NAME];
        NSLog(@"%@",ALERT_NO_INTERNET);
    }
}

#pragma mark - start purchasing method

-(void)startPurchasing{
    
    [[SharedResourceLoader shareObject] requestForProducts:[NSSet setWithObjects:strProductId, nil]];
}

#pragma mark- In-App PURCHASE  METHODS

-(void)purchaseDone:(NSNotification*)notification{
    
    [self hidHud];
  
    
    NSString *productIdentifier = notification.object;
    
    if ([self isNetworkReachable]) {
        
        if ([productIdentifier isEqualToString:BUYALL_PRODUCT_ID]) {
           // [self callPuchaseAllService];
        }
        else{
           // [self callPuchaseCategoryService];
        }
    }
    else{
//        OopsViewController *objOopsViewController = [[OopsViewController alloc] initWithNibName:@"OopsViewController" bundle:nil];
//        [self.navigationController pushViewController:objOopsViewController animated:YES];
//        [objOopsViewController release];
    }
   
}

-(void)purchaseCancel:(NSNotification*)notification{
    [self hidHud];
    
}
-(void)productLoaded:(NSNotification*)notification{
    NSMutableArray *array = notification.object;
    if([array count]){
        [self showHud];
 
        
        SharedResourceLoader *resourceLoader = [SharedResourceLoader shareObject];
        [resourceLoader purchaseProduct:[array objectAtIndex:0]];
    }
    else
    {
        [self hidHud];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Product id is not matched." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

-(void)purchaseRestore:(NSNotification*)notification{
    [self hidHud];
    SKPaymentQueue *queue = notification.object;
    NSMutableArray *arrayProductIds = [NSMutableArray array];
    
    if ([queue isKindOfClass:[SKPaymentQueue class]]) {
        for (SKPaymentTransaction *transaction in queue.transactions) {
            NSString *strIds = transaction.payment.productIdentifier;
            [arrayProductIds addObject:strIds];
        }
        
        strRestoredIds  = [arrayProductIds componentsJoinedByString:@","];
        
        if ([self isNetworkReachable]) {
            [self showHud];
          //  [self callRestoreAllService:strRestoredIds];
           // // [self setRestoredProduct:strRestoredIds];
            
            
        }
        else{
            
        }
    }
    
    
}

-(void)updateForPurchase:(NSString *)productIdentifier
{
    [self hidHud];
    [self.view setUserInteractionEnabled:YES];
}

- (IBAction)btnBackAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextField Delegate Method

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //        [scrlView setViewframe:textField forSuperView:self.view];
    self.txtFieldCheck=textField;
}


-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    //[userDefault setObject:textField.text forKey:@"event"];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Autolayout keyboard Method

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrlView.contentInset = contentInsets;
    self.scrlView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.txtFieldCheck.frame.origin) ) {
        [self.scrlView scrollRectToVisible:self.txtFieldCheck.frame animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrlView.contentInset = contentInsets;
    self.scrlView.scrollIndicatorInsets = contentInsets;
}

#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
