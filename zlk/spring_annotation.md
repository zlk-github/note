## Spring 注解

###1核心容器（Core）
Spring Core 提供bean工厂 控制反转（IOC），利用IOC使配置与代码进行分离，降低耦合。
>基于xml配置元数据;
Spring 2.5引入了基于注释的配置元数据;
从Spring 3开始基于java配置，使用注解，
如：@Configuration, @Bean, @Import，@DependsOn，
@Component, @Controller

1.1@Configuration  [kənˌfɪgəˈreɪʃn] 
>作用：配置spring容器(应用上下文)，相当于把该类作为spring的xml配置文件中的
 </beans/>,用于替换XML中配置beans。

>用法：@Configuration标注在类上(此类为配置类)。
>
>>注：用<context:component-scanbase-package=”XXX”/>扫描该类，最终我们可以在程序里用>@AutoWired或@Resource注解取得用@Bean注解的bean，和用xml先配置bean然后在程序里自动>注入一样。目的是减少xml里配置。
>

	例1.1：
	
		（1）
			
			/**
			 * desc:
			 *
			 * @author zhoulk
			 *         Date:  2018/6/25.
			 */
			public class Annotation {
			   public void Show(){
			       System.out.println("spring学习！");
			   }
			}
		
		（2）配置类，用于替换xml
			import org.springframework.context.annotation.Bean;
			import org.springframework.context.annotation.Configuration;
			import org.springframework.context.annotation.Scope;
			
			/**
			 * desc:
			 *
			 * @author zhoulk
			 *         Date:  2018/6/25.
			 *         配置类，替换xml
			 */
			@Configuration
			public class ConfigurationDemo {
			    // @Bean注解注册bean,同时可以指定初始化和销毁方法
			    // @Bean(name="annotation",initMethod="start",destroyMethod="cleanUp")
			    @Bean
			    @Scope("prototype")
			    public Annotation annotation() {
			        return new Annotation();
			    }
			}
		（3）
			
			import org.springframework.context.annotation.AnnotationConfigApplicationContext;
			import org.springframework.context.ApplicationContext;
			/**
			 * desc:
			 *
			 * @author zhoulk
			 *         Date:  2018/6/25.
			 *
			 *         注：报错
			 */
			
			public class TestConfiguration {
			
			    public static void main(String[] args) {
			
			        // @Configuration注解的spring容器加载方式，用AnnotationConfigApplicationContext替换ClassPathXmlApplicationContext
			        //和使用ApplicationContext.xml加载的效果相同
					// ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
			        ApplicationContext context = new AnnotationConfigApplicationContext(ConfigurationDemo.class);
			        //获取实例c
			        Annotation annotation =(Annotation) context.getBean("annotation");
			        annotation.Show();
			    }
			}


1.2@Bean

>作用：@Bean注解一个方法，使其产生一个Bean，交于spring容器。等效于<bean id="id类名" class="类名"//>
>
>用法：@Bean注解方法（该方法返回类型为对象），配合@Configuration使用
	
	例：配置类，用于替换xml
	
	    import org.springframework.context.annotation.Bean;
	    import org.springframework.context.annotation.Configuration;
	    import org.springframework.context.annotation.Scope;
	
	    /**
	     * desc:
	     *
	     * @author zhoulk
	     *         Date:  2018/6/25.
	     *         配置类，替换xml
	     */
	    @Configuration
	    public class ConfigurationDemo {
	        // @Bean注解注册bean,同时可以指定初始化和销毁方法
	        // @Bean(name="annotation",initMethod="start",destroyMethod="cleanUp")
	        @Bean
	        @Scope("prototype")//singleton：单例，默认值prototype：多例
	        public Annotation annotation() {
	            return new Annotation();
	        }
	    }

1.3@Import 
>作用：@Import是被用来整合所有在@Configuration注解中定义的bean配置
>
>用法：@Import注解类（配置类）


	
	例：import org.springframework.context.annotation.Configuration;
		import org.springframework.context.annotation.Import;
		
		@Configuration
		@Import({JavaConfigA.class,JavaConfigB.class})
		//JavaConfigA为配置类A，JavaConfigB配置类B。实现相同接口
		public class ParentConfig {
		    //Any other bean definitions
		}

1.4 @ConstructorProperties  [kənˈstrʌktə(r)]
>作用：（不明）
>
>用法：注解构造函数

	例：@ConstructorProperties({"x","y"})
	    public NewHello(String x, String y) {
	        this.x = x;
	        this.y = y;
	    }

1.5 @Component [kəmˈpəʊnənt], @Repository [rɪˈpɒzətri] , @Service, @Controller
>作用： @Component泛指组件，当组件不要好归类时，可以使用这个注解进行标注。 （把普通java对象实例化到spring容器中，相当于配置文件中的<bean id="" class=""/>）
>
>注：(@Service用于标注业务层组件
>
>@Repository用于标注数据访问组件，即DAO组件
>
>@Controller用于标注控制层组件，如Struts中的Action)
>
>用法：@Component注解用于类或接口，用法相似与@Service。

	例：@Component("userService") 
	    public class UserServiceImpl implements UserService{ 
	 
	        private UserDao userDao; 
	        @Override 
	        public List<User> getUser() { 
	           return userDao.getUser(); 
	        } 
	        //标注在set方法上。 
	        @Autowired 
	        public void setUserDao(@Qualifier("userDao") UserDao userDao) { 
			//@Qualifier用于接口有多个实现类时，@Qualifier的参数必须是我们标注需要实现的@Service注解的名称。
	           this.userDao = userDao; 
	        } 
	    } 

1.6@ComponentScan
>作用：@ComponentScan会自动扫描包路径下面的所有@Controller、@Service、@Repository、@Component 的类
>
>用法：@ComponentScan注解类（配置类）
>
>属性：value指定扫描的包，includeFilters包含那些过滤，excludeFilters不包含那些过滤，>useDefaultFilters>默认的过滤规则是开启的.如果我们要自定义的话是要关闭的。其中@Filters是一个过滤器的接口。

>@Filters 指过滤规则，FilterType指定过滤的规则（

>FilterType.ANNOTATION：按照注解

>FilterType.ASSIGNABLE_TYPE：按照给定的类型；

>FilterType.ASPECTJ：使用ASPECTJ表达式

>FilterType.REGEX：使用正则指定

>FilterType.CUSTOM：使用自定义规则）

>classes指定过滤的类

	例：package com.guang.config;  
	  
	import org.springframework.context.annotation.Bean;  
	import org.springframework.context.annotation.ComponentScan;  
	import org.springframework.context.annotation.ComponentScan.Filter;  
	import org.springframework.context.annotation.Configuration;  
	import org.springframework.context.annotation.FilterType;  
	import com.guang.entity.Person;  
	  
	@Configuration  
	// @ComponentScan("包路径") 会自动扫描包路径下面的所有@Controller、@Service、@Repository、@Component 的类  
	// includeFilters 指定包含扫描的内容  
	// excludeFilters 指定不包含的内容  
	// @Filter 指定过滤规则，type指定扫描的规则（注解，正则，自定义，ASPECTJ表达式），classes指定的扫描的规则类  
	@ComponentScan(basePackages = {"com.guang"},  
	        includeFilters = @Filter(type = FilterType.ANNOTATION, classes = {Controller.class}),  
	        excludeFilters = @Filter(type = FilterType.ANNOTATION, classes = {Repository.class}),  
	        includeFilters = @Filter(type = FilterType.CUSTOM, classes = {FilterCustom.class}),  
	        useDefaultFilters = false)  
	public class Myconfig {  
	  
	    @Bean("person")  
	    public Person person01() {  
	        return new Person("aiha", 25);  
	    }  
	  
	}  

1.7 @Required（为什么使用，什么场景？）
>作用：@Required注解的set方法必须在xml文件进行配置（赋值），否则会包错BeanInitializationException。
>
>用法：用于注解set方法。


	例：package com.zlk.required;
	
	import org.springframework.beans.factory.annotation.Required;
	import org.springframework.context.ApplicationContext;
	import org.springframework.context.support.ClassPathXmlApplicationContext;
	
	/**
	 * desc:
	 *
	 * @author zhoulk
	 *         Date:  2018/6/26.
	 *         测试@Required注解
	 */
	public class Student {
	    private String name;
	    private String age;
	
	    public String getName() {
	        return name;
	    }
	
	    public void setName(String name) {
	        this.name = name;
	    }
	
	    public String getAge() {
	        return age;
	    }
	
	    @Required
	    public void setAge(String age) {
	        this.age = age;
	    }
	
	    public static void main(String[] args) {
	        ApplicationContext context = new ClassPathXmlApplicationContext("/resources/Beans.xml");
	        Student student = (Student) context.getBean("student");
	        System.out.println("Name : " + student.getName() );
	        System.out.println("Age : " + student.getAge() );
	    }
	}
	
	配置文件Beans.xml：由于age用 @Required进行注解，配置文件中age必须有值。
    （否则报错：Caused by: org.springframework.beans.factory.BeanInitializationException: Property 'age' is required for bean 'student'）

	<?xml version="1.0" encoding="UTF-8"?>
	<beans xmlns="http://www.springframework.org/schema/beans"
	       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	       xmlns:context="http://www.springframework.org/schema/context"
	       xsi:schemaLocation="http://www.springframework.org/schema/beans
	    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
	    http://www.springframework.org/schema/context
	    http://www.springframework.org/schema/context/spring-context-3.0.xsd">
	
	    <context:annotation-config/>
	
	    <!-- Definition for student bean -->
	    <bean id="student" class="com.zlk.required.Student">
	    <!--    <property name="name"  value="Zara" />-->
	        <!-- try without passing age and check the result -->
	         <property name="age"  value="11"/>
	    </bean>
	</beans>

1.8 @Autowired(Angular2中@Inject有类似效果,JAVA注解@Resource)
>作用：@Autowired 注释，它可以对类成员变量、方法及构造函数进行标注，完成自动装配的工作。 通过 @Autowired的使用来消除 set ，get方法。，当无匹配的Bean时会报错。
>
>>注：@Autowired可配合@Qualifier("office")指定注入Bean的名称。@Resource(name = "manImpl")可直接指明实现类。
>>
>>@Resource默认按照名称方式进行bean匹配（装配对象名称），@Autowired默认按照类型方式进行bean匹配
>
>用法：注解对象（常见），构造函数以及方法。
>
>属性：required = false找不到匹配Bean时不报错。
>
>byType：按类型装配，可以根据属性的类型，在容器中寻找根该类型匹配的bean.如果发现多个，那么将会抛出异常。如>果》没有找到，即属性值为null。

>byName：按名称装配，可以根据属性的名称，在容器中寻找根该属性名相同的bean,如果没有找到，即属性值为null。

>Constructor与byType的方式类似，不同之处在于它应用于构造器参数。如果在容器中没有找到与构造器参数类型一致的>bean,那么将会抛出异常。

>Autodetect：通过bean类的自省机制来决定是使用constructor还是byType方式进行自动装配。如果发现默认的构造>器，那么将使用byType方式。

	例：
	@Service  
	public class SequenceServiceImpl implements SequenceService {  
	  
	    @Autowired
	    //@Qualifier("sequenceMapper")
	    private SequenceMapper sequenceMapper;  
	      
	    @Resource(name = "manImpl")//注意是manImpl不是ManImpl，因为使用@Service，容器为我们创建bean时默认类名首字母小写  
	    private Human human;  
	  
	}  

1.9@Order
>作用：@Order控制类的加载顺序。确定注入到array或者list中的顺序（待研究）
>
>用法：注解类，@Order（n）,n越小，越先加载。
	
	例：
	@Component
	@Order(1)    
	public class Order1{  
	    private final int ORDERED = 1;  
	      
	    public Order1(){  
	        System.out.println(this);  
	    }  
	  
	    @Override  
	    public String toString() {  
	        return "Order1 [ORDERED=" + ORDERED + "]";  
	    }  
	      
	}  

1.10 @Priority（@Order效果相似，待研究）

1.11 @DependsOn(控制Bean的加载顺序，未研究明白)
>@DependsOn用于强制初始化其他Bean

1.12@value
>作用：为了简化读取properties文件中的配置值，spring支持@value注解的方式来获取，这种方式大大简化了项目配置，提高业务中的灵活性。
>
>用法：1、 @Value("#{对象.方法（）}") 
>2、@Value("${配置文件配置项名称}")

	例：import org.springframework.stereotype.Service; 
	  
	/** 
	 * 测试Bean 
	 */
	@Service("userService") 
	public class UserService { 
	  
	 public int count() { 
	  return 10; 
	 } 
	   
	 public int max(int size) { 
	  int count = count(); 
	  return count > size ? count : size; 
	 } 
	}
	
	import org.springframework.beans.factory.InitializingBean; 
	import org.springframework.beans.factory.annotation.Value; 
	import org.springframework.stereotype.Component; 
	  
	@Component
	public class AppRunner implements InitializingBean { 
	   
	 /** 
	  * 引用一个配置项 
	  */
	 @Value("${app.port}") 
	 private int port; 
	   
	 /** 
	  * 调用容器的一个bean的方法获取值 
	  */
	 @Value("#{userService.count()}") 
	 private int userCount; 
	   
	 /** 
	  * 调用容器的一个bean的方法，且传入一个配置项的值作为参数 
	  */
	 @Value("#{userService.max(${app.size})}") 
	 private int max; 
	   
	 /** 
	  * 简单的运算 
	  */
	 @Value("#{${app.size} <= '12345'.length() ? ${app.size} : '12345'.length()}") 
	 private int min; 
	   
	 //测试 
	 public void afterPropertiesSet() throws Exception { 
	  System.out.println("port : " + port); 
	  System.out.println("userCount : " + userCount); 
	  System.out.println("max : " + max); 
	  System.out.println("min : " + min); 
	 } 
	}

	

	app.properties：
	app.port=9090
	app.size=3

	
	import org.springframework.context.annotation.AnnotationConfigApplicationContext; 
	import org.springframework.context.annotation.ComponentScan; 
	import org.springframework.context.annotation.PropertySource; 
	  
	@ComponentScan
	@PropertySource("classpath:app.properties") 
	public class App { 
	   
	 public static void main( String[] args) { 
	  AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(App.class); 
	  context.close(); 
	 } 
	}

1.13@Primary
>作用：当一个接口有多个实现类时，且实现类都有类似@Service注解实现。此时如果对接口进行注入实现，将不能确定注入那个实现类，结果将会报错（若只有一个实现类实现了类似@Service的注解，将注入该实现类）。处理办法在需要实现注入的实现类上加@Primary。（效果等同在实现注入用@Autowired与
@Qualifier("sequenceMapper")注解）
>
>用法：加到需要注入的实现类上。

	例：
	public interface S {
	    	String sing(String lyrics);
		}
	
	
	@Component // 加注解，让spring识别
	public class S1 implements  S {
	    	String sing(String s1);
	}
	
	
	@Component // 加注解，让spring识别
	@Primary//指明注入该实现类
	public class S2 implements  S {
	    	String sing(String s2);
	}
	
	@Component
	public class SingerService {
	    @Autowired
	    private S s;//此时注入@Primary注解的实现类。
	}

1.14@Qualifier
>作用：一般配合@Autowired使用，指明需要实现注入的类（接口有多实现时使用）
>
>用法：注解对象，类。@Qualifier（"实现类名称"）
>
>例子见1.8对应的实例。

1.15@Genre
>作用：与@Qualifier相似，但是可以用来注解形参（一个接口需要实现多个实现类注入时，作为辨别）
>
>用法：注解对象，注解形参。@Genre（“实现类名称”）
>

	例：public class MovieRecommender {
	    @Autowired
	    @Genre("Action")
	    private MovieCatalog actionCatalog;
	    private MovieCatalog comedyCatalog;
	
	    @Autowired
	    public void setComedyCatalog(@Genre("Comedy") MovieCatalog comedyCatalog) {
	        this.comedyCatalog = comedyCatalog;
	    }
	}

1.16 @Offline
作用：与@Qualifier相似

	例：
	public class MovieRecommender {
	
	    @Autowired
	    @Offline
	    private MovieCatalog offlineCatalog;
	
	    // ...
	}
	
	xml:
	<bean class="example.SimpleMovieCatalog">
	    <qualifier type="Offline"/>
	    <!-- inject any dependencies required by this bean -->
	</bean>

1.17@MovieQualifier(未明白)

1.18@PostConstruct、@PreDestroy(待整理，效果未明白)

 >被@PostConstruct修饰的方法会在服务器加载Servlet的时候运行，并且只会被服务器调用一次，类似于Serclet的>inti()方法。被@PostConstruct修饰的方法会在构造函数之后，init()方法之前运行。

 >被@PreDestroy修饰的方法会在服务器卸载Servlet的时候运行，并且只会被服务器调用一次，类似于Servlet的>destroy()方法。被@PreDestroy修饰的方法会在destroy()方法之后运行，在Servlet被彻底卸载之前。（详见下面的>程序实践）

1.19 @AliasFor
>作用：定义注解时，定义属性互为别名。
>注：该注解互为别名的属性成对出现，有默认值，使用互为别名的属性时只能用其中的一个属性名。
>用法：注解 注解属性的属性互为别名；

	例：@Documented
	@Inherited
	@Retention(RetentionPolicy.RUNTIME)
	@Target(ElementType.TYPE)
	public @interface ContextConfiguration {
	    @AliasFor("locations")
	    String[] value() default {};
	
	    @AliasFor("value")
	    String[] locations() default {};
	    //...
	}

1.20 @Named

>作用：用于辨别接口多实现时。
>
>用法：作用于形参
	
	例：import javax.inject.Inject;
	import javax.inject.Named;
	
	public class SimpleMovieLister {
	
	    private MovieFinder movieFinder;
	
	    @Inject//注入Bean
	    public void setMovieFinder(@Named("main") MovieFinder movieFinder) {
	        this.movieFinder = movieFinder;
	    }
	}

1.21 @Nullable
>作用：定义参数可以为空。
>用法：注解形参。

	例：public class SimpleMovieLister {
	
	    @Inject
	    public void setMovieFinder(@Nullable MovieFinder movieFinder) {
	        ...
	    }
	}


1.22@Scope
>作用：作用范围。
>
>用法：注解形参。@scope默认是单例模式（singleton），如@scope（"singleton"）
	如果需要设置的话@scope("prototype")

	1.singleton单例模式,
	　　全局有且仅有一个实例

	2.prototype原型模式，
	　　每次获取Bean的时候会有一个新的实例

	3.request
	　　request表示该针对每一次HTTP请求都会产生一个新的bean，同时该bean仅在当前HTTP request内有效，配置实例：
	request、session、global session使用的时候首先要在初始化web的web.xml中做如下配置：
	如果你使用的是Servlet 2.4及以上的web容器，那么你仅需要在web应用的XML声明文件web.xml中增加下述ContextListener即可： 
	<web-app>
	   ...
	  <listener>
	<listener-class>org.springframework.web.context.request.RequestContextListener</listener-class>
	  </listener>
	   ...
	</web-app>

	4.session
	　　session作用域表示该针对每一次HTTP请求都会产生一个新的bean，同时该bean仅在当前HTTP session内有效

	5.global session
	global session作用域类似于标准的HTTP Session作用域，不过它仅仅在基于portlet的web应用中才有意义。Portlet规范定义了全局Session的概念，它被所有构成某个 portlet web应用的各种不同的portlet所共享。在global session作用域中定义的bean被限定于全局portlet Session的生命周期范围内。如果你在web中使用global session作用域来标识bean，那么web会自动当成session类型来使用。


1.23 @Lazy（未测试）

>@Lazy用于指定该Bean是否取消预初始化。主要用于修饰Spring Bean类，用于指定该Bean的预初始化行为，
>使用该Annotation时可以指定一个boolean型的value属性，该属性决定是否要预初始化该Bean
>
>lazy代表延时加载，lazy=false，代表不延时，如果对象A中还有对象B的引用，会在A的xml映射文件中配置b的对象引>用，多对一或一对多，不延时代表查询出对象A的时候，会把B对象也查询出来放到A对象的引用中，A对象中的B对象是有>值的。
>
>lazy=true代表延时，查询A对象时，不会把B对象也查询出来，只会在用到A对象中B对象时才会去查询，默认好像是>false，你可以看看后台的sql语句的变化就明白了，一般需要优化效率的时候会用到
>
>用法：注解类；
	
	例：@Lazy(true)
	@Component
	public class Chinese implements Person{
	   //codes here
	}

