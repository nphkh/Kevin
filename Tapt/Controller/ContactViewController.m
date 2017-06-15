//
//  ContactViewController.m
//  Tapt
//
//  Created by Parth on 08/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactCVCell.h"
#import "Webservice.h"
#import "Constants.h"
#import "Database.h"
#import "ContactDetailViewController.h"
#import "DetailViewController.h"
#import "ContactTVCell.h"
#import "UserDetail.h"
#import "SendContactViewController.h"
#import "ProfileTabbarViewController.h"
#import "ReceiveContactFirstViewController.h"
#import "CardView.h"
#import "DestinationViewController.h"
#import "SourceViewController.h"

@interface ContactViewController ()<UIGestureRecognizerDelegate,SourceViewDelegate>
{
    NSUserDefaults *userDefault;

    NSInteger totalContact;
    NSInteger startIndex;
    NSInteger count;
    NSInteger page;
    
    
    SourceViewController *_sourceViewController;
    DestinationViewController *_destinationViewController;
    CardView *_draggedCard;
    MyModel *_model;
//    NSInteger flagForDisplay;

}

@property (weak, nonatomic) IBOutlet UICollectionView *destinationCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *sourceCollectionView;

@end


@implementation ContactViewController



@synthesize arrImages;
@synthesize arrContacts,arrCategory;
@synthesize dictContactResponse;
@synthesize moreOptionView;
@synthesize cvContact;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    categoryindex=-1;
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"Pull to Refresh..."];
    [self.refreshControl addTarget:self action:@selector(startRefreshing) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor grayColor]];
    [self.cvContact addSubview:self.refreshControl];
    self.cvContact.alwaysBounceVertical = YES;

     //[self callWebserviceForCategory];
     [appDelegate setShouldRotate:NO];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [appDelegate setShouldRotate:NO];

//    flagForDisplay=1;
    self.categoryCollectionView.hidden=YES;
    self.btnCategory.hidden=NO;
    arrSearchContact=[[NSMutableArray alloc]init];
    arrSearchTag=[[NSMutableArray alloc]init];
    flagCateGorydata=0;
   
    //search
    self.btnTopLogo.hidden=NO;
    [self.btnTopLogo setUserInteractionEnabled:YES];

    self.ScrlViewSearch.hidden=YES;
    self.ContentViewSearch.hidden=YES;
    self.viewSearchTag.hidden=YES;
    self.txtSearch.hidden=YES;
    self.btnTag.hidden=YES;
    isTagButtonSearch=0;
    self.isfromSearch=NO;
    
    userDefault =[NSUserDefaults standardUserDefaults];
    
    
    //condition for not purchase then display 25 records
    NSLog(@"%@",[userDefault objectForKey:@"isBuy"]);
    //if([[[userDefault objectForKey:@"isBuy"]stringValue]isEqualToString:@"0"])
    if([[userDefault objectForKey:@"isBuy"]isEqualToString:@"0"])
    {
        NSString *query = @"select * from Contact_Detail LIMIT 25";
        arrContacts=[Database executeQuery:query];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"first_name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        arrContacts=[[arrContacts sortedArrayUsingDescriptors:@[sort]]mutableCopy];
    }
    else
    {
        NSString *query = @"select * from Contact_Detail";
        arrContacts=[Database executeQuery:query];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"first_name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        arrContacts=[[arrContacts sortedArrayUsingDescriptors:@[sort]]mutableCopy];
    }
   
    
    moreOptionView.hidden=YES;
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _sourceViewController = [[SourceViewController alloc] initWithCollectionView:self.sourceCollectionView
                                                         andParentViewController:self];
    _sourceViewController.mydelegate=self;
    _destinationViewController = [[DestinationViewController alloc] initWithCollectionView:self.destinationCollectionView ];
    _destinationViewController.delegate =self;
    [self initDraggedCardView];
    
    //gesture
    UIPanGestureRecognizer *panGesture =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    
    
    NSString *QueryTag = @"select * from Tag";
    arrTag=[Database executeQuery:QueryTag];
   
}
/*
#pragma mark - UICollectionViewDelegate Method

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrContacts count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCVCell *cvCell;//=[collectionView dequeueReusableCellWithReuseIdentifier:@"ContactCVCell" forIndexPath:indexPath];

    NSDictionary *dictContact=[NSDictionary dictionaryWithDictionary:[arrContacts objectAtIndex:indexPath.row]];

    if ([[userDefault objectForKey:@"displayList"] isEqualToString:@"2"]) {
        cvCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ContactListCell" forIndexPath:indexPath];
        cvCell.lblName.text=[dictContact objectForKey:@"first_name"];
        cvCell.lblSurname.text=[dictContact objectForKey:@"last_name"];
    }
    else
    {
        cvCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ContactCVCell" forIndexPath:indexPath];
        cvCell.lblName.text=[NSString stringWithFormat:@"%@ %@",[dictContact objectForKey:@"first_name"], [dictContact objectForKey:@"last_name"]];
    }
    
//    cvCell.imgContact.image=[UIImage imageNamed:@"profile-circle-contact.png"];
    //Lazy Loading--------BEGIN
    NSString *strPhotoURL=nil;
    NSString *urlFromDict=[dictContact objectForKey:@"image_url"];
    if(urlFromDict!=nil && ![[urlFromDict trimSpaces] isEqualToString:@""])
    {
        strPhotoURL=[WEBSERVICE_IMG_BASE_URL stringByAppendingPathComponent:urlFromDict];
        
    }
    cvCell.imgContact.image = nil;
    if(strPhotoURL != nil){
        UIImage *image = [self imageIfExist:strPhotoURL];
        [self setImageURL:strPhotoURL forIndexPath:indexPath];
        
        if(image){
            cvCell.imgContact.image = image;
            [cvCell.indicator stopAnimating];
        }
        else{
            [self startDownloadingImage:strPhotoURL withIndexPath:indexPath];
            [cvCell.indicator startAnimating];
        }
    }
    else{
        [cvCell.indicator stopAnimating];
        cvCell.imgContact.image = [UIImage imageNamed:IMAGE_PLACEHOLDER];
    }
    //Lazy Loading-------- END
    
    cvCell.imgContact.layer.cornerRadius=cvCell.imgContact.frame.size.height/2;
    cvCell.imgContact.layer.masksToBounds=YES;
    cvCell.imgContact.layer.borderWidth=0;
    
    return cvCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *vcContactDetail=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    vcContactDetail.dictContact=[arrContacts objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vcContactDetail animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    if([[userDefault objectForKey:@"displayList"] isEqualToString:@"2"])
        return CGSizeMake(300, 115);
    else
        return CGSizeMake(95, 115);
}

 */

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    flagMenuopen=1;
    [self btnSettingAction:nil];
    
}

#pragma mark - UIREFERESH VIEW DELEGATE

-(void)startRefreshing
{
    self.refreshControl.attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"Pull to Refresh..."];
    NSMutableAttributedString *str = [self.refreshControl.attributedTitle mutableCopy];
    
    NSInteger length = str.length;
    
    [str addAttribute: NSForegroundColorAttributeName
                value: [UIColor blackColor]
                range: NSMakeRange(0, length)];
    
    [str addAttribute: NSFontAttributeName
                value:  [UIFont fontWithName:@"Helvetica Neue" size:15]
                range: NSMakeRange(0,length)];
    
    self.refreshControl.attributedTitle = str;
    
    [self performSelector:@selector(refreshingView) withObject:nil afterDelay:0.3];
}

-(void)refreshingView
{
    self.refreshControl.attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"Refreshing..."] ;
    
    NSMutableAttributedString *str = [self.refreshControl.attributedTitle mutableCopy];
    NSInteger length = str.length;
    [str addAttribute: NSForegroundColorAttributeName
                value: [UIColor blackColor]
                range: NSMakeRange(0, length)];
    [str addAttribute: NSFontAttributeName
                value:  [UIFont fontWithName:@"Helvetica Neue" size:15]
                range: NSMakeRange(0,length)];
    self.refreshControl.attributedTitle = str;
    [self performSelector:@selector(refreshingDone) withObject:nil afterDelay:0.3];
    //    [self refreshView];
}

-(void)refreshingDone
{
    self.refreshControl.attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"Refreshing Done..."] ;
    NSMutableAttributedString *str = [self.refreshControl.attributedTitle mutableCopy];
    
    NSInteger length = str.length;
    
    [str addAttribute: NSForegroundColorAttributeName
                value: [UIColor colorWithRed:150.0/255.0 green:144.0/255.0 blue:243.0/255.0 alpha:1.0]
                range: NSMakeRange(0, length)];
    
    [str addAttribute: NSFontAttributeName
                value:  [UIFont fontWithName:@"Helvetica Neue" size:15]
                range: NSMakeRange(0,length)];
    self.refreshControl.attributedTitle = str;
    [self.refreshControl endRefreshing];
    [self refreshFromServer];
}

-(void)refreshFromServer
{
    //NSString *query= [NSString stringWithFormat:@"delete from Contact_Detail"];
   // NSMutableArray *arrResponse=[NSMutableArray arrayWithArray:[Database executeQuery:query]];
    if(flagCateGorydata)
    {
        
    }
    else
    {
       [self callWebserviceForGetMyContactList:[userDefault objectForKey:@"ID"]];
    }
   
}


