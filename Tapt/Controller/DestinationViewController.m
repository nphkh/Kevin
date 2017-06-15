//
//  DestinationViewController.m
//  DragAndDropDemo
//
//  Created by Son Ngo on 2/13/14.
//  Copyright (c) 2014 Son Ngo. All rights reserved.
//

#import "DestinationViewController.h"
#import "ContactCVCell.h"
#import "categoryCVCell.h"

@interface DestinationViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate> {
  NSMutableArray *_models;
  UICollectionView *_collectionView;
}

@property (weak,nonatomic)NSString *strCategory;
@property (weak, nonatomic) NSMutableArray *arrCategory;

@end

#pragma mark -
@implementation DestinationViewController

@synthesize strCategory,arrCategory;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
  if (self = [super init]) {
    [appDelegate setShouldRotate:NO];
    _models = [NSMutableArray array];
   lblData = [[UILabel alloc]init];
    _collectionView = collectionView;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[categoryCVCell class] forCellWithReuseIdentifier:@"ContactCVCell"];
    
  }
  return self;
}

- (void)addModel:(MyModel *)model {
  [_models addObject:model];
  
  [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    arrCategory=appDelegate.arrCategoryglobal;
    
    return [arrCategory count];
    
//  return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    categoryCVCell *cell = (categoryCVCell *)[_collectionView dequeueReusableCellWithReuseIdentifier:@"categoryCVCell" forIndexPath:indexPath];
    
    cell.lblCategory.text=[arrCategory objectAtIndex:indexPath.row];
    [cell.lblCategory autosizeForHeight:cell.lblCategory.frame.size.height];
    cell.lblCategory.textAlignment = NSTextAlignmentCenter;
  
//    CGSize maximumLabelSize = CGSizeMake(187,CGFLOAT_MAX);
//    CGSize requiredSize = [cell.lblCategory sizeThatFits:maximumLabelSize];
//    CGRect labelFrame = cell.lblCategory.frame;
//    labelFrame.size.width = requiredSize.width;
//    cell.lblCategory.frame = labelFrame;
//    cell.viewBG.frame=labelFrame;
//   
  
    
//    CGFloat width =  [cell.lblCategory.text sizeWithFont:[UIFont fontWithName:@"MyriadPro-Regular" size:15 ]].width;
//    cell.lblCategory.frame = CGRectMake(cell.lblCategory.frame.origin.x,cell.lblCategory.frame.origin.x,width,cell.lblCategory.frame.size.height);

    
    cell.viewBG.layer.cornerRadius=10;
    //  MyModel *model = [_models objectAtIndex:indexPath.item];
//  cell.model = model;
    
      return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        UIAlertView *alertForMobileNo=[[UIAlertView alloc]initWithTitle:APP_NAME message:@"Enter Category Name to add Category" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
        
        alertForMobileNo.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertForMobileNo textFieldAtIndex:0].delegate = self;
        
        [alertForMobileNo show];
    }
    else
    {
        
       if ([self.delegate respondsToSelector:@selector(categoryAction:)]) {
            [self.delegate categoryAction:indexPath];
        }

    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    lblData.text=[arrCategory objectAtIndex:indexPath.row];
    [lblData autosizeForHeight:lblData.frame.size.height];
    //You may want to create a divider to scale the size by the way..
    return CGSizeMake(lblData.frame.size.width+5,40);
}
#pragma mark- collection view Footer method
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(hideCategoryButtonAction)
         forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"categories-icon.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0,0,34.0,40.0);
        [footerview addSubview:button];
        
        reusableview = footerview;
    }
    return reusableview;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
   
    return CGSizeMake(34,40);
    
}
-(void)hideCategoryButtonAction{
    
    if ([self.delegate respondsToSelector:@selector(hideCategoryButtonAction)]) {
        [self.delegate hideCategoryButtonAction];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
// // return CGSizeMake(70, 40);
//    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
//}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(20, 40, 0, 40);
// }

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"0 Index");
            break;
            
        case 1:
        {
            NSLog(@"1 Index :=%@",[alertView textFieldAtIndex:0].text);
            strCategory=[alertView textFieldAtIndex:0].text;
            
            userDefault=[NSUserDefaults standardUserDefaults];
            
            NSMutableDictionary *dict=[NSMutableDictionary dictionary];
            [dict setObject:@"operateCategories" forKey:@"action"];
            [dict setObject:@"1.14" forKey:@"version"];
            [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
            [dict setObject:@"add" forKey:@"operation"];
            [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
            [dict setObject:strCategory forKey:@"categoryName"];
            
            [self callWebserviceForAddCategory:dict];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Webservice Called

-(void)callWebserviceForAddCategory:(NSMutableDictionary *)dict
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
            {
                
                [self callWebserviceForCategory];
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
                }
                else{
                    
                    int totalCategory=[[dict objectForKey:@"Count"] intValue];
                    [arrTemp addObject:@"Add New Category"];
//                    for (int i=1; i<=totalCategory; i++) {
//                        [appDelegate.arrCategoryglobal addObject:[dict objectForKey:[NSString stringWithFormat:@"Category%d",i]]];
//                    }
                    NSMutableDictionary *dictTemp=[NSMutableDictionary dictionaryWithDictionary:dict];
                    [dictTemp removeObjectForKey:@"Count"];
                    [dictTemp removeObjectForKey:@"Response"];
                    
                    [userDefault setObject:dictTemp forKey:@"category_contact"];
                    
                    for (NSString *key in [dictTemp allKeys]) {
                        [arrTemp addObject:[dict objectForKey:key]];
                    }
                    
                    
                    //for insert in to database
                    NSString *query= [NSString stringWithFormat:@"delete from Categories"];
                    NSMutableArray *arrResponse=[NSMutableArray arrayWithArray:[Database executeQuery:query]];
                    
                    
                    for (NSString *strkey in dict) {
                        
                        NSLog(@"%@",[strkey stringByReplacingOccurrencesOfString:@"Category" withString:@""]);
                        NSLog(@"%@",[dict objectForKey:strkey]);
                        
                        NSString *insertQuery=[NSString stringWithFormat:@"insert into Categories (cate_id,cate_name)values (%@,'%@')",[strkey stringByReplacingOccurrencesOfString:@"Category" withString:@""],[dict objectForKey:strkey]];
                        
                        if([Database executeScalerQuery:insertQuery])
                        {
                            NSLog(@"Data Inserted!");
                        }
                        else
                        {
                            
                        }
                    }
                    
                }
                appDelegate.arrCategoryglobal=arrTemp;
                [_collectionView reloadData];
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
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
