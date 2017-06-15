//
//  EventContactListViewController.h
//  Tapt
//
//  Created by TriState  on 7/10/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventContectListCVCell.h"
#import "LazyImageViewControllerCollectionView.h"
#import "ContactDetailViewController.h"
@interface EventContactListViewController :LazyImageViewControllerCollectionView <UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *arrEventContectlist;
    NSArray *arrtotalContact;
    NSInteger totalContact;
    NSInteger startIndex;
    NSInteger count;
    NSInteger page;
    
    
}
- (IBAction)btnBavkAction:(id)sender;
@property(strong,nonatomic) NSMutableDictionary *dictContactResponse;
@property (strong, nonatomic) IBOutlet UILabel *lblEventName;
@property (strong, nonatomic) IBOutlet UICollectionView *EventContectCollectionView;
@property (strong, nonatomic) NSString *strEventContactId;
@property (strong, nonatomic) NSString *strEventName;
@end
