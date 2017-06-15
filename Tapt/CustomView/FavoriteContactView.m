//
//  FavoriteContactView.m
//  Tapt
//
//  Created by TriState  on 8/3/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "FavoriteContactView.h"

@implementation FavoriteContactView
-(void)awakeFromNib{
    
    arrFavoriteContact=[NSMutableArray array];
    
    NSString *selectQuery = [ NSString stringWithFormat:@"select * from Contact_Detail where Favorite=%@",[NSString stringWithFormat:@"1"]];
    arrFavoriteContact=[Database executeQuery:selectQuery];
    [self.collVIewFavoriteContect reloadData];

    
}
#pragma mark - UICollectionViewDelegate Method

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrFavoriteContact count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FavoriteContactCVCell *cell = (FavoriteContactCVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"FavoriteContactCVCell" forIndexPath:indexPath];
    if (cell==Nil) {
        cell = [[FavoriteContactCVCell alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    
    NSString *strnamesurname=[NSString stringWithFormat:@"%@ %@",[[arrFavoriteContact valueForKey:@"first_name"]objectAtIndex:indexPath.row],[[arrFavoriteContact valueForKey:@"last_name"]objectAtIndex:indexPath.row]];
    cell.lblNameSurname.text=strnamesurname;
    
    //Lazy Loading--------BEGIN
  /*  NSString *strPhotoURL=nil;
    NSString *urlFromDict=[[arrFavoriteContact valueForKey:@"image_url"]objectAtIndex:indexPath.row];
    if(urlFromDict!=nil && ![[urlFromDict trimSpaces] isEqualToString:@""])
    {
        strPhotoURL=[WEBSERVICE_IMG_BASE_URL stringByAppendingPathComponent:urlFromDict];
        
    }
    cell.imgUserProfile.image = nil;
    if(strPhotoURL != nil){
        UIImage *image = [self imageIfExist:strPhotoURL];
        [self setImageURL:strPhotoURL forIndexPath:indexPath];
        
        if(image){
            cell.imgUserProfile.image = image;
            [cell.indicator stopAnimating];
        }
        else{
            [self startDownloadingImage:strPhotoURL withIndexPath:indexPath];
            [cell.indicator startAnimating];
        }
    }
    else{
        [cell.indicator stopAnimating];
        cell.imgUserProfile.image = [UIImage imageNamed:IMAGE_PLACEHOLDER];
    }
    //Lazy Loading-------- END
    
    cell.imgUserProfile.layer.cornerRadius=cell.imgUserProfile.frame.size.height/2;
    cell.imgUserProfile.layer.masksToBounds=YES;
    cell.imgUserProfile.layer.borderWidth=0;*/
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    ContactDetailViewController *vcContactDetail=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactDetailViewController"];
//    vcContactDetail.dictContact=[arrFavoriteContact objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:vcContactDetail animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20,5,0,5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(95,115);
}



#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
