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


-(id)initWithblock:(myTextBlock)comeBlock;

-(void)showShareView;


@end
