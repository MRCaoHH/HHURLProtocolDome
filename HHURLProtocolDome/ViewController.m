//
//  ViewController.m
//  HHURLProtocolDome
//
//  Created by caohuihui on 2016/10/19.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initUI];
    [self reloadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 20;
    frame.size.height -=64;
    _webView = [[UIWebView alloc]initWithFrame:frame];
    [self.view addSubview:_webView];
    
    UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    reloadBtn.frame = CGRectMake(0, CGRectGetMaxY(frame), frame.size.width, 44);
    [reloadBtn setTitle:@"Reload Data" forState:UIControlStateNormal];
    [reloadBtn setBackgroundColor:[UIColor redColor]];
    [reloadBtn addTarget:self action:@selector(reloadWebView) forControlEvents:UIControlEventTouchUpInside];
    reloadBtn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:reloadBtn];
}

- (void)reloadWebView{
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://baidu.com"]];
    [_webView loadRequest:request];
}

@end
