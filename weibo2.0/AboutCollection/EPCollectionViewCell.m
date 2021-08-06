//
//  EPCollectionViewCell.m
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/17.
//  Copyright © 2021 谢恩平. All rights reserved.
//

#import "EPCollectionViewCell.h"
#import "WebViewController.h"


@interface EPCollectionViewCell ()<UITextViewDelegate>


@end
@implementation EPCollectionViewCell




-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.isHaveRetWeet = NO;
    [self layOutView];
    [self layOutRetWeetedView];
    return self;
}
#pragma mark - 懒加载
-(NSMutableArray*)picsArray
{
    if (_picsArray==nil) {
        _picsArray = [[NSMutableArray alloc]init];
    }
    return _picsArray;
}
-(NSMutableArray*)picsImageArray
{
    if (_picsImageArray==nil) {
        _picsImageArray = [[NSMutableArray alloc]init];
    }
    return _picsImageArray;
}
-(NSMutableArray*)picsUrlArray
{
    if (_picsUrlArray==nil) {
        _picsUrlArray = [[NSMutableArray alloc]init];
    }
    return _picsUrlArray;
}


#pragma mark -
-(void)layOutView
{
    self.backgroundColor = [UIColor whiteColor];

 
    //左上角的头像
    self.headPicture = [[UIImageView alloc]initWithFrame: CGRectMake(10, 10, 50, 50)];
    [self.headPicture setBackgroundColor:[UIColor whiteColor]];
    self.headPicture.image = [UIImage imageNamed:@"touxiang"];//初始头像
    self.headPicture.layer.cornerRadius = 25;//设置切角
    self.headPicture.layer.masksToBounds = YES;//裁剪多出来的image
    [self.contentView addSubview:self.headPicture];
   
    
    //用户名
    self.screenNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10,self.bounds.size.width-70, 25)];
    self.screenNameLabel.backgroundColor = [UIColor whiteColor];
    self.screenNameLabel.textColor = [UIColor orangeColor];
    [self.contentView addSubview:self.screenNameLabel];
    
    //创建时间label
    self.createdTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 35, self.bounds.size.width-70, 25)];
    self.createdTimeLabel.backgroundColor = [UIColor whiteColor];
    self.createdTimeLabel.font = [UIFont systemFontOfSize:13];
    self.createdTimeLabel.textColor  = [UIColor lightGrayColor];
    [self.contentView addSubview:self.createdTimeLabel];
    
    
    //内容
    self.textView = [[UITextView alloc]init];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.editable = NO;//不允许编辑
    self.textView.scrollEnabled = NO;//关闭滑动
    self.textView.dataDetectorTypes = UIDataDetectorTypeLink;//自动检索URL
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.textView];
    
    //第一张图片
    self.originalPic = [[UIImageView alloc]init];
    self.originalPic.backgroundColor  = [UIColor whiteColor];
    [self.contentView addSubview:self.originalPic];
    
    
    //多图
    for (NSUInteger i=0; i<=8; i++)
    {
        
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [self.picsArray addObject:imageView];//加入imageview数组
        [self.contentView addSubview: imageView];
    }
    
    
    
    //收藏按钮
    self.collectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-50, 20, 30, 20 )];
    [self.collectionBtn setBackgroundImage:[UIImage imageNamed:@"shoucang1"] forState:UIControlStateNormal];
    [self.collectionBtn addTarget:self action:@selector(collectionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.collectionBtn];
    
    //转发
    
    self.reposts_count = [[UILabel alloc]init];
    self.reposts_count.textAlignment = NSTextAlignmentCenter;
    self.reposts_count.backgroundColor = [UIColor clearColor];
    self.zhuanfa = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"zhuanfa"]];
    [self.zhuanfa setFrame:CGRectZero];
    [self.contentView addSubview:self.zhuanfa];
    [self.contentView addSubview:self.reposts_count];
    
    //评论
    self.comments_count = [[UILabel alloc]init];
    self.comments_count.textAlignment = NSTextAlignmentCenter;
    self.pinglun = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"pinglun"]];
    [self.pinglun setFrame:CGRectZero];
    
    [self.contentView addSubview:self.pinglun];
    [self.contentView addSubview:self.comments_count];
    
    //点赞
    self.attitudes_count = [[UILabel alloc]init];
    self.attitudes_count.textAlignment = NSTextAlignmentCenter;
    self.dianzan = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"dianzan"]];
    [self.dianzan setFrame:CGRectMake(30+2*self.bounds.size.width/3, self.bounds.size.height-30, 20, 20)];
    
    [self.contentView addSubview:self.dianzan];
    [self.contentView addSubview:self.attitudes_count];
     
}

