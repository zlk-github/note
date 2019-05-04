## 3 Class 与 Style 绑定

样式的切换与内联样式的使用。

	<!DOCTYPE html>
	<html>
		<head>
			<meta charset="utf-8" />
			<title>Class与Style绑定</title>
			<script src="https://cdn.jsdelivr.net/npm/vue@2.6.10/dist/vue.js"></script>
			<style>
				.active{
					color: green;
				}
				.error{
					color:red;
				}
			</style>
		</head>
		<body>
			<div id="app">
				<!--isActive为true，显示active对应的class样式,属于简写的特殊形式,一般比较少用-->
				<p v-bind:class="{active:isActive}">seen为true可见。</p>
				
				<!--支持三目运算,不能加大括号-->
				<p v-bind:class="isActive?active:error">seen为true可见。</p>
				
				<!--支持数组，会被最后一个样式覆盖-->
				<p v-bind:class="item">seen为true可见。</p>
				
				<!--内联样式-->
				<p v-bind:style="activeColor">seen为true可见。</p>
				
			</div>
		</body>
		<script type="text/javascript">
			var app = new Vue({
				el:'#app',
				data:{
					isActive:true,
					active:'active',
					error:'error',
					item:['active','error'],
					activeColor: {
						color:'red',
						fontSize: '30px'
					}
				}
			})
		</script>
			
	</html>

注：v-bind可以省略。vue里面定义的元素需要出现在data中才会生效。

### 参考

	官网地址： https://cn.vuejs.org/

	Ant Design of Vue地址：  https://vue.ant.design/docs/vue/introduce-cn/