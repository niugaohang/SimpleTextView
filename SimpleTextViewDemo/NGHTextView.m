//
//  NGHTextView.m
//  NewMedSci
//
//  Created by M-SJ076 on 16/7/19.
//  Copyright © 2016年 MedSci. All rights reserved.
//

#define VIEW_WIDTH      [UIScreen mainScreen].bounds.size.width
#define VIEW_HEIGHT     [UIScreen mainScreen].bounds.size.height
//对话框
#define SHOW_ALERT(msg) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];\
[alert show];

#define RGB(rgb) [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UITF(float) [UIFont systemFontOfSize:float]

#import "NGHTextView.h"

@interface NGHTextView()<UITextViewDelegate>
{
    UIView                *_commentBgView;
    UIView                *_commentView;
    UITextView            *_commentTextView;//评论的文本框
    UILabel               *_placeholderLab;
}


@property (nonatomic,copy) myTextBlock textBlock;


@end



@implementation NGHTextView


-(id)initWithblock:(myTextBlock)comeBlock
{
    self = [super init];
    if (self) {
        //添加通知，来控制键盘和输入框的位置
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWShown:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        _textBlock=comeBlock;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

-(void)showShareView
{
    if (!_commentBgView)
    {
        [self initKindBgView];
    }
    if (!_commentView) {
        [self initWithCommentArticle];
    }
    if ([_commentTextView.text isEqualToString:@""])
    {
        _placeholderLab.text =self.placeholderStr;
    }
    
    [_commentTextView becomeFirstResponder];

}
-(void)initKindBgView
{
    _commentBgView = [[UIView alloc]init];
    _commentBgView.frame = CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT);
    _commentBgView.backgroundColor = [UIColor blackColor];
    _commentBgView.alpha = 0;
    
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:_commentBgView];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToTheNews:)];
    [_commentBgView addGestureRecognizer:gesture];
}
#pragma mark - 创建评论框
-(void)initWithCommentArticle
{
    
    _commentView        = [[UIView alloc]initWithFrame:CGRectMake(0,VIEW_HEIGHT+120, VIEW_WIDTH, 120)];
    _commentView.backgroundColor = RGB(241);
    _commentTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, VIEW_WIDTH-20, 100)];
    
    _commentTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 2, 10);
    _commentTextView.textColor      = [UIColor blackColor];
    _commentTextView.font           = [UIFont systemFontOfSize:15.0];
    _commentTextView.backgroundColor       = [UIColor whiteColor];
    _commentTextView.keyboardType         = UIKeyboardTypeDefault;
    _commentTextView.returnKeyType      = UIReturnKeySend;
    _commentTextView.scrollEnabled        = YES;
    _commentTextView.delegate             = self;
    _commentTextView.layer.cornerRadius   = 10;
    _commentTextView.layer.masksToBounds  = YES;
    _commentTextView.layer.borderColor    = RGB(234).CGColor;
    _commentTextView.layer.borderWidth    = 2.0f;
    [_commentView addSubview:_commentTextView];
    
//    提示信息
    _placeholderLab=[[UILabel alloc]init];
    _placeholderLab.frame =CGRectMake(15, 9, VIEW_WIDTH-50, 20);
    _placeholderLab.text =self.placeholderStr;
    _placeholderLab.font=UITF(14);
    _placeholderLab.textColor=UIColorFromRGB(0x999999);
    [_commentTextView addSubview:_placeholderLab];

    
    [[UIApplication sharedApplication].keyWindow addSubview:_commentView];
    
}
-(void)backToTheNews:(UITapGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.35 animations:^{
        [_commentTextView resignFirstResponder];
        _commentBgView.alpha = 0;
        _commentView.frame = CGRectMake(0, VIEW_HEIGHT +120, VIEW_WIDTH, 120);
    } completion:^(BOOL finished) {
       
    }];
}

#pragma mark - 设置获取系统键盘改变通知
//键盘显示的时候的处理
- (void)keyboardWShown:(NSNotification*)aNotification
{
    if(![_commentTextView.text isEqualToString:@""])
    {
        [_placeholderLab setHidden:YES];
    }
    if([_commentTextView.text isEqualToString:@""]){
        [_placeholderLab setHidden:NO];
    }
    //获得键盘的大小
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.35 animations:^{
        _commentBgView.alpha = 0.5;
        _commentBgView.frame=CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT);
        _commentView.frame = CGRectMake(0, VIEW_HEIGHT - kbSize.height - 120, VIEW_WIDTH, 120);
        
    }];
    
}
//键盘消失的时候的处理
- (void)keyboardHidden:(NSNotification*)aNotification
{
    //让“输入条”下去
    [UIView animateWithDuration:0.35 animations:^{
        _commentBgView.alpha = 0;
        _commentView.frame = CGRectMake(0, VIEW_HEIGHT +120, VIEW_WIDTH, 120);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)removeSelfView
{
    [_commentView removeFromSuperview];
    [_commentBgView removeFromSuperview];
    [self removeFromSuperview];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if(![text isEqualToString:@""])
    {
        [_placeholderLab setHidden:YES];
    }
    if([text isEqualToString:@""]&&range.length==1&&range.location==0&&[text isEqualToString:@""]){
        [_placeholderLab setHidden:NO];
    }
    if ([text isEqualToString:@"\n"]) {
        [self sendMovieZNPoint];
        return NO;
    }
    return YES;

}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
    if(![textView.text isEqualToString:@""])
    {
        [_placeholderLab setHidden:YES];
    }
    if([textView.text isEqualToString:@""]){
        [_placeholderLab setHidden:NO];
    }
    
}


#pragma mark -发送
-(void)sendMovieZNPoint
{
    if ([_commentTextView.text isEqualToString:@""])
    {
        SHOW_ALERT(@"请输入评论内容！");
    }
    else
    {
        //                评论
        [_commentTextView resignFirstResponder];
        _textBlock(_commentTextView.text);
        _commentTextView.text=nil;

    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
