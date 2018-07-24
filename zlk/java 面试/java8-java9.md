## java8 与 java9 新特性

### 1.java8新特性

1.1 Java 8 Lambda 表达式

允许把函数作为一个方法的参数，代码更加紧凑。但是lambda 

	注：表达式只能引用标记了 final 的外层局部变量（不能在 lambda 内部修改定义在域外的局部变量，隐式的为final,若修改会报错）

	    在 Lambda 表达式当中不允许声明一个与局部变量同名的参数或者局部变量。

lambda表达式的重要特征:

	1.可选类型声明：不需要声明参数类型，编译器可以统一 识别参数值。
	2.可选的参数圆括号：一个参数无需定义圆括号，但多个参数需要定义圆括号。
	3.可选的大括号：如果主体包含了一个语句，就不需要使用大括号。
	4.可选的返回关键字：如果主体只有一个表达式返回值则编译器会自动返回值，大括号需要指定明表达式返回了一个数值。

作用：Lambda 表达式主要用来定义行内执行的方法类型接口以及解决匿名方法的实现。


	例：
	1.
	public class Java8Tester {
	    public static void main(String args[]) {
	        final int num = 1;
	        Converter<Integer, String> s = (param) -> System.out.println(String.valueOf(param + num));
	        s.convert(2);  // 输出结果为 3
	    }
	 
	    public interface Converter<T1, T2> {
	        void convert(int i);
	    }
	}

	2.for循环
	List<String> players =  Arrays.asList(atp);  
	  
	// 以前的循环方式  
	for (String player : players) {  
	     System.out.print(player + "; ");  
	}  
	  
	// 使用 lambda 表达式以及函数操作(functional operation)  
	players.forEach((player) -> System.out.print(player + "; "));  
	   

1.2 Java 8 方法引用

通过方法的名称指向另一个方法，方法引用使用：：

