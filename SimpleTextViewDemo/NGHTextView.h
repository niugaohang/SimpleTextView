//
//  NGHTextView.h
//  NewMedSci
//
//  Created by M-SJ076 on 16/7/19.
//  Copyright © 2016年 MedSci. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^myTextBlock)(NSString *commentText);

@interface NGHTextView : UIView

@property(nonatomic, assign)NSString *placeholderStr;

-(id)initWithblock:(myTextBlock)comeBlock;
//展示
-(void)showShareView;
//移除
-(void)removeSelfView;

@end