#pragma mark - callWebservice
-(void)callWebserviceForGetMyContactList:(NSString *)contact_Id
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"getMyContacts" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:contact_Id forKey:@"id"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
            {
                if (![[[dict objectForKey:@"rowCount"] stringValue] isEqualToString:@"0"]) {
                    totalContact=[[dict objectForKey:@"rowCount"] integerValue];
                    dictContactResponse=dict;
                    [self callPaging];
                }
               
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

//getContact

-(void)callPaging{
    
    startIndex=1;
    count=50;
    page=totalContact/50;
    
    for (int i=0; i<=page; i++) {
        NSString *strKey=[NSString stringWithFormat:@"Contact%ld",(long)startIndex];
        
        if ([dictContactResponse objectForKey:strKey]) {
            
            NSString *strKey1=[NSString stringWithFormat:@"Contact%ld",(long)count];
            if ([dictContactResponse objectForKey:strKey1]) {
                
                NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                [dict setObject:@"getSharedFieldsBatch" forKey:@"action"];
                [dict setObject:@"1.14" forKey:@"version"];
                [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
                
                NSString *strId=@"";
                
                for (startIndex; startIndex<=count; startIndex++) {
                    if ([strId isEqualToString:@""]) {
                        strId=[NSString stringWithFormat:@"%@",[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%ld",(long)startIndex]]];
                    }
                    else
                    {
                        strId=[strId stringByAppendingFormat:@",%@",[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%ld",(long)startIndex]]];
                    }
                }
                startIndex=count+1;
                count=count+50;
                
                [dict setObject:strId forKey:@"senders"];
                
                strId=@"";
                
                [self callWebserviceForGetMyContact:dict];
                
            }
            else
            {
                NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                [dict setObject:@"getSharedFieldsBatch" forKey:@"action"];
                [dict setObject:@"1.14" forKey:@"version"];
                [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
                
                NSString *strId=@"";
                
                for (startIndex; startIndex<=totalContact; startIndex++) {
                    
                    if ([strId isEqualToString:@""]) {
                        strId=[NSString stringWithFormat:@"%@",[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%ld",(long)startIndex]]];
                    }
                    else
                    {
                        strId=[strId stringByAppendingFormat:@",%@",[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%ld",(long)startIndex]]];
                    }
                }
                startIndex=count+1;
                
                [dict setObject:strId forKey:@"senders"];
                
                strId=@"";
                
                [self callWebserviceForGetMyContact:dict];
            }
        }
    }
}

-(void)callWebserviceForGetMyContact:(NSMutableDictionary *)dict
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSLog(@"dict := %@", dict);
        
        Webservice *service1=[[Webservice alloc]init];
        
        [service1 callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
            {
                int i=[[dict objectForKey:@"Count"] intValue];
                
                NSMutableArray *arrKeys=[NSMutableArray arrayWithArray:[dict allKeys]];
                [arrKeys removeObject:@"Count"];
                [arrKeys removeObject:@"Response"];
                
                for (int j=1; j<=i; j++) {
                    
                    NSString *strKey=[NSString stringWithFormat:@"Contact%d",j];
                    strKey=[dictContactResponse objectForKey:strKey];
                    
                    NSString *strKey1=[arrKeys objectAtIndex:j-1];
                    NSMutableDictionary *dictInsert = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:strKey1]];
                    NSArray *arrId=[NSArray arrayWithArray:[strKey1 componentsSeparatedByString:@" "]];
                    
                    NSMutableDictionary *tmpDict=[[NSMutableDictionary alloc]init];
                    
                    /*[tmpDict setObject:[arrId objectAtIndex:1] forKey:@"cid"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"given_name"]) forKey:@"first_name"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"family_name"]) forKey:@"last_name"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"mobile_phone"]) forKey:@"mobile_phone"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"desk_phone"]) forKey:@"desk_phone"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"home_phone"]) forKey:@"home_phone"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"email"]) forKey:@"email"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"company"]) forKey:@"company"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"title"]) forKey:@"title"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"address1"]) forKey:@"address1"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"address2"]) forKey:@"address2"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"address3"]) forKey:@"address3"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"suburb"]) forKey:@"suburb"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"post_code"]) forKey:@"post_code"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"city"]) forKey:@"city"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"state"]) forKey:@"state"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"country"]) forKey:@"country"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"image"]) forKey:@"image_url"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"logo"]) forKey:@"logo_url"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"social_facebook"]) forKey:@"facebook"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"social_twitter"]) forKey:@"twitter"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"social_linkedin"]) forKey:@"linkedIn"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"social_Skype"]) forKey:@"skype"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"www"]) forKey:@"website"];
                    [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"bizcard"]) forKey:@"layout"];
                     [Database insert:@"tbl_profile" data:tmpDict];*/
                    
                    NSString *strget=[NSString stringWithFormat:@"select * from Contact_Detail where contact_id='%@'",[arrId objectAtIndex:1]];
                    NSMutableArray *arr=[Database executeQuery:strget];
                    
                    if([Database executeScalerQuery:strget])
                    {
                        
                        NSLog(@"%@",dictInsert);
                        NSString *insertQuery=[NSString stringWithFormat:@"insert into Contact_Detail (first_name,last_name,home_mobile_phone,home_phone,home_email,home_address1,home_suburb,home_city,home_state,home_country,home_post_code,company,title,work_phone,work_mobile_phone,work_email,website,work_address1,work_suburb,work_city,work_state,work_country,work_post_code,layout,image_url,logo_url,facebook,twitter,linkedIn,skype,ContactSince,Event,contact_id)values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[dictInsert objectForKey:@"given_name"],[dictInsert objectForKey:@"family_name"],[dictInsert objectForKey:@"home_mobile_phone"],[dictInsert objectForKey:@"home_phone"],[dictInsert objectForKey:@"home_email"],[dictInsert objectForKey:@"home_address1"],[dictInsert objectForKey:@"home_suburb"],[dictInsert objectForKey:@"home_city"],[dictInsert objectForKey:@"home_state"],[dictInsert objectForKey:@"home_country"],[dictInsert objectForKey:@"home_post_code"],[dictInsert objectForKey:@"company"],[dictInsert objectForKey:@"title"],[dictInsert objectForKey:@"work_phone"],[dictInsert objectForKey:@"work_mobile_phone"],[dictInsert objectForKey:@"work_email"],[dictInsert objectForKey:@"work_www"],[dictInsert objectForKey:@"work_address1"],[dictInsert objectForKey:@"work_suburb"],[dictInsert objectForKey:@"work_city"],[dictInsert objectForKey:@"work_state"],[dictInsert objectForKey:@"work_country"],[dictInsert objectForKey:@"work_post_code"],[dictInsert objectForKey:@"bizcard"],[dictInsert objectForKey:@"image"],[dictInsert objectForKey:@"logo"],@"",@"",@"",@"",[dictInsert objectForKey:@"created"],[dictInsert objectForKey:@"Event"],[arrId objectAtIndex:1]];
                        
                        
                        if([Database executeScalerQuery:insertQuery])
                        {
                            NSLog(@"Data Inserted!");
                        }
                        else
                        {
                            
                        }

                        
                    }
                    else
                    {
                        NSString *updateQuery=[NSString stringWithFormat:@"update Contact_Detail set first_name='%@',last_name='%@',home_mobile_phone='%@',home_phone='%@',home_email='%@',home_address1='%@',home_suburb='%@',home_city='%@',home_state='%@',home_country='%@',home_post_code='%@',company='%@',title='%@',work_phone='%@',work_mobile_phone='%@',work_email='%@',website='%@',work_address1='%@',work_suburb='%@',work_city='%@',work_state='%@',work_country='%@',work_post_code='%@',layout='%@',image_url='%@',logo_url='%@',facebook='%@',twitter='%@',linkedIn='%@',skype='%@',ContactSince='%@',Event='%@' where contact_id='%@'",[dictInsert objectForKey:@"given_name"],[dictInsert objectForKey:@"family_name"],[dictInsert objectForKey:@"home_mobile_phone"],[dictInsert objectForKey:@"home_phone"],[dictInsert objectForKey:@"home_email"],[dictInsert objectForKey:@"home_address1"],[dictInsert objectForKey:@"home_suburb"],[dictInsert objectForKey:@"home_city"],[dictInsert objectForKey:@"home_state"],[dictInsert objectForKey:@"home_country"],[dictInsert objectForKey:@"home_post_code"],[dictInsert objectForKey:@"company"],[dictInsert objectForKey:@"title"],[dictInsert objectForKey:@"work_phone"],[dictInsert objectForKey:@"work_mobile_phone"],[dictInsert objectForKey:@"work_email"],[dictInsert objectForKey:@"work_www"],[dictInsert objectForKey:@"work_address1"],[dictInsert objectForKey:@"work_suburb"],[dictInsert objectForKey:@"work_city"],[dictInsert objectForKey:@"work_state"],[dictInsert objectForKey:@"work_country"],[dictInsert objectForKey:@"work_post_code"],[dictInsert objectForKey:@"bizcard"],[dictInsert objectForKey:@"image"],[dictInsert objectForKey:@"logo"],@"",@"",@"",@"",[dictInsert objectForKey:@"created"],[dictInsert objectForKey:@"Event"],[arrId objectAtIndex:1]];
                        
                        
                        if([Database executeScalerQuery:updateQuery])
                        {
                            NSLog(@"Data updated!");
                        }
                        else
                        {
                            
                        }

                    }
                    
                    
                    
                }
                
                [self reloadContacts];

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

-(void)reloadContacts{
   
    //condition for not purchase then display 25 records
    if([[userDefault objectForKey:@"isBuy"]isEqualToString:@"0"])
    {
        NSString *query = @"select * from Contact_Detail LIMIT 25";
        arrContacts=[Database executeQuery:query];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"first_name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        arrContacts=[[arrContacts sortedArrayUsingDescriptors:@[sort]]mutableCopy];
        
    }
    else
    {
        NSString *query = @"select * from Contact_Detail";
        arrContacts=[Database executeQuery:query];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"first_name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        arrContacts=[[arrContacts sortedArrayUsingDescriptors:@[sort]]mutableCopy];
    }
    
    [self.cvContact reloadData];
    _sourceViewController = [[SourceViewController alloc] initWithCollectionView:self.sourceCollectionView
                                                         andParentViewController:self];
    [_sourceCollectionView reloadData];
}

//30-Jun-15
#pragma mark -Calling Web Service
-(void)callWebserviceForPutCategory
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateCategories" forKey:@"action"];
        
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"put" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        
        
        NSString *strSenderId;
        if(flagCateGorydata==1)
        {
            strSenderId=[[arrCategoryContacts valueForKey:@"contact_id"] objectAtIndex:appDelegate.contactindex];
           // [dict setObject:[[arrCategoryContacts valueForKey:@"contact_id"] objectAtIndex:appDelegate.contactindex] forKey:@"senderId"];
        }
        else
        {
            strSenderId=[[arrContacts valueForKey:@"contact_id"] objectAtIndex:appDelegate.contactindex];
            // [dict setObject:[[arrContacts valueForKey:@"contact_id"] objectAtIndex:appDelegate.contactindex] forKey:@"senderId"];
        }
        [dict setObject:strSenderId forKey:@"senderId"];
       
        
      
        NSString *strcatID;
        if(categoryindex!=0)
        {
           strcatID =[[[userDefault objectForKey:@"category_contact"]valueForKey:@"cate_id"]objectAtIndex:categoryindex-1];
            [dict setObject:strcatID forKey:@"categoryId"];
            
        }
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
            {
                
                NSString *strget=[NSString stringWithFormat:@"select * from Categorie_contact_relation where cate_id='%@' AND contact_id='%@'",strcatID,strSenderId];
                NSMutableArray *arr=[Database executeQuery:strget];
               
                
                //condition for the duplicate sender not put in category
                if([Database executeScalerQuery:strget])
                {
                   
                    NSString *strquery=[NSString stringWithFormat:@"select * from Categorie_contact_relation where contact_id='%@'",strSenderId];
                    NSMutableArray *arrf=[Database executeQuery:strquery];
                   
                    //condition for the uniqe sender for uniq category
                    if([Database executeScalerQuery:strquery])
                    {
                        NSString *insertQuery=[NSString stringWithFormat:@"insert into Categorie_contact_relation (cate_id,contact_id)values (%@,'%@')",strcatID,strSenderId];
                        [Database executeScalerQuery:insertQuery];

                    }
                    else
                    {
                        [userDefault setObject:[[arrf valueForKey:@"cate_id"]objectAtIndex:0] forKey:@"selectedCategoryID"];
                        [self callWebserviceForremovefromcategory:[strSenderId intValue]];
                    }
                    
                }
                else{
                   
                    NSString *updateQuery=[NSString stringWithFormat:@"update  Categorie_contact_relation set cate_id='%@',contact_id='%@',",strcatID,strSenderId];
                    
                    [Database executeScalerQuery:updateQuery];
                    
                }
                
                
                
            }
            else
            {
                
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
-(void)callWebserviceForremovefromcategory:(int)catIndex
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateCategories" forKey:@"action"];
        
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"remove" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        
        NSString *senderID;
        if(flagCateGorydata==1)
        {
            senderID=[[arrCategoryContacts valueForKey:@"contact_id"] objectAtIndex:appDelegate.contactindex];
            
           // [dict setObject:[[arrCategoryContacts valueForKey:@"contact_id"] objectAtIndex:appDelegate.contactindex]  forKey:@"senderId"];
            
        }
        else
        {
            senderID=[[arrContacts valueForKey:@"contact_id"] objectAtIndex:appDelegate.contactindex];
            //[dict setObject:[[arrContacts valueForKey:@"contact_id"] objectAtIndex:appDelegate.contactindex]  forKey:@"senderId"];
        }
        [dict setObject:senderID forKey:@"senderId"];

//        NSLog(@"%@",[userDefault objectForKey:@"category_contact"]);
//       NSString *strcatID =[[[userDefault objectForKey:@"category_contact"]valueForKey:@"cate_id"]objectAtIndex:categoryindex-1];
        //[dict setObject:strcatID forKey:@"categoryId"];
        [dict setObject:[userDefault objectForKey:@"selectedCategoryID"] forKey:@"categoryId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
            {
               
                NSString *query= [NSString stringWithFormat:@"delete from Categorie_contact_relation where cate_id='%@' AND contact_id='%@'",[userDefault objectForKey:@"selectedCategoryID"],senderID];
                
                
                if([Database executeScalerQuery:query])
                {
                    NSLog(@"Data deleted!");
                }
                else
                {
                    
                }
                
                [self callWebserviceForPutCategory];
                
                
            }
            else
            {
                
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

-(void)callWebserviceForDeleteCategory
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateCategories" forKey:@"action"];
        
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"remove" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:@"" forKey:@"categoryId"];
        [dict setObject:[[arrContacts valueForKey:@"id"] objectAtIndex:appDelegate.contactindex]  forKey:@"senderId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
            {
                
            }
            else
            {
                
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
-(void)categoryAction:(NSIndexPath *)indexPath
{
    
    flagCateGorydata=1;
    
    NSString *str=[[[userDefault objectForKey:@"category_contact"] valueForKey:@"cate_id"]objectAtIndex:indexPath.row-1];
    [userDefault setObject:str forKey:@"selectedCategoryID"];
    
    arrCategoryContacts=[[NSMutableArray alloc]init];
    
    NSString *SelectQuery=[NSString stringWithFormat:@"select cat.*,cnt.* from Categorie_contact_relation cat left join Contact_Detail cnt on cnt.contact_id=cat.contact_id where cat.cate_id ='%@'",str];
  
    NSMutableArray *temparray=[Database executeQuery:SelectQuery];
   
    for(int i=0;i<[temparray count];i++)
    {
        if(temparray.count>0 && ![temparray isKindOfClass:[NSNull class]])
        {
            
            [arrCategoryContacts addObject:[temparray objectAtIndex:i]];
            
        }
    }

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"first_name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    arrCategoryContacts=[[arrCategoryContacts sortedArrayUsingDescriptors:@[sort]]mutableCopy];
    

    
    appDelegate.isfromSearch=YES;
    [_sourceViewController setUpModels:arrCategoryContacts];
    [_sourceCollectionView reloadData];
    
     //[self callWebserviceForGetCategoryMembers:(int)indexPath.row];
}

#pragma mark - tabbutton action
- (IBAction)btnPersonTabAction:(id)sender {
    
     [TagSelect removeFromSuperview];
    
    [userDefault setObject:@"1" forKey:@"isFromContact"];
    
   NSString *query =[NSString stringWithFormat:@"select * from tbl_profile where cid='%@'",[userDefault objectForKey:@"ID"]];
    arrUserDetail=[[NSMutableArray alloc]init];
    arrUserDetail=[Database executeQuery:query];
    NSLog(@"%@",arrUserDetail);
    
    UserDetail *userDtl=[UserDetail sharedInstance];
    if(arrUserDetail.count>0)
    {
        userDtl.firstName=[[arrUserDetail valueForKey:@"given_name"]objectAtIndex:0];
        userDtl.lastName=[[arrUserDetail valueForKey:@"family_name"]objectAtIndex:0];
        userDtl.MobileNumber=[[arrUserDetail valueForKey:@"home_mobile_phone"]objectAtIndex:0];
        userDtl.ProfilePhoto=[[arrUserDetail valueForKey:@"image"]objectAtIndex:0];
        userDtl.homePhone=[[arrUserDetail valueForKey:@"home_phone"]objectAtIndex:0];
        userDtl.homeEmail=[[arrUserDetail valueForKey:@"home_email"]objectAtIndex:0];
        userDtl.homeAddress=[[arrUserDetail valueForKey:@"home_address1"]objectAtIndex:0];
        userDtl.homeStreet=[[arrUserDetail valueForKey:@"home_suburb"]objectAtIndex:0];
        userDtl.homeCity=[[arrUserDetail valueForKey:@"home_city"]objectAtIndex:0];
        userDtl.homeState=[[arrUserDetail valueForKey:@"home_state"]objectAtIndex:0];
        userDtl.homeCountry=[[arrUserDetail valueForKey:@"home_country"]objectAtIndex:0];
        userDtl.homePostCode=[[arrUserDetail valueForKey:@"home_post_code"]objectAtIndex:0];
        userDtl.companyName=[[arrUserDetail valueForKey:@"company"]objectAtIndex:0];
        userDtl.title=[[arrUserDetail valueForKey:@"title"]objectAtIndex:0];
        userDtl.officePhonenumber=[[arrUserDetail valueForKey:@"work_phone"]objectAtIndex:0];
        userDtl.officeMobilenumber=[[arrUserDetail valueForKey:@"work_mobile_phone"]objectAtIndex:0];
        userDtl.officeEmail=[[arrUserDetail valueForKey:@"work_email"]objectAtIndex:0];
        userDtl.Website=[[arrUserDetail valueForKey:@"work_www"]objectAtIndex:0];
        userDtl.Logoimg=[[arrUserDetail valueForKey:@"logo"]objectAtIndex:0];
        userDtl.officeAddress=[[arrUserDetail valueForKey:@"work_address1"]objectAtIndex:0];
        userDtl.officeStreet=[[arrUserDetail valueForKey:@"work_suburb"]objectAtIndex:0];
        userDtl.officeCity=[[arrUserDetail valueForKey:@"work_city"]objectAtIndex:0];
        userDtl.officeState=[[arrUserDetail valueForKey:@"work_state"]objectAtIndex:0];
        userDtl.officeCountry=[[arrUserDetail valueForKey:@"work_country"]objectAtIndex:0];
        userDtl.officePostCode=[[arrUserDetail valueForKey:@"work_post_code"]objectAtIndex:0];
        userDtl.cardlayout=[[arrUserDetail valueForKey:@"layout"]objectAtIndex:0];
        userDtl.facebook=[[arrUserDetail valueForKey:@"social_facebook"]objectAtIndex:0];
        userDtl.twitter=[[arrUserDetail valueForKey:@"social_twitter"]objectAtIndex:0];
        userDtl.linkedin=[[arrUserDetail valueForKey:@"social_linkedin"]objectAtIndex:0];
        userDtl.skype=[[arrUserDetail valueForKey:@"social_Skype"]objectAtIndex:0];
    }
    else
    {
        userDtl.firstName=@"";
        userDtl.lastName=@"";
        userDtl.MobileNumber=@"";
        userDtl.ProfilePhoto=@"";
        userDtl.homePhone=@"";
        userDtl.homeEmail=@"";
        userDtl.homeAddress=@"";
        userDtl.homeStreet=@"";
        userDtl.homeCity=@"";
        userDtl.homeState=@"";
        userDtl.homeCountry=@"";
        userDtl.homePostCode=@"";
        userDtl.companyName=@"";
        userDtl.title=@"";
        userDtl.officePhonenumber=@"";
        userDtl.officeMobilenumber=@"";
        userDtl.officeEmail=@"";
        userDtl.Website=@"";
        userDtl.Logoimg=@"";
        userDtl.officeAddress=@"";
        userDtl.officeStreet=@"";
        userDtl.officeCity=@"";
        userDtl.officeState=@"";
        userDtl.officeCountry=@"";
        userDtl.officePostCode=@"";
        userDtl.cardlayout=@"";
        userDtl.facebook=@"";
        userDtl.twitter=@"";
        userDtl.linkedin=@"";
        userDtl.skype=@"";
       
    }
    
    ProfileTabbarViewController *vcProfiletab=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileTabbarViewController"];
    [self.navigationController pushViewController:vcProfiletab animated:YES];
    
}

- (IBAction)btnSendTabAction:(id)sender {
    
    [TagSelect removeFromSuperview];
    
    [userDefault setObject:@"1" forKey:@"isFromContact"];
    SendContactViewController *vcsend=[self.storyboard instantiateViewControllerWithIdentifier:@"SendContactViewController"];
    [self.navigationController pushViewController:vcsend animated:YES];
    
    
}

- (IBAction)btnReceiveTabAction:(id)sender {
   
    [TagSelect removeFromSuperview];
    [userDefault setObject:@"1" forKey:@"isFromContact"];
    
    ReceiveContactFirstViewController *vcReceive=[self.storyboard instantiateViewControllerWithIdentifier:@"ReceiveContactFirstViewController"];
    [self.navigationController pushViewController:vcReceive animated:YES];
    
}

- (IBAction)btnSettingAction:(id)sender {
    
     [TagSelect removeFromSuperview];
    if (flagMenuopen==1) {
        flagMenuopen=0;
        [UIView animateWithDuration:1.0 animations:^{
            settingView.frame = CGRectMake(self.view.frame.size.width-(settingView.frame.size.width), self.view.frame.size.height, settingView.frame.size.width, settingView.frame.size.height);
        }];
        
    }
    else{
        if (settingView==nil) {
            settingView = [UIView loadView:@"SettingMenu"]; //SettingMenuView
            settingView.frame = CGRectMake(self.view.frame.size.width-(settingView.frame.size.width), self.view.frame.size.height, settingView.frame.size.width, settingView.frame.size.height);
            settingView.layer.cornerRadius=5;
            //settingView.layer.borderWidth=1.0;
           // settingView.layer.borderColor = [UIColor whiteColor].CGColor;
            [self.view addSubview:settingView];
        }
        flagMenuopen=1;
        [UIView animateWithDuration:1.0 animations:^{
            settingView.frame = CGRectMake(self.view.frame.size.width-(settingView.frame.size.width), self.view.frame.size.height-(settingView.frame.size.height+55), settingView.frame.size.width, settingView.frame.size.height);
        }];
        settingView.hidden=false;
        
    }
    

}


- (IBAction)btnFavoriteTabAction:(id)sender {
    
    [userDefault setObject:@"1" forKey:@"isFromContact"];
    
    [TagSelect removeFromSuperview];
    FavoriteContectViewController *vcFavoriteContact=[self.storyboard instantiateViewControllerWithIdentifier:@"FavoriteContectViewController"];
   [self.navigationController pushViewController:vcFavoriteContact animated:NO];
   
    
    //vcFavoriteContact.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //[self.navigationController presentViewController:vcFavoriteContact animated:YES completion:NULL];
}

- (IBAction)btnCategoryAction:(id)sender {
    
   //  arrCategory = [[NSMutableArray alloc]init];
   // [arrCategory addObject:@"Add New Category"];
    
   // appDelegate.arrCategoryglobal=arrCategory;
    
    self.destinationCollectionView.hidden=NO;
    
   // [self callWebserviceForCategory];
   
    //from database
    NSString *query = @"select * from Categories";
    NSMutableArray *arrtempcat=[Database executeQuery:query];
    
    NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
    
    if (arrtempcat.count>0) {
        
        [arrTemp addObject:@"Add New Category"];
        [userDefault setObject:arrtempcat forKey:@"category_contact"];
      
        for (int i=0;i<[arrtempcat count];i++) {
            [arrTemp addObject:[[arrtempcat valueForKey:@"cate_name"]objectAtIndex:i]];
        }
      
        self.btnCategory.hidden=YES;
        _destinationCollectionView.hidden=NO;
    }
    else{
        
        [arrTemp addObject:@"Add New Category"];
        self.sourceCollectionView.hidden=YES;
        self.btnCategory.hidden=NO;

    }
    
    appDelegate.arrCategoryglobal=arrTemp;
    //[_sourceCollectionView reloadData];
    [_destinationCollectionView reloadData];
    
    
}

-(void)hideCategoryButtonAction
{
    self.btnCategory.hidden=NO;
    self.destinationCollectionView.hidden=YES;
}

#pragma mark - Drag Method
- (void)setSelectedModel:(MyModel *)model atPoint:(CGPoint)point {
    _model = model;
   
    
    if (_model != nil) {

        _draggedCard.label.text = [NSString stringWithFormat:@"%d", model.value];
        _draggedCard.center = point;
        _draggedCard.hidden = NO;
        
        _draggedCard.name.text=[NSString stringWithFormat:@"%@ %@",model.firstName,model.lastName];
        
        
        //Lazy Loading--------BEGIN
        NSString *strPhotoURL=nil;
        NSString *urlFromDict=model.imgUrl;
        NSLog(@"%@",urlFromDict);
        if(urlFromDict!=nil && ![[urlFromDict trimSpaces] isEqualToString:@""])
        {
            strPhotoURL=[WEBSERVICE_IMG_BASE_URL stringByAppendingPathComponent:urlFromDict];
            
        }
        
        NSIndexPath *indexPath=[_sourceCollectionView indexPathForItemAtPoint:point];
        
        if(indexPath)
        {
            _draggedCard.imgUser.image = nil;
            if(strPhotoURL != nil){
                UIImage *image = [self imageIfExist:strPhotoURL];
                NSLog(@"%@",strPhotoURL);
                [self setImageURL:strPhotoURL forIndexPath:indexPath];
                
                if(image){
                    _draggedCard.imgUser.image = image;
                    //                [cell.indicator stopAnimating];
                }
                else{
                    [self startDownloadingImage:strPhotoURL withIndexPath:indexPath];
                    //                [cell.indicator startAnimating];
                }
            }
            else{
                //        [cell.indicator stopAnimating];
                _draggedCard.imgUser.image = [UIImage imageNamed:IMAGE_PLACEHOLDER];
            }
            //Lazy Loading-------- END
            
            _draggedCard.imgUser.layer.cornerRadius=_draggedCard.imgUser.frame.size.height/2;
            _draggedCard.imgUser.layer.masksToBounds=YES;
            _draggedCard.imgUser.layer.borderWidth=0;
            
            [self updateCardViewDragState:[self isValidDragPoint:point]];
        }
      
    } else {
        _draggedCard.hidden = YES;
    }
}

#pragma mark - Validation helper methods on drag and drop
- (BOOL)isValidDragPoint:(CGPoint)point {
    //return !CGRectContainsPoint(self.sourceCollectionView.frame, point);
    
    CGRect frame=CGRectMake(self.destinationCollectionView.frame.origin.x+150,self.destinationCollectionView.frame.origin.y,self.destinationCollectionView.frame.size.width-150,self.destinationCollectionView.frame.size.height);
    
    return CGRectContainsPoint(frame, point);
}

- (void)updateCardViewDragState:(BOOL)validDropPoint {
    if (validDropPoint) {
        _draggedCard.alpha = 1.0f;
    } else {
        _draggedCard.alpha = 0.2f;
    }
}

#pragma mark - initialization code
- (void)initDraggedCardView {
    _draggedCard = [[CardView alloc] initWithFrame:CGRectMake(0, 0, 120, 140)];
    _draggedCard.hidden = YES;
    [_draggedCard setHighlightSelection:YES];
    
    [self.view addSubview:_draggedCard];
}

#pragma mark - Pan Gesture Recognizers/delegate
- (void)handlePan:(UIPanGestureRecognizer *)gesture {
   
    CGPoint touchPoint = [gesture locationInView:self.view];
    
    
    //for getting category index
    CGPoint collectionTouchPoint = [gesture locationInView:_destinationCollectionView];
   
    NSIndexPath *indexPath=[_destinationCollectionView indexPathForItemAtPoint:collectionTouchPoint];
    NSLog(@"Row : = %ld" ,(long)indexPath.row);
    categoryindex=(int)indexPath.row;      //setting a category index
    
    
    
    if (gesture.state == UIGestureRecognizerStateChanged
        && !_draggedCard.hidden) {
        // card is dragged
        _draggedCard.center = touchPoint;
        [self updateCardViewDragState:[self isValidDragPoint:touchPoint]];
    } else if (gesture.state == UIGestureRecognizerStateRecognized
               && _model != nil) {
        _draggedCard.hidden = YES;
        
        BOOL validDropPoint = [self isValidDragPoint:touchPoint];
        [_sourceViewController cellDragCompleteWithModel:_model withValidDropPoint:validDropPoint];
        if (validDropPoint) {
            [_destinationViewController addModel:_model];
            
            if(categoryindex!=0)
            {
                if(flagCateGorydata==1)
                {
                    [self callWebserviceForremovefromcategory:categoryindex];
                }
                else
                {
                    [self callWebserviceForPutCategory];  //calling put category webservice
                }
                
            }
            
        }
       _model = nil;
        
        
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Action Method
- (IBAction)btnTagAction:(id)sender {
   
//    self.imgTopLogo.hidden=YES;
//    self.ScrlViewSearch.hidden=NO;
//    self.ContentViewSearch.hidden=NO;
//    self.txtSearch.hidden=NO;
    isTagButtonSearch=1;
    [self.txtSearch resignFirstResponder];
    
    [_sourceViewController.arrtags removeAllObjects];
    [_sourceCollectionView reloadData];
    
    BOOL doesContain = [self.view.subviews containsObject:TagSelect];
    
    if(doesContain)
    {
        
    }
    else
    {
        TagSelect =[TagSelectionView loadView];
        TagSelect.delegate=self;
        TagSelect.frame=CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+64,self.view.frame.size.width,self.view.frame.size.height-117);
        [self.view addSubview:TagSelect];

    }
}

- (IBAction)btnSearchAction:(id)sender
{
    [self.txtSearch becomeFirstResponder];
    
    //when search start hide contact by setupmodel by nill array
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    appDelegate.isfromSearch=YES;
    [_sourceViewController setUpModels:arr];
    
    
    if(![sender isSelected])
    {
        [sender setSelected:YES];
        self.btnTopLogo.hidden=YES;
        [self.btnTopLogo setUserInteractionEnabled:NO];
        self.ScrlViewSearch.hidden=NO;
        self.ContentViewSearch.hidden=NO;
        self.txtSearch.hidden=NO;
        self.btnTag.hidden=NO;
        
    }
    else
    {
        [sender setSelected:NO];
        self.txtSearch.text=@"";
        self.btnTopLogo.hidden=NO;
        [self.btnTopLogo setUserInteractionEnabled:YES];

        self.ScrlViewSearch.hidden=YES;
        self.ContentViewSearch.hidden=YES;
        self.txtSearch.hidden=YES;
        self.btnTag.hidden=YES;
        [self.txtSearch resignFirstResponder];
        
//        if([[userDefault objectForKey:@"isBuy"]isEqualToString:@"0"])
//        {
//            NSString *query = @"select * from Contact_Detail LIMIT 25";
//            NSMutableArray *arrtemp=[Database executeQuery:query];
//            [_sourceViewController setUpModels:arrtemp];
//        }
//        else
//        {
//            NSString *query = @"select * from Contact_Detail";
//           NSMutableArray *arrtemp=[Database executeQuery:query];
//            [_sourceViewController setUpModels:arrtemp];
//
//        }
         appDelegate.isfromSearch=YES;
         [_sourceViewController setUpModels:arrContacts];
      
    }
    
    //removing view
    [TagSelect removeFromSuperview];
    
    for (UIButton *btn in self.viewSearchTag.subviews) {
        [btn removeFromSuperview];
    }
    
    [_sourceViewController.arrtags removeAllObjects];
    [_sourceCollectionView reloadData];

    
}

#pragma mark - search by tag

#pragma mark - delegate method
-(void)btnTagSearchAction:(NSMutableArray *)selectedtagarray
{
    self.viewSearchTag.hidden=NO;
    [TagSelect removeFromSuperview];
    
    
    //code for seding count  to usage statastic webservice
    NSString *str=[NSString stringWithFormat:@"Select tagSearch from SubmitUsageStatistics"];
    NSArray *a=[Database executeQuery:str];
    
    
    CountForTagSearch=[[[a valueForKey:@"tagSearch"]objectAtIndex:0]intValue];
    
    if([[[a valueForKey:@"tagSearch"]objectAtIndex:0]isEqualToString:@"0"])
    {
        CountForTagSearch=1;
        NSString *query= [NSString stringWithFormat:@"update SubmitUsageStatistics set tagSearch='%d'",CountForTagSearch];
        [Database executeQuery:query];
        
    }
    else
    {
        CountForTagSearch++;
        NSString *query= [NSString stringWithFormat:@"update SubmitUsageStatistics set tagSearch='%d'",CountForTagSearch];
        [Database executeQuery:query];
     }
    
    
    [self setTagsView:selectedtagarray];
}
#pragma mark- source view delegate method
-(void)tagClickForSearchAction:(int)buttontag
{
    self.viewSearchTag.hidden=NO;
   // self.txtSearch.hidden=YES;
    self.txtSearch.text=@"";
    
    NSMutableArray *temparray=[[NSMutableArray alloc]init];
   [temparray addObject:[arrSearchTag objectAtIndex:buttontag]];
    
    [self setTagsView:temparray];
}
#pragma mark -set tag method
-(void)setTagsView:(NSMutableArray *)arrselectedtag;
{
    for (UIButton *btn in self.viewSearchTag.subviews) {
        [btn removeFromSuperview];
    }
    
    int x = 2;
    int y = 3;
    
    CGRect frame =  self.viewSearchTag.frame;
    for (int i = 0; i < arrselectedtag.count; i++) {
        
       // NSDictionary *dictTags = [arrselectedtag objectAtIndex:i];
        btnTags= [[UIButton alloc]init];
        btnTags.userInteractionEnabled = true;
        btnTags.tag = i;
        
        btnTags.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
        [btnTags setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1] forState:UIControlStateNormal];
        [btnTags setTitle:[[arrselectedtag valueForKey:@"tag_name"] objectAtIndex:i] forState:UIControlStateNormal]; //[[arrTags valueForKey:@"tag_name"] objectAtIndex:i]
        [btnTags sizeToFit];
        [btnTags addTarget:self action:@selector(btnTagAction:) forControlEvents:UIControlEventTouchUpInside];
        btnTags.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btnTags.layer.borderWidth = 1;
        btnTags.layer.cornerRadius = 7;
        btnTags.layer.masksToBounds = true;
        btnTags.titleLabel.font = [UIFont systemFontOfSize:13.0];
        
        CGRect btnframe = btnTags.frame;
       // float tempX = x + btnTags.frame.size.width;
       // if (tempX > self.viewSearchTag.frame.size.width-10) {
       //     x = 2;
       //     y = y + 32;
       // }
      //  else{
            
       // }
        btnframe.origin.x = x;
        btnframe.origin.y = y;
        btnframe.size.height = 28;
        btnTags.frame = btnframe;
        [self.viewSearchTag addSubview:btnTags];
        x = x+btnTags.frame.size.width+3 ;
        //frame.size.height = y+31;
        frame.size.width=x;
    }
    self.viewSearchTag.frame = frame;
    // self.tagViewHeight.constant=frame.size.height;
    self.ScrlViewSearch.contentSize = CGSizeMake(frame.size.width+20, frame.size.height);
    
    [arrSearchContact removeAllObjects];
    
    //making search
    for(UIButton *btn in self.viewSearchTag.subviews )
    {
        
        NSString *searchStr =[[arrselectedtag valueForKey:@"tag_id"]objectAtIndex:btn.tag];
        //NSString *searchStr = btn.titleLabel.text;
        if(searchStr.length>0)
        {
           // NSPredicate *ContactPredicate=[NSPredicate predicateWithFormat:@"(first_name CONTAINS[c] %@) OR (last_name CONTAINS[c] %@)",searchStr,searchStr];
            
            NSString *SelectQuery=[NSString stringWithFormat:@"select cat.*,cnt.* from Tag_Contact_relation cat left join Contact_Detail cnt on cnt.contact_id=cat.contact_id where cat.tag_id ='%@'",searchStr];
            
            NSMutableArray *temparray=[Database executeQuery:SelectQuery];
            
            if(isTagButtonSearch==1)
            {
                
              // NSMutableArray *temparray=[[arrContacts filteredArrayUsingPredicate:ContactPredicate]mutableCopy];
                
                if(temparray.count>0 && ![temparray isKindOfClass:[NSNull class]])
                {
                    for(int i=0;i<[temparray count];i++)
                    {
                        //[arrSearchContact addObject:[temparray objectAtIndex:i]];
                        
                        //for checking duplicate
                        for (int i = (int)temparray.count-1; i>= 0; i-- )
                        {
                            NSMutableDictionary* D1 = [temparray objectAtIndex:i];
                            BOOL hasDuplicate = [[arrSearchContact filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"contact_id == %@", [D1 objectForKey:@"contact_id"]]] count] > 0;
                            
                            if (!hasDuplicate)
                            {
                                [arrSearchContact addObject:D1];
                            }
                        }
                      
                    }
                    
                }
                
            }
            else
            {
               // arrSearchContact = [[arrContacts filteredArrayUsingPredicate:ContactPredicate]mutableCopy];
                arrSearchContact=temparray;
            }
           
        }
    }
    
    
    appDelegate.isfromSearch=YES;
    [_sourceViewController setUpModels:arrSearchContact];
    [_sourceCollectionView reloadData];
 }

#pragma mark -textfeild Method
- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    for (UIButton *btn in self.viewSearchTag.subviews) {
        [btn removeFromSuperview];
    }
    
    [TagSelect removeFromSuperview];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSLog(@"%@",arrContacts);
    
    
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(searchStr.length>0)
    {

        NSPredicate *ContactPredicate=[NSPredicate predicateWithFormat:@"(first_name CONTAINS[c] %@) OR (last_name CONTAINS[c] %@)",searchStr,searchStr];
        arrSearchContact = [[arrContacts filteredArrayUsingPredicate:ContactPredicate]mutableCopy];
        appDelegate.isfromSearch=YES;
        [_sourceViewController setUpModels:arrSearchContact];
        [_sourceCollectionView reloadData];
        
        
        //for tag
        NSPredicate *TagPredicate=[NSPredicate predicateWithFormat:@"tag_name CONTAINS[c] %@",searchStr,searchStr];
        
        arrSearchTag = [[arrTag filteredArrayUsingPredicate:TagPredicate]mutableCopy];
        if([arrSearchTag count]>0)
        {
             _sourceViewController.arrtags=arrSearchTag;
             [_sourceCollectionView reloadData];
        }
        else
        {
            [_sourceViewController.arrtags removeAllObjects];
            [_sourceCollectionView reloadData];

        }
    }
    else
    {
        //this code is for if erase search text feild then show default data

        appDelegate.isfromSearch=YES;
        [_sourceViewController setUpModels:arrContacts];
        
        
    }
    return YES;
}
- (IBAction)btnTopLogoAction:(id)sender {

    appDelegate.isfromSearch=NO;
    flagCateGorydata=0;
    [_sourceViewController setUpModels:[NSMutableArray arrayWithObject:@""]];
    [_sourceCollectionView reloadData];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

//not required method
-(void)callWebserviceForGetCategoryMembers:(int)index
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateCategories" forKey:@"action"];
        
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"members" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        
        //getting category id;
        NSArray *keys = [[userDefault objectForKey:@"category_contact"] allKeysForObject:[appDelegate.arrCategoryglobal objectAtIndex:index]];
        NSString *yourKey;
        if ([keys count] > 0)
        {
            yourKey = keys[0];
        }
        NSLog(@"%@",yourKey);
        [dict setObject:[yourKey stringByReplacingOccurrencesOfString:@"Category" withString:@""] forKey:@"categoryId"];
        
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
            {
                
                //  Global.cursor = Splash.db.rawQuery("select cat.*,cnt.* from Categorie_contact_relation cat left join Contact_Detail cnt on cnt.senderId=cat.senderId where cat.cate_id =" + cate_id);
                
                
                NSString *SelectQuery1=[NSString stringWithFormat:@"select * from Contact_Detail"];
                NSArray *a=[Database executeQuery:SelectQuery1];
                NSLog(@"%@",a);
                
                NSString *SelectQuery2=[NSString stringWithFormat:@"select * from Categorie_contact_relation"];
                NSArray *b=[Database executeQuery:SelectQuery2];
                NSLog(@"%@",b);
                
                
                arrtotalContact=[[NSArray alloc]init];
                arrtotalContact = [[dict objectForKey:@"Members"] componentsSeparatedByString:@","];
                
                
                NSMutableArray *arrContacts1=[[NSMutableArray alloc]init];
                for(int i=0;i<[arrtotalContact count];i++)
                {
                    NSString *SelectQuery=[NSString stringWithFormat:@"select cat.*,cnt.* from Categorie_contact_relation cat left join Contact_Detail cnt on cnt.contact_id=cat.contact_id where cat.cate_id ='%@'",[yourKey stringByReplacingOccurrencesOfString:@"Category" withString:@""]];
                    [arrContacts1 addObject:[Database executeQuery:SelectQuery]];
                }
                NSLog(@"%@",arrContacts1);
            }
            else
            {
                
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



-(void)callWebserviceForCategory
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateCategories" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        [dict setObject:@"get" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
            {
                [appDelegate.arrCategoryglobal removeAllObjects];
                
                NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
                
                if ([[[dict objectForKey:@"Count"] stringValue] isEqualToString:@"0"]) {
                    
                    [arrTemp addObject:@"Add New Category"];
                    self.sourceCollectionView.hidden=YES;
                    self.btnCategory.hidden=NO;
                }
                else{
                    
                    int totalCategory=[[dict objectForKey:@"Count"] intValue];
                    [arrTemp addObject:@"Add New Category"];
                    
                    NSMutableDictionary *dictTemp=[NSMutableDictionary dictionaryWithDictionary:dict];
                    [dictTemp removeObjectForKey:@"Count"];
                    [dictTemp removeObjectForKey:@"Response"];
                    
                    [userDefault setObject:dictTemp forKey:@"category_contact"];
                    
                    
                    for (NSString *key in [dictTemp allKeys]) {
                        [arrTemp addObject:[dict objectForKey:key]];
                    }
                    self.btnCategory.hidden=YES;
                    _destinationCollectionView.hidden=NO;
                }
                
                appDelegate.arrCategoryglobal=arrTemp;
                [_sourceCollectionView reloadData];
                [_destinationCollectionView reloadData];
            }
            else{
                
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


// old code
- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnMoreAction:(id)sender {
    moreOptionView.hidden=NO;
    
    [moreOptionView setAlpha:0.0f];
    //fade in
    [UIView animateWithDuration:0.5f animations:^{
        [moreOptionView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)btnByNameListAction:(id)sender {
    
    [moreOptionView setAlpha:1.0f];
    //fade in
    [UIView animateWithDuration:0.5f animations:^{
        [moreOptionView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        moreOptionView.hidden=YES;
    }];
    
    NSString *query = @"select * from tbl_profile order by first_name COLLATE NOCASE";
    
    arrContacts=[Database executeQuery:query];
    [cvContact reloadData];
}

- (IBAction)btnBySurNameListAction:(id)sender {
    
    [moreOptionView setAlpha:1.0f];
    
    //fade in
    [UIView animateWithDuration:0.5f animations:^{
        [moreOptionView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        moreOptionView.hidden=YES;
    }];
    
    NSString *query = @"select * from tbl_profile order by last_name COLLATE NOCASE";
    
    arrContacts=[Database executeQuery:query];
    [cvContact reloadData];
}

- (IBAction)btnTilesDisplayAction:(id)sender {
    
    [moreOptionView setAlpha:1.0f];
    
    //fade in
    [UIView animateWithDuration:0.5f animations:^{
        
        [moreOptionView setAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        
        moreOptionView.hidden=YES;
        
    }];
    
    [userDefault setObject:@"1" forKey:@"displayList"];
    
    [cvContact reloadData];
}

- (IBAction)btnListDisplayAction:(id)sender {
    
    [moreOptionView setAlpha:1.0f];
    
    //fade in
    [UIView animateWithDuration:0.5f animations:^{
        
        [moreOptionView setAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        
        moreOptionView.hidden=YES;
        
    }];
    
    [userDefault setObject:@"2" forKey:@"displayList"];
    
    [cvContact reloadData];
}
//search query
//NSString *SelectQuery=[NSString stringWithFormat:@"select cat.*,cnt.* from Tag_contact_relation cat left join Contact_Detail cnt on cnt.senderId=cat.senderId where  cnt.given_name  LIKE %%%@%%  or  cnt.family_name  LIKE  %%%@%% or cnt.company  LIKE %%%@%% or cnt.title LIKE  %%%@%% ",searchStr,searchStr,searchStr,searchStr];
//NSArray *A=[Database executeQuery:SelectQuery];
//NSLog(@"%@",A)
@end
