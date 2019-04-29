	@Transactional
	// @Transactional只能使用与public,在同一个类中调用@Transactional标记的方法，@Transactional标记方法事务部回滚
	// @Transactional(propagation = Propagation.REQUIRED) 被调用时，
    //@Transactional(rollbackFor=Exception.class)
	public Integer addInfoList(PortInfo portInfo, List<Object[]> excelResult, SysUser user)
			throws PromptException, Exception {
		Integer tempId = null;
		try {
			// 接口信息入库
			mapper.save(portInfo);
			// 获取接口id
			//tempId = mapper.queryPortInfoByName(portInfo.getPort_name());
			tempId = queryPortId(portInfo);
			// 标记当前读取请求报文
			boolean flag = true;
			// 请求报文集合
			ArrayList<Object[]> reqMessage = new ArrayList<>();
			// 应答报文集合
			ArrayList<Object[]> resMessage = new ArrayList<>();
			// 遍历每行
			// 遍历行，前4行已经获取，第5行是请求报文，第6行是表头，当前从第7行（下标6）开始，（即请求报文正文行开始）
			for (int i = 6; i < excelResult.size(); i++) {
				//当前已为应答报文
				if (Constants.RES_MESSAGE.equals(excelResult.get(i)[0].toString())||"理解应答报文".equals(excelResult.get(i)[0].toString())) {
					flag = false;
					++i;// 需要跳过表头与应答报文行
					continue;
				}

				if (flag) {
					reqMessage.add(excelResult.get(i));
				} else {
					resMessage.add(excelResult.get(i));
				}
			}
            
			if(Constants.XML.equals(portInfo.getTemp_type())){
				// 入库前序号,元素名称验证
				numXmlVerification(reqMessage, ".");
				numXmlVerification(resMessage, ".");
				// 删除接口信息id关联的请求报文
				mapper.deleteRequest(tempId);
				// 入库请求报文
				storageXml(reqMessage, 0, ".", tempId, "req", user);
				// 删除接口信息id关联的应答报文
				mapper.deleteResponse(tempId);
				// 入库应答报文
				storageXml(resMessage, 0, ".", tempId, "res", user);
			}else{
				//json
				for (Object[] mes : reqMessage) {
					if (mes[0] != null && !StringUtil.isEmpty(mes[0].toString())) {
						String name = mes[0].toString().toLowerCase();
						if (name.startsWith("root/") || name.equals("root")) {
							String str = mes[0].toString().substring(4);
							// 统一root节点大小写
							mes[0] = "root" + str;
						}
					}
				}
				
				for (Object[] mes : resMessage) {
					if (mes[0] != null && !StringUtil.isEmpty(mes[0].toString())) {
						String name = mes[0].toString().toLowerCase();
						if (name.startsWith("root/") || name.equals("root")) {
							String str = mes[0].toString().substring(4);
							// 统一root节点大小写
							mes[0] = "root" + str;
						}
					}
				}
		        
				// 入库前json字段内容校验
				jsonMessageVerification(reqMessage, "root");
				jsonMessageVerification(resMessage, "root");
				// req-请求报文，res-应答报文
				
				mapper.deleteRequest(tempId);
				// 入库请求报文
				if(reqMessage!=null&&reqMessage.size()>0){
					// 报文入库
					storageJson(reqMessage, 0, "root", tempId, "req", user);
				}
				// 删除接口信息id关联的应答报文
				mapper.deleteResponse(tempId);
				// 入库应答报文
				if(resMessage!=null&&resMessage.size()>0){
					// 报文入库
					storageJson(resMessage, 0, "root", tempId, "res", user);
				}
			}

		} catch (PromptException ex) {
			// 校验不通过
			// 1.方法上@Transactional(rollbackFor=Exception.class)

			// @Transactional 默认捕获RuntimeException() ，能实现2 or 3
			// 2.throw new RuntimeException(); 会回滚
			// 3.TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			// //手动回滚
			throw ex;
		} catch (Exception ex) {
			// 校验不通过
			// TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			throw ex;
		}
		return tempId;
	}