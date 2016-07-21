//
//  ViewController.m
//  SimpleTextViewDemo
//
//  Created by M-SJ076 on 16/7/21.
//  Copyright © 2016年 MedSci.cn. All rights reserved.
//

#import "ViewController.h"
#import "NGHTextView.h"
@interface ViewController ()
{
    UILabel *_textLab;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title=@"SimpleTextViewDemo";
    
    
    _textLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 74, self.view.frame.size.width-30, 80)];
    _textLab.numberOfLines=0;
    _textLab.textColor=[UIColor orangeColor];
    [self.view addSubview:_textLab];
    
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(10, 164, 40, 40);
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(textViewBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
}


-(void)textViewBtnClick
{
    NGHTextView *textView=[[NGHTextView alloc]initWithblock:^(NSString *commentText) {
        
        _textLab.text=commentText;

    }];
    
    [textView showShareView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
