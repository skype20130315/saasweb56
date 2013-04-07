package com.bfuture.app.saas.service;

import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.BaseManager;
/**
 * 退厂单查询
 * @author Zhucs
 *
 */
public interface TCDocQueryManager extends BaseManager {
	/**为了打印退厂单*/
	public ReturnObject getTCDocDetail(Object[] o);//获得列表
	public ReturnObject getHead(Object[] o);//合计
	public ReturnObject searchIns(String sgcode);//实例中文名
}
