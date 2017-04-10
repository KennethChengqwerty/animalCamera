//
//  KCControlView.m
//  AnimalCamera
//
//  Created by Kenneth Cheng on 05/04/2017.
//  Copyright © 2017 Kenneth Cheng. All rights reserved.
//

#import "KCControlView.h"
#import <Masonry.h>

@interface KCControlView(){
    UIButton *_picBtn;
    
}

@end

@implementation KCControlView

-(instancetype)initWithFrame:(CGRect)frame{
    
  
    
    return [super initWithFrame:frame];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_picBtn setTitle:@"dssss" forState:UIControlStateNormal];
    [self addSubview:_picBtn];
    
    
    [_picBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(30);
        make.left.top.equalTo(self);
    }];
    
    self.backgroundColor = [UIColor whiteColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
