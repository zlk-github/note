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
>用法：@Import注解类

例：
	
	import org.springframework.context.annotation.Configuration;
	import org.springframework.context.annotation.Import;
	
	@Configuration
	@Import({JavaConfigA.class,JavaConfigB.class})
	//JavaConfigA为配置类A，JavaConfigB配置类B。实现相同接口
	public class ParentConfig {
	    //Any other bean definitions
	}

1.4 