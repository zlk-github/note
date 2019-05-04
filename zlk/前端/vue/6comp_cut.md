## 6 动态切换组件

component标签is属性完成事件的动态绑定，keep-alive保持事件切换回去时原数据。

	<!DOCTYPE html>
	<html>
		<head>
			<meta charset="utf-8" />
			<title>组件动态切换</title>
			<script src="https://cdn.jsdelivr.net/npm/vue@2.6.10/dist/vue.js"></script>
		</head>
		<body>
			<div id="app">
				<!--加事件切换组件-->
				<button @click="changeCopm(1)">选项1</button>
				<button @click="changeCopm(2)">选项2</button>
				<button @click="changeCopm(3)">选项3</button>
				
				<!--通过keep-alive标签保留组件状态值，即原先输入切换回去时保留-->
				<keep-alive>
				<!--component 的is属性完成事件动态绑定-->
				<component v-bind:is="nowHeader"></component>
				</keep-alive>
			</div>
		</body>
		<script type="text/javascript">
			new Vue({
				el:"#app",
				data:{
					nowHeader:'head-1'
				},
				//自定义组件
				components:{
					'head-1':{template:'<div>组件1<input/></div>'},
					'head-2':{template:'<div>组件2<input/></div>'},
					'head-3':{template:'<div>组件3<input/></div>'},
					
				},
				methods:{
					//切换组件
					changeCopm:function(index){
						this.nowHeader='head-'+index
					}
				}
			})
		</script>
			
	</html>


### 参考

	官网地址： https://cn.vuejs.org/

	Ant Design of Vue地址：  https://vue.ant.design/docs/vue/introduce-cn/