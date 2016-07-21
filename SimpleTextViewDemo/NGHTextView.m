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



#import "NGHTextView.h"

@interface NGHTextView()<UITextViewDelegate>
{
    UIView                *_commentBgView;
    UIView                *_commentView;
    UITextView            *_commentTextView;//评论的文本框
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
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
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
    
    [[UIApplication sharedApplication].keyWindow addSubview:_commentView];
    
}
-(void)backToTheNews:(UITapGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.35 animations:^{
        _commentBgView.alpha = 0;
        _commentView.frame = CGRectMake(0, VIEW_HEIGHT +120, VIEW_WIDTH, 120);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_commentBgView removeFromSuperview];
        _commentBgView = nil;
        [_commentView removeFromSuperview];
        _commentView = nil;
        
    }];
}

#pragma mark - 设置获取系统键盘改变通知
//键盘显示的时候的处理
- (void)keyboardWShown:(NSNotification*)aNotification
{
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
        if (![_commentTextView.text isEqualToString:@""])
        {
            [self removeFromSuperview];
            [_commentBgView removeFromSuperview];
            _commentBgView = nil;
            [_commentView removeFromSuperview];
            _commentView = nil;
        }
        else{
            [self removeFromSuperview];
            [_commentBgView removeFromSuperview];
            _commentBgView = nil;
            [_commentView removeFromSuperview];
            _commentView = nil;
        }
        
    }];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [self sendMovieZNPoint];
        return NO;
    }
    return YES;
    //
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