1.24@Profile（未测试）
>作用：实际开发中用于替换开发、测试、正式环境。
>
>用法：
	
	例：package com.websystique.spring.configuration;
	 
	import javax.sql.DataSource;
	 
	import org.springframework.context.annotation.Bean;
	import org.springframework.context.annotation.Configuration;
	import org.springframework.context.annotation.Profile;
	import org.springframework.jdbc.datasource.DriverManagerDataSource;
	 
	@Profile("Development")
	@Configuration
	public class DevDatabaseConfig implements DatabaseConfig {
	 
	    @Override
	    @Bean
	    public DataSource createDataSource() {
	        System.out.println("Creating DEV database");
	        DriverManagerDataSource dataSource = new DriverManagerDataSource();
	        /*
	         * Set MySQL specific properties for Development Environment
	         */
	        return dataSource;
	    }
	}
	
	
	<?xml version="1.0" encoding="UTF-8"?>
	<beans xmlns="http://www.springframework.org/schema/beans"
	        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	        xmlns:context="http://www.springframework.org/schema/context"
	        xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
	                            http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd">
	 
	    <context:component-scan base-package="com.websystique.spring"/>
	     
	    <beans profile="Development">
	        <import resource="dev-config-context.xml"/> 
	    </beans>
	 
	    <beans profile="Production">
	        <import resource="prod-config-context.xml"/>
	    </beans>
	 
	</beans>

1.25@Conditional（条件注解）

1.26@PropertySouce
>作用：用于读取properties配置文件
>
>用法：@PropertySource("classpath:config.properties") ，注解与类上。
	
	例：package com.zlk.value;
	import org.springframework.context.annotation.AnnotationConfigApplicationContext;
	import org.springframework.context.annotation.ComponentScan;
	import org.springframework.context.annotation.PropertySource;
	
	@ComponentScan
	@PropertySource("classpath:resources/app.properties")
	public class App {
	
	    public static void main( String[] args) {
	        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(App.class);
	        context.close();
	    }
	}

1.27@EnableLoadTimeWeaving

1.28@EventListener

1.29@Async(用法不明)
>作用@Async标注的异步方法会在独立的现场中运行，调用者不用等其执行完，即可执行其他操作。
>
>>用法：
>>1启动方式：
>
>>基于Java配置的启用方式：
>
>>@Configuration  
>>@EnableAsync  
>>public class SpringAsyncConfig { ... } 
>>
>>基于XML配置文件的启用方式，配置如下：
>
>><task:executor id="myexecutor" pool-size="5"  />  
>><task:annotation-driven executor="myexecutor"/>   
>>
>>2基于@Async无返回值调用

1.30@NumberFormat、@DateTimeFormat
>数字与日期格式注解

1.31@Aspect
>作用：日志管理注解。
>
>用法:注解 日志管理类，需要在配置文件中加入<aop:aspectj-autoproxy/>，进行日志管理的类需要进行配置
	>
	</bean id="myAspect" class="org.xyz.NotVeryUsefulAspect"/>
 		 <!-- configure properties of aspect here as normal --/>
	</bean/>

>配合使用的注解有@Pointcut， @After， @Befor，@AfterReturning、@AfterThrowing、@AfterThrowing、@Around


1.32@EnableAspectJAutoProxy

1.34@Transactional
>作用：事务管理，保证数据一致性。
>用法：只能放在Services实现类的public方法上（放在类上可能影响性能，放接口上可能无效），只有通过action直接调用Services方法时才会回滚。

1.35 @within、@annotation、@target

1.36@args

1.37@Configurable

1.38@EnableSpringConfigured

1.39@EnableLoadTimeWeaving

1.40@NonNull、@NonNullApi、@NonNullFields、@Nullable

1.41@PersistenceContext 、 @PersistenceUnit


@SessionScope