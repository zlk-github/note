## Eclipse 中maven导入残包解决办法

###  常见报错分析

pom导包失败分很多种情况：

	（1）一般出现的情况有相关配置错误，如地址配置错误、jar包版本冲突等(不是此处解决的问题)。。。
	
	（2）实际开发中配置错误的问题一般很少有人犯，由于公司内网的原因。很容易导致包导入变残。

踩了无数坑的我，希望将Eclipse中使用maven导入了**残包解决方式**记录下来，给予大家帮助。如错误之处还望指正。（表现为pom.xml中 <project xmlns="http:....行存在红色波浪线）

### 第一步：清空所有.lastUpdated文件

打开本地maven仓库，搜索.lastUpdated格式文件，然后全部删除。
![Alt text](./images/last.PNG)

### 第二步：maven clean

选中项目-->右击鼠标-->run as-->maven clean

输出结果如下
![Alt text](./images/clean.PNG)

### 第三步：updata maven project

选中项目-->右击鼠标-->maven-->updata maven project(如下图)；

勾选如下后选择OK.
![Alt text](./images/pom.PNG)

等待jar包导入。如果没意外，恭喜你，pom中导入成功。

如果导入还是不成功，请检测相关配置（如仓库、私服地址、jar版本等）是否正确后，再一次执行上述1、2、3中的操作。

