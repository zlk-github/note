## 4 事件与双向数据绑定

事件v-on与双向数据绑定v-model

	<!DOCTYPE html>
	<html>
		<head>
			<meta charset="utf-8" />
			<title>事件与双向数据绑定</title>
			<script src="https://cdn.jsdelivr.net/npm/vue@2.6.10/dist/vue.js"></script>
		</head>
		<body>
			<div id="app">
				<!--massage加一，并将数据绑定到P标签-->
				<p>点击次数：{{massage}}</p>
				<button v-on:click="massage+=1">加一</button>
				
				<!--双向数据绑定-->
				<p>{{mess}}</p>
				<input type="text" v-model:value="mess"></input>
				<button v-on:click="reverse">反转</button>
				
				<!--greet方法-->
				<p v-on:click="greet">Green</p>
				
				<!--内联 JavaScript 语句中调用方法-->
				 <button v-on:click="say('hi')">Say hi</button>
				 
				 <button @click="warn('Form cannot be submitted yet.', $event)">
				    Submit
				 </button>
				 
			</div>
		</body>
		<script type="text/javascript">
			//js中可以app.greet()调用方法.
			var app = new Vue({
				el:'#app',
				data:{
					massage:0,
					mess:'hello word!',
					name:'vue.js'
				},
				methods:{
					greet:function(event){
						// `this` 在方法里指向当前 Vue 实例
						alert('Hello ' + this.name + '!')
						 // `event` 是原生 DOM 事件
					   if (event) {
							alert(event.target.tagName)
					    }
					},
					say:function(message){
						alert(message);
					},
					 warn: function (message, event) {
						// 现在我们可以访问原生事件对象
						if (event) event.preventDefault()
						alert(message)
				  },
				  reverse:function(){
					 this.mess=this.mess.split('').reverse().join('');
				  }
				},
			})
		</script>
			
	</html>


### 参考

	官网地址： https://cn.vuejs.org/

	Ant Design of Vue地址：  https://vue.ant.design/docs/vue/introduce-cn/