//
//  SourceViewController.m
//  DragAndDropDemo
//
//  Created by Son Ngo on 2/10/14.
//  Copyright (c) 2014 Son Ngo. All rights reserved.
//

#import "SourceViewController.h"
#import "ContactCVCell.h"
#import "Database.h"
#import "DetailViewController.h"


@interface SourceViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
  UICollectionView *_collectionView;
  ContactViewController *_parentController;
  NSMutableArray *_models;
  MyModel *_selectedModel;
}
@end


#pragma mark -
@implementation SourceViewController
//@synthesize mydelegate;
@synthesize arrContacts,arrtags;
- (instancetype)initWithCollectionView:(UICollectionView *)view andParentViewController:(ContactViewController *)parent {
      [appDelegate setShouldRotate:NO];
  if (self = [super init]) {
    //[self setUpModels];
     
    //setup model with default data
    appDelegate.isfromSearch=NO;
    [self setUpModels:[NSMutableArray arrayWithObject:@""]];
    
    [self initCollectionView:view];
    [self setUpGestures];
    
    _parentController = parent;
      
   appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
  }
  return self;
}

- (void)cellDragCompleteWithModel:(MyModel *)model withValidDropPoint:(BOOL)validDropPoint {
  if (model != nil) {
    // get indexPath for the model
    //NSUInteger index = [_models indexOfObject:model];  //change here by kishan
    int index = (int)[_models indexOfObject:model];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
      appDelegate = [[UIApplication sharedApplication]delegate];
      appDelegate.contactindex = index;
   
      if (validDropPoint && indexPath != nil) {
      [_models removeObjectAtIndex:index];
      [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
      [_collectionView reloadData];
    } else {
      
      UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
      cell.alpha = 1.0f;
    }
  }
}


#pragma mark - Setup methods
- (void)setUpModels:(NSMutableArray *)arr {
    
//   if((arr == nil || [arr count] == 0))
//   {
//      //this code is when serch then getting search array and display in collection view
//       _models = [NSMutableArray array];
//       for (int i=0; i<[arr count]; i++) {
//           NSDictionary *dictContact=[arr objectAtIndex:i];
//           [_models addObject:[[MyModel alloc] initWithValue:i url:[dictContact objectForKey:@"image_url"] fname:[dictContact objectForKey:@"first_name"] lname:[dictContact objectForKey:@"last_name"]]];
//       }
//
//   }
//   else
//   {
   
      if(appDelegate.isfromSearch)
      {
          appDelegate.isfromSearch=NO;
          arrContacts=arr;
          NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"first_name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
          arrContacts=[[arrContacts sortedArrayUsingDescriptors:@[sort]]mutableCopy];
      }
      else
      {
          //this code is first time loding data in collection view
          if([[[userDefault objectForKey:@"isBuy"]stringValue]isEqualToString:@"0"])
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

      }
    
    
       _models = [NSMutableArray array];
       for (int i=0; i<[arrContacts count]; i++) {
           NSDictionary *dictContact=[arrContacts objectAtIndex:i];
           [_models addObject:[[MyModel alloc] initWithValue:i url:[dictContact objectForKey:@"image_url"] fname:[dictContact objectForKey:@"first_name"] lname:[dictContact objectForKey:@"last_name"]]];
       }

   //}
    
}

- (void)initCollectionView:(UICollectionView *)view {
  _collectionView            = view;
  _collectionView.delegate   = self;
  _collectionView.dataSource = self;
}

- (void)setUpGestures {
  
  UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
    action:@selector(handlePress:)];
  longPressGesture.numberOfTouchesRequired = 1;
  longPressGesture.minimumPressDuration    = 0.1f;
  [_collectionView addGestureRecognizer:longPressGesture];
}

#pragma mark - Gesture Recognizer
- (void)handlePress:(UILongPressGestureRecognizer *)gesture {
  CGPoint point = [gesture locationInView:_collectionView];
 
  if (gesture.state == UIGestureRecognizerStateBegan) {
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:point];
    if (indexPath != nil) {
      _selectedModel = [_models objectAtIndex:indexPath.item];
      
      // calculate point in parent view
      point = [gesture locationInView:_parentController.view];
      
      [_parentController setSelectedModel:_selectedModel atPoint:point];
      
      // hide the cell
      [_collectionView cellForItemAtIndexPath:indexPath].alpha = 0.0f;
    }
  }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ContactCVCell *cell = (ContactCVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ContactCVCell" forIndexPath:indexPath];
    if (cell==Nil) {
        cell = [[ContactCVCell alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    
    MyModel *model = [_models objectAtIndex:indexPath.item];
  
    cell.lblName.text=[NSString stringWithFormat:@"%@ %@",model.firstName,model.lastName];
    [cell setModel:model];

    //Lazy Loading--------BEGIN
    NSString *strPhotoURL=nil;
    NSString *urlFromDict=model.imgUrl;
    if(urlFromDict!=nil && ![[urlFromDict trimSpaces] isEqualToString:@""])
    {
        strPhotoURL=[WEBSERVICE_IMG_BASE_URL stringByAppendingPathComponent:urlFromDict];
        
    }
    
    cell.imgContact.image = nil;
    if(strPhotoURL != nil){
        UIImage *image = [self imageIfExist:strPhotoURL];
        [self setImageURL:strPhotoURL forIndexPath:indexPath];
        
        if(image){
            cell.imgContact.image = image;
            [cell.indicator stopAnimating];
        }
        else{
            [self startDownloadingImage:strPhotoURL withIndexPath:indexPath];
            [cell.indicator startAnimating];
        }
    }
    else{
        [cell.indicator stopAnimating];
        cell.imgContact.image = [UIImage imageNamed:IMAGE_PLACEHOLDER];
    }
    //Lazy Loading--------BEGIN
      //Lazy Loading-------- END
    
    cell.imgContact.layer.cornerRadius=cell.imgContact.frame.size.height/2;
    cell.imgContact.layer.masksToBounds=YES;
    cell.imgContact.layer.borderWidth=0;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UINavigationController *navVc  =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    ContactDetailViewController *vcContactDetail=[storyboard instantiateViewControllerWithIdentifier:@"ContactDetailViewController"];
    vcContactDetail.dictContact=[arrContacts objectAtIndex:indexPath.row];
    [navVc pushViewController:vcContactDetail animated:YES];
}

#pragma mark- collection view Footer method
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionFooter) {
       footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        if([arrtags count]>0)
        {
            [self setTagsView];
        }
        reusableview = footerview;
    }
    return reusableview;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if([arrtags count]>0)
    {
        return CGSizeMake(self.view.frame.size.width,30);
    }
    else
    {
        return CGSizeZero;
    }
   
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(91,100);
  // return CGSizeMake(70,70);

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(5,0,0,10);
    //return UIEdgeInsetsMake(0,5, 0,5);
}

#pragma mark -set tag method
-(void)setTagsView
{
    for (UIButton *btn in footerview.ViewTagDisplay.subviews) {
        [btn removeFromSuperview];
    }
    
    int x = 2;
    int y = 3;
    
    CGRect frame = footerview.ViewTagDisplay.frame;
    for (int i = 0; i < arrtags.count; i++) {
        
        //NSDictionary *dictTags = [arrtags objectAtIndex:i];
        btnTags= [[UIButton alloc]init];
        btnTags.userInteractionEnabled = true;
        btnTags.tag = i;
        
        btnTags.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
        [btnTags setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1] forState:UIControlStateNormal];
        [btnTags setTitle:[[arrtags valueForKey:@"tag_name"]objectAtIndex:i] forState:UIControlStateNormal]; 
        [btnTags sizeToFit];
        [btnTags addTarget:self action:@selector(btnTagSearchAction:) forControlEvents:UIControlEventTouchUpInside];
        btnTags.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btnTags.layer.borderWidth = 1;
        btnTags.layer.cornerRadius = 7;
        btnTags.layer.masksToBounds = true;
        btnTags.titleLabel.font = [UIFont systemFontOfSize:13.0];
        
        CGRect btnframe = btnTags.frame;
        float tempX = x + btnTags.frame.size.width;
        if (tempX > footerview.ViewTagDisplay.frame.size.width-10) {
            x = 2;
            y = y + 32;
        }
        else{
            
        }
        btnframe.origin.x = x;
        btnframe.origin.y = y;
        btnframe.size.height = 28;
        btnTags.frame = btnframe;
        [footerview.ViewTagDisplay addSubview:btnTags];
        x = x+btnTags.frame.size.width+3 ;
        frame.size.height = y+31;
    }
    footerview.ViewTagDisplay.frame = frame;
    // self.tagViewHeight.constant=frame.size.height;
    footerview.scrlFooetrTag.contentSize = CGSizeMake(frame.size.width, frame.size.height+20);
}
-(void)btnTagSearchAction:(UIButton *)sender
{
    UIButton *btnTag =(UIButton*)sender;
   
    if ([self.mydelegate respondsToSelector:@selector(tagClickForSearchAction:)]) {
        [self.mydelegate tagClickForSearchAction:(int)btnTag.tag];
    }

}


#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
