package com.bfuture.app.saas.service;

import java.util.List;

import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.BaseManager;
import com.bfuture.app.basic.util.xml.StringUtil;
/**
 * 入库单查询
 * @author Zhucs
 *
 */
public interface RKDocQueryManager extends BaseManager {
	/**为了打印入库单*/
	public ReturnObject searchRkdDetail(Object[] o);//获得列表
	public ReturnObject getHead(Object[] o);//合计
	public ReturnObject searchIns(String sgcode);//实例中文名
}