-(void) loadAllImage
{
    //异步加载
    //设置线程管理器
    NSOperationQueue* operationQueue = [[NSOperationQueue alloc] init];
    //添加子线程，用来加载图片和第一张图
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadProfileAndFirstImage) object:nil];
    [operationQueue addOperation:op1];
    //添加子线程，用来加载多图
    if(self.status.picUrlStringArray.count>1)
    {
    NSInvocationOperation* op2 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadPics) object:nil];
    [operationQueue addOperation:op2];
    }
}
//加载头像和第一张网上图片
- (void)downloadProfileAndFirstImage
{
    NSURL* originalPicUrl = [NSURL URLWithString:self.status.original_pic];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.profileImageUrl]];
    UIImage* image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:originalPicUrl]];
    
    //在主线程中做信息更新，不然会报错。
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.headPicture.image = image;
        self.originalPic.image = image2;
    }];
}

- (void)loadPics
{
    if(self.picsUrlArray.count==0)
    {
        for(NSString* urlStr in self.status.picUrlStringArray)
        {
        NSURL* picsUrl1 = [NSURL URLWithString:urlStr];
        [self.picsUrlArray addObject:picsUrl1];
        }
    }
   
    //加载image
    for (NSURL* url in self.picsUrlArray)
    {
        UIImage* image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url] ];
        [self.picsImageArray addObject:image];
    }
    
    //在主线程中做信息更新，不然会报错。
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        for(NSUInteger i=0;i<=self.picsUrlArray.count-1;i++)
        {
            UIImageView* imageView = self.picsArray[i];
            [imageView setImage:self.picsImageArray[i]];
        }
    }];
    
  
}

   


#pragma mark - uitextview delegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    
    NSString* str = [URL absoluteString];
    [self.delegate passUrlwith:str];
    //无意中发现。return no 就不会再执行打开Safari的操作了，可以以此类推返回值为bool的方法是不是都有这种可能
    return NO;
}


- (void) layOutRetWeetedView
{
    
    self.retWeetTextView = [[UITextView alloc]init];
    self.retWeetTextView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.retWeetTextView.editable = NO;//不允许编辑
    self.retWeetTextView.scrollEnabled = NO;//关闭滑动
    self.retWeetTextView.dataDetectorTypes = UIDataDetectorTypeLink;//自动检索URL
    self.retWeetTextView.delegate = self;
    self.retWeetTextView.font = [UIFont systemFontOfSize:12];
    self.retWeetTextView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);

    [self.contentView addSubview:self.retWeetTextView];
}


//获取适应文本的高度
- (float) heightForString:(NSString *)str andWidth:(float)width
{
    UITextView* temp = [[UITextView alloc]init];
    temp.text = str;
     CGSize sizeToFit = [temp sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

#pragma mark - 设置frame和加载图片数据
- (void) setViewsFrame
{
   
    //设置在收藏列表中 收藏按钮的图片
    if(self.status.isCollection == YES)
    {
        [self.collectionBtn setImage:[UIImage imageNamed:@"shoucang2"] forState:UIControlStateNormal];
    }
    
    //设置原微博文本的frame
    [self.textView setFrame:CGRectMake(0, self.headPicture.frame.origin.y+50, ScreenWidth, self.textViewHeigth)];
    
    //如果多图数组里面只有一张图片或者没有图片
    if(self.status.picUrlStringArray.count<=1)
    {
        //设置第一张图片的frame
        if(self.status.original_pic !=nil)
        {
            [self.originalPic setFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame), 300, 200)];
            self.originalPic.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
    else
    {
        //多图
        NSUInteger allCols = 3;//初始化总列数
        CGFloat margin = 5;//设置图片间距
        CGFloat width = (ScreenWidth-2*margin)/3.0;//设置图片宽度
            //九宫格算法得出图片位置
            for (NSUInteger i=0; i<=8; i++)
            {
                CGFloat x = (margin+width)*(i%allCols);
                CGFloat y = (margin+width)*(i/allCols);
                UIImageView* imageView = self.picsArray[i];
                [imageView setFrame:CGRectMake(x, y+CGRectGetMaxY(self.textView.frame), width, width)];
            }
   
   
    }
    
    //如果有转发微博
    if(self.isHaveRetWeet)
        {
            if(self.status.original_pic ==nil)
            {
            [self.retWeetTextView setFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame), ScreenWidth, self.retWeetTextHeight)];
            }
            else
            {
                [self.retWeetTextView setFrame:CGRectMake(0, CGRectGetMaxY(self.originalPic.frame), ScreenWidth, self.retWeetTextHeight)];
            }
        }
    

    //设置六个控件的统一高度
    CGFloat height = 0;
    if(self.isHaveRetWeet)
    {
        height = CGRectGetMaxY(self.retWeetTextView.frame)+5;
    }
    else
    {
        //如果第一张图片为空
        if(self.status.original_pic==nil)
        {
            height = CGRectGetMaxY(self.textView.frame)+5;
        }
        else
        {
            //如果配图数组的个数小于等于1
            if(self.status.picUrlStringArray.count<=1)
            {
                height = CGRectGetMaxY(self.originalPic.frame)+5;
            }
            else
            {
                height = CGRectGetMaxY(self.textView.frame)+self.picHeight+5;
            }
        }
        
    }
    
    //设置转发
    [self.reposts_count setFrame:CGRectMake(0,height,ScreenWidth/3, 20)];
    [self.zhuanfa setFrame:CGRectMake(30,height, 20, 20)];
    //设置评论
    [self.comments_count setFrame:CGRectMake(ScreenWidth/3,height,ScreenWidth/3, 20)];
    [self.pinglun setFrame:CGRectMake(30+ScreenWidth/3,height, 20, 20)];
    //设置点赞
    [self.attitudes_count setFrame:CGRectMake(ScreenWidth*2/3,height,ScreenWidth/3, 20)];
    [self.dianzan setFrame:CGRectMake(30+ScreenWidth*2/3,height, 20, 20)];
    
    //加载图片
    if(self.headPicture!=nil)
    {
    [self loadAllImage];
    }
    
    
}

#pragma mark - 模型转字典
- (NSDictionary*)dicWithModel:(EPStatuses*)status
{
    NSNumber* number1 = [NSNumber numberWithUnsignedInteger:status.attitudes_count];
    NSNumber* number2 = [NSNumber numberWithUnsignedInteger:status.comments_count];
    NSNumber* number3 = [NSNumber numberWithUnsignedInteger:status.reposts_count];
    
    NSMutableDictionary* tempDic = [[NSMutableDictionary alloc]init];
    [tempDic setValue:number1 forKey:@"attitudes_count"];
    [tempDic setValue:number2 forKey:@"comments_count"];
    [tempDic setValue:number3 forKey:@"reposts_count"];
    [tempDic setValue:status.text forKey:@"text"];
    [tempDic setValue:status.created_at forKey:@"created_at"];
    [tempDic setValue:status.retweeted_status forKey:@"retweeted_status"];//转发的
    [tempDic setValue:status.original_pic forKey:@"original_pic"];

    NSDictionary* dic = tempDic;
    return dic;
}


//按钮点击响应delegate方法
- (void) collectionBtnClick
{
    //设置收藏按钮的图片
    if(self.status.isCollection == NO)
    {
        [self.collectionBtn setImage:[UIImage imageNamed:@"shoucang2"] forState:UIControlStateNormal];
    }
    else
    {
        [self.collectionBtn setImage:[UIImage imageNamed:@"shoucang1"] forState:UIControlStateNormal];
    }
    
    [self.delegate passBtnClick:self.indexPath];
    
    
}


@end
