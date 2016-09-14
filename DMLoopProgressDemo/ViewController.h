//
//  ViewController.h
//  DMLoopProgressDemo
//
//  Created by wangdemin on 16/9/14.
//  Copyright © 2016年 Demin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//先简单的介绍下CAShapeLayer
//1,CAShapeLayer继承自CALayer，可使用CALayer的所有属性
//2,CAShapeLayer需要和贝塞尔曲线配合使用才有意义。
//Shape：形状
//贝塞尔曲线可以为其提供形状，而单独使用CAShapeLayer是没有任何意义的。
//3,使用CAShapeLayer与贝塞尔曲线可以实现不在view的DrawRect方法中画出一些想要的图形
//
//关于CAShapeLayer和DrawRect的比较
//DrawRect：DrawRect属于CoreGraphic框架，占用CPU，消耗性能大
//CAShapeLayer：CAShapeLayer属于CoreAnimation框架，通过GPU来渲染图形，节省性能。动画渲染直接提交给手机GPU，不消耗内存
//
//贝塞尔曲线与CAShapeLayer的关系
//1，CAShapeLayer中shape代表形状的意思，所以需要形状才能生效
//2，贝塞尔曲线可以创建基于矢量的路径
//3，贝塞尔曲线给CAShapeLayer提供路径，CAShapeLayer在提供的路径中进行渲染。路径会闭环，所以绘制出了Shape
//4，用于CAShapeLayer的贝塞尔曲线作为Path，其path是一个首尾相接的闭环的曲线，即使该贝塞尔曲线不是一个闭环的曲线


@end

