//
//  ReplyController.m
//  SXY
//
//  Created by yh f on 2019/1/16.
//  Copyright © 2019 XX. All rights reserved.
//

#import "ReplyController.h"

@interface ReplyController ()<UITextViewDelegate>

@end

@implementation ReplyController{
    
    UITextView *_memoTxt;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发表评论";
    self.needHideNavBar = NO;
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self setLeftBtnWithTitle:@"取消" andColor:UIColorFromRGB(0x898989)];
    [self setRightBtnWithTitle:@"发布" andColor:UIColorFromRGB(BTNColorValue)];
    [self initUI];
}

- (void)initUI{
    
    _memoTxt= [[UITextView alloc]initWithFrame:CGRectMake(20, 15,ScreenWidth-40 , 140)];
    _memoTxt.backgroundColor = UIColorFromRGB(WhiteColorValue);
    _memoTxt.text = @"请输入您评论内容";
    _memoTxt.font =APPFONT(14);
    _memoTxt.textColor = UIColorFromRGB(LitterBlackColorValue);
    _memoTxt.delegate = self;
    [self.view  addSubview:_memoTxt];
    
}


/**
 取消
 */
-(void)respondToLeftButtonClickEvent{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 发布
 */
- (void)respondToRigheButtonClickEvent{
    if ([_memoTxt.text isEqualToString: @"请输入您评论内容"]||_memoTxt.text.length<=0) {
        [HUD show:@"请输入您评论内容"];
        return;
    }
    NSDictionary *dic = @{@"content":_memoTxt.text,
                          @"objectId":_replyId
                          };
    [CommentPL Comment_CommentSaveCircleCommentWithDic:dic withReturnBlock:^(id returnValue) {
        [HUD show:@"发布成功"];
        [self respondToLeftButtonClickEvent];
    } andErrorBlock:^(NSString *msg) {
        
    }];
    
    
    
    
}


#pragma mark - text view delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([_memoTxt.text isEqualToString: @"请输入您评论内容"]) {
        _memoTxt.text = @"";
        _memoTxt.textColor = UIColorFromRGB(BlackColorValue);
    }
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (_memoTxt.text.length<=0) {
        _memoTxt.text =@"请输入您评论内容";
        _memoTxt.textColor = UIColorFromRGB(0x939393);
        
    }
    
    return YES;
}





@end
