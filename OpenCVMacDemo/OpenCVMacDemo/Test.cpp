//
//  Test.cpp
//  OpenCVMacDemo
//
//  Created by wztMac on 2018/11/2.
//  Copyright © 2018年 wztMac. All rights reserved.
//

#include "Test.hpp"

#include<iostream>
using namespace std;
class Test
{
public:
    Test();//无参构造函数
    Test(char *p0);
    ~Test();//析构函数:先创建的对象后释放
    void print()
    {
        cout << a << endl;
        cout << p << endl;
    }
private:
    int a;
    char *p;
};

Test::Test()//完成对属性的初始化工作
{
    a = 10;
    p = (char*)malloc(sizeof(100));
    strcpy(p, "Rita");
    cout<< "我是构造函数" << endl;
}
Test::Test(char *p0) {
    strcpy(p, p0);
}

Test::~Test()
{
    if (p != NULL)
    {
        free(p);
    }
    cout << "我是析构函数，我被调用了" << endl;
}
//给对象搭建一个平台，研究对象的行为
void objplay()
{
    //先创建的对象后释放
    Test t1;
    t1.print();
    printf("分隔符\n");
    Test t2;
    t2.print();
}
int mainTest()
{
    objplay();
    system("pause");
    return 0;
}

