//
//  CreateViewController.m
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/15.
//  Copyright © 2021 谢恩平. All rights reserved.
//
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#import "CreateViewController.h"


@interface CreateViewController ()<UITextViewDelegate>
@property (nonatomic,strong) UITextView* textView;
@property (nonatomic,strong) UIButton* handInBtn;
@property (nonatomic,strong) NSMutableArray* myStatuses;




@end

@implementation CreateViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myStatuses = [self getDictionaryFromPlist];
    [self layOutView];
}
#pragma mark - 懒加载
- (NSMutableArray*)myStatuses
{
    if(_myStatuses ==nil)
    {
        _myStatuses = [[NSMutableArray alloc]init];
    }
    return _myStatuses;
}



- (void)layOutView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 400)];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.text = @"请输入：";
    self.textView.delegate  = self;
    self.textView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.textView.layer.borderWidth = 2.5;
    self.textView.layer.borderColor = [[UIColor orangeColor]CGColor] ;
    [self.view addSubview:self.textView];
    
    self.handInBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2-100, 600, 200, 50)];
    [self.handInBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.handInBtn setBackgroundImage:[UIImage imageNamed: @"orange"] forState:UIControlStateNormal];
    [self.handInBtn addTarget:self action:@selector(handInWeibo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.handInBtn];
    
}

#pragma mark - textview delegate
//将占位符去掉
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text =@"";
    return YES;
}

- (void) handInWeibo
{
    
    
    EPStatuses* statu = [[EPStatuses alloc]init];
    EPUser* user = [[EPUser alloc]init];
    user.screen_name = @"你爹";
    user.profile_image_url = @"https://tvax2.sinaimg.cn/crop.0.0.996.996.180/006FVzBlly8fmxji6cop3j30ro0rpmz3.jpg?KID=imgbed,tva&Expires=1621794643&ssig=dZdtHF2o8t";
    
    statu.text = self.textView.text;
    self.textView.text = @"";
    statu.reposts_count = 6;
    statu.comments_count = 6;
    statu.attitudes_count = 6;
    statu.users = user;
    //创建时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*8]];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    NSDate* nowDate = [NSDate date];
    statu.created_atNumber = [fmt stringFromDate:nowDate];
    //将模型专成字典
    NSDictionary* statusDic = [self dicWithModel:statu];
    [self.myStatuses addObject:statusDic];
//    NSMutableArray* mutArray = [[NSMutableArray alloc]initWithObjects:statusDic, nil];
    
    [self writeToFileWithStatusArray:self.myStatuses];
    
    
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
    [tempDic setValue:status.created_atNumber forKey:@"created_atNumber"];
    [tempDic setValue:status.retweeted_status forKey:@"retweeted_status"];//转发的
    [tempDic setValue:status.original_pic forKey:@"original_pic"];
    [tempDic setValue:[EPUser dicWithUser:status.users] forKey:@"user"];
    NSDictionary* dic = tempDic;
    return dic;
}

#pragma mark - 写进本地plist
//写进本地plist
- (void) writeToFileWithStatusArray:(NSMutableArray*)mutArray
{
   NSArray* array = mutArray;
   NSString* docpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];//返回的是一个文件数组
   NSString* filepath = [docpath stringByAppendingPathComponent:@"mystatus.plist"];
    NSLog(@"-----%@",docpath);
   [array writeToFile:filepath atomically:YES];
}
#pragma mark - 将document中的数据取出
- (NSMutableArray*)getDictionaryFromPlist
{
    NSString* docpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* filepath = [docpath stringByAppendingPathComponent:@"mystatus.plist"];
    NSMutableArray* array = [NSMutableArray arrayWithContentsOfFile:filepath];

    return array;
}


@end
