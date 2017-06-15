//
//  MyModel.h
//  DragAndDropDemo
//
//  Created by Son Ngo on 2/9/14.
//  Copyright (c) 2014 Son Ngo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyModel : NSObject

@property (nonatomic, assign) int value;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

- (instancetype)initWithValue:(int)value url:(NSString *)imgUrl fname:(NSString *)firstName lname:(NSString *)lastName;

@end
