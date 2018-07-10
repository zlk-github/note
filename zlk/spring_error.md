##   spring项目报错整理

注：由于个人水平原因，整理可能不完整或者遗漏。欢迎大家指正。

#### 1.1spring jar包版本不统一

>报错：java.lang.NoSuchMethodError:org.springframework.core.annotation.AnnotatedElementUtils.findMergedAnn

>解决办法：org.springframework相关的包版本必须统一


#### 1.2 配置类或者配置文件加载出错

>报错：Exception in thread "main" org.springframework.beans.factory.NoSuchBeanDefinitionException: No bean named 'annotation' available

>原因：未进行Bean配置

>解决办法：必须有bean的相关配置，否则不能注入bean。

	例：<?xml version="1.0" encoding="UTF-8"?>
	
	<beans xmlns="http://www.springframework.org/schema/beans"
	       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	       xmlns:context="http://www.springframework.org/schema/context"
	       xsi:schemaLocation="http://www.springframework.org/schema/beans
	    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
	    http://www.springframework.org/schema/context
	    http://www.springframework.org/schema/context/spring-context-3.0.xsd">
	
	    <!-- Definition for student bean -->
	    <context:component-scan base-package="com.zlk.primary" />
	    
	    <bean id="annotation" class="com.zlk.Annotation">
	    </bean>
	
	</beans>