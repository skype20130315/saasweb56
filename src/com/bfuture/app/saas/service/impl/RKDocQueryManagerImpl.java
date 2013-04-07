package com.bfuture.app.saas.service.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.saas.model.report.RKDocQuery;
import com.bfuture.app.saas.service.RKDocQueryManager;
import com.bfuture.app.saas.util.StringUtil;
/**
 * 入库单查询
 * @author Zhucs
 *
 */
public class RKDocQueryManagerImpl extends BaseManagerImpl implements RKDocQueryManager {

	protected final Log log = LogFactory.getLog(RKDocQueryManagerImpl.class);

	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}

	public RKDocQueryManagerImpl() {
		if (this.dao == null) {
			this.dao = (UniversalAppDao) getSpringBean("universalAppDao");
		}
	}
	@Override
	public ReturnObject getResult(Object o) {
		ReturnObject result = new ReturnObject();

		return result;
	}
	public ReturnObject ExecOther(String actionType, Object[] o) {

		ReturnObject result = new ReturnObject();
		// 查询入库单 //参数： 实例编码、门店编码、供应商编码。
		if ("getRKDocHead".equals(actionType)) {
			RKDocQuery rKDocQuery = (RKDocQuery) o[0]; // 查询条件
			try {
				StringBuffer Sql=new StringBuffer("select h.BIHORDERNO,h.BIHBILLNO,h.BIHSUPID,sup.supname,h.BIHSHMFID,h.BIHJHRQ,cast(h.temp5 as varchar2(20))temp5,to_char(h.BIHSHTIME,'yyyy-MM-dd') as BIHSHTIME,h.BIHMEMO," +
							"(select sum(d.bidsl) from yw_binstrdetail d where d.BIDBILLNO=h.BIHBILLNO and d.bidsgcode=h.bihsgcode  and h.bihshmfid=d.bidshmfid) as bidsl," +
							"(select sum(d.BIDHSJJJE) from yw_binstrdetail d where d.BIDBILLNO=h.BIHBILLNO and d.bidsgcode=h.bihsgcode  and h.bihshmfid=d.bidshmfid) as bidhsjjje ," +
							"(select distinct(s.shpname) from inf_shop s where s.shpcode=h.BIHSHMFID and s.sgcode=h.bihsgcode ) as shopname " +
							"from yw_binstrhead h ,inf_supinfo sup  where  sup.supid=h.bihsupid  and sup.supsgcode=h.bihsgcode   ");

				StringBuffer sumsql=new StringBuffer("select cast('合计' as varchar2(30)) BIHBILLNO,sum(d.bidsl) as BIDSL,sum(d.BIDHSJJJE) as BIDHSJJJE from yw_binstrdetail d ,yw_binstrhead h where  h.bihbillno=d.bidbillno and h.bihsgcode=d.bidsgcode  ");
				StringBuffer count=new StringBuffer("select count(h.bihbillno) from yw_binstrhead h where 1=1 ");
				
				/*查询条件*/
				StringBuffer whereStr = new StringBuffer(" ");
				if(StringUtil.isNotEmpty(rKDocQuery.getSgcode()))//实例编码
				{
					whereStr.append(" and h.BIHSGCODE='"+rKDocQuery.getSgcode()+"' ");
				}
				if(StringUtil.isNotEmpty(rKDocQuery.getShopcode()))//门店编码
				{
					whereStr.append(" and h.BIHSHMFID='"+rKDocQuery.getShopcode()+"' ");
				}
				if(StringUtil.isNotEmpty(rKDocQuery.getSupcode()))//供应商编码BIHBILLNO
				{
					whereStr.append(" and h.BIHSUPID='"+rKDocQuery.getSupcode()+"' ");
				}
				if(StringUtil.isNotEmpty(rKDocQuery.getBILLNO()))//入库单号//查询单头
				{
					whereStr.append(" and h.BIHBILLNO like '%"+rKDocQuery.getBILLNO()+"%'");
				}
				if(StringUtil.isNotEmpty(rKDocQuery.getTemp5()))//查询合同号
				{
					whereStr.append(" and h.temp5='"+rKDocQuery.getTemp5()+"' ");
				}
				if (StringUtil.isNotEmpty(rKDocQuery.getStartDate())) {
					whereStr.append(" and to_char(h.BIHSHTIME,'yyyy-mm-dd') >= '").append(
							rKDocQuery.getStartDate()+"'");
				}
				if (StringUtil.isNotEmpty(rKDocQuery.getEndDate())) {
					whereStr.append(" and to_char(h.BIHSHTIME,'yyyy-mm-dd') <= '").append(
							rKDocQuery.getEndDate()+"'");
				}
				
				/*总条数，合计查询*/
				sumsql.append(whereStr);
				List lstSumResult = dao.executeSql(sumsql.toString());
				count.append(whereStr);
				List resultNum = dao.executeSqlCount(count.toString());
				int num=Integer.parseInt(resultNum.get(0).toString());//总条数
				
				if( rKDocQuery.getOrder() != null && rKDocQuery.getSort() != null ){
					whereStr.append( " order by " ).append( rKDocQuery.getSort() ).append( " " ).append( rKDocQuery.getOrder() );
				}
				//分页查询
				Sql.append(whereStr);
				int limit=rKDocQuery.getRows();
				int start=(rKDocQuery.getPage()-1)*rKDocQuery.getRows();
				List lstResult = dao.executeSql(Sql.toString(),start,limit);
				if (lstResult != null) {
					result.setReturnCode(Constants.SUCCESS_FLAG);
					result.setRows(lstResult);
					result.setFooter(lstSumResult);
					result.setTotal(num);
				}
			} catch (Exception ex) {
				log.error("RKDocQueryManagerImpl.getRKDocHead() error :" + ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
			
		}else if ("getRKDocDetail".equals(actionType)) { // 入库单明细
			result = searchRkdDetail(o);
			
		}else if ("getHead".equals(actionType)) {
			result = getHead(o);
		}
	return result;
	}
	
	public ReturnObject searchRkdDetail(Object[] o){
		RKDocQuery rKDocQuery = (RKDocQuery) o[0]; 
		ReturnObject result = new ReturnObject();
		try {
			StringBuffer Sql = new StringBuffer(
						"select distinct(d.BIDGDID) as BIDGDID,h.BIHBILLNO as BIHBILLNO,h.BIHORDERNO as BIHORDERNO,h.BIHJHRQ as BIHJHRQ,h.BIHSUPID as BIHSUPID,sup.supname as supname,s.shpname as shopname,h.BIHSHMFID as BIHSHMFID ,h.BIHMEMO as BIHMEMO,g.gdname as gdname,g.gdspec as gdspec,g.gdunit as gdunit ,G.GDBARCODE BARCODE,d.BIDSL as BIDSL,d.BIDHSJJ as BIDHSJJ," +
						"d.BIDHSJJJE  as BIDHSJJJE from YW_BINSTRDETAIL d,YW_BINSTRHEAD h,inf_goods g,inf_shop s,inf_supinfo sup " +
						" where d.bidbillno=h.bihbillno and d.bidsgcode=h.bihsgcode  and d.bidshmfid=h.bihshmfid and g.gdid=d.bidgdid and g.gdsgcode=h.bihsgcode and s.shpcode=d.bidshmfid and s.sgcode=h.bihsgcode and sup.supid=h.bihsupid  and sup.supsgcode=h.bihsgcode ");
			StringBuffer count=new StringBuffer("select count(*) from YW_BINSTRDETAIL d,YW_BINSTRHEAD h  where d.bidbillno=h.bihbillno and d.bidsgcode=h.bihsgcode  and d.bidshmfid=h.bihshmfid ");
			StringBuffer sumsql = new StringBuffer("select cast('合计' as varchar2(30)) BIDGDID,sum(d.bidsl) as BIDSL,sum(d.BIDHSJJ) as BIDHSJJ ,sum(d.BIDHSJJJE) as BIDHSJJJE from yw_binstrdetail d ,yw_binstrhead h where  h.bihbillno=d.bidbillno and h.bihsgcode=d.bidsgcode and d.bidshmfid=h.bihshmfid ");

			/*查询条件*/
			StringBuffer whereStr = new StringBuffer();
			if(StringUtil.isNotEmpty(rKDocQuery.getSgcode()))//实例编码
			{
				whereStr.append(" and h.BIHSGCODE='"+rKDocQuery.getSgcode()+"' ");
			}
			if(StringUtil.isNotEmpty(rKDocQuery.getBILLNO()))//入库单号
			{
				whereStr.append(" and h.bihbillno='"+rKDocQuery.getBILLNO()+"' ");
			}
			if(StringUtil.isNotEmpty(rKDocQuery.getShopcode())){//门店编号------+++7-5
				whereStr.append(" and h.bihshmfid='"+rKDocQuery.getShopcode()+"' ");
			}
			
			/*总条数，合计查询*/
			count.append(whereStr);
			List  resultNum=dao.executeSqlCount(count.toString());
			int num=Integer.parseInt(resultNum.get(0).toString());
			sumsql.append(whereStr);
			List lstSumResult = dao.executeSql(sumsql.toString());
			
			/*分页查询*/
			if( rKDocQuery.getOrder() != null && rKDocQuery.getSort() != null ){
				whereStr.append( " order by " ).append( rKDocQuery.getSort() ).append( " " ).append( rKDocQuery.getOrder() );
			}

			Sql.append(whereStr);
			int limit=rKDocQuery.getRows();
			int start=(rKDocQuery.getPage()-1)*rKDocQuery.getRows();
			List lstResult = dao.executeSql(Sql.toString(),start,limit);
			if (lstResult != null) {
				result.setReturnCode(Constants.SUCCESS_FLAG);
				result.setRows(lstResult);
				result.setTotal(num);
				result.setFooter(lstSumResult);
			}
			
		} catch (Exception ex) {
			log.error("RKDocQueryManagerImpl.getRKDocDetail() error :" + ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
		return result;
	}

	

	
	public ReturnObject getHead(Object[] o) {
		RKDocQuery rKDocQuery = (RKDocQuery) o[0]; // 查询条件
		ReturnObject result = new ReturnObject();
		try {
			StringBuffer Sql=new StringBuffer("select h.BIHORDERNO,h.BIHBILLNO,h.BIHSUPID,h.BIHSHMFID,h.BIHJHRQ,to_char(h.BIHSHTIME,'yyyy-MM-dd') as BIHSHTIME,h.BIHMEMO," +
					"(select distinct(s.shpname) from inf_shop s where s.shpcode=h.BIHSHMFID and s.sgcode=h.bihsgcode ) as shopname ," +
					"(select distinct(sup.supname) from inf_supinfo sup where sup.supid=h.BIHSUPID and sup.supsgcode=h.bihsgcode ) as supname " +
					"from yw_binstrhead h where  '1'='1'  ");
			if(StringUtil.isNotEmpty(rKDocQuery.getSgcode()))//实例编码
			{
				Sql.append(" and h.BIHSGCODE='"+rKDocQuery.getSgcode()+"' ");
			}
			if(StringUtil.isNotEmpty(rKDocQuery.getShopcode()))//门店编码
			{
				Sql.append(" and h.BIHSHMFID='"+rKDocQuery.getShopcode()+"' ");
			}
			if(StringUtil.isNotEmpty(rKDocQuery.getSupcode()))//供应商编码BIHBILLNO
			{
				Sql.append(" and h.BIHSUPID='"+rKDocQuery.getSupcode()+"' ");
			}
			if(StringUtil.isNotEmpty(rKDocQuery.getBILLNO()))//入库单号//查询单头
			{
				Sql.append(" and h.BIHBILLNO='"+rKDocQuery.getBILLNO()+"' ");
			}
			log.info("/////////"+Sql);
				List lstResult = dao.executeSql(Sql.toString());
				log.info("////RKDocQueryManagerImpl.getHead()"+Sql.toString());
				if (lstResult != null) {
					result.setReturnCode(Constants.SUCCESS_FLAG);
					result.setRows(lstResult);
				}
			
		} catch (Exception ex) {
			log.error("RKDocQueryManagerImpl.getHead() error :" + ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
		return result;
	}
	
	public ReturnObject searchIns(String sgcode)
    {
        ReturnObject result = new ReturnObject();
        try
        {
            StringBuffer sql = new StringBuffer("SELECT OI_CN FROM ORG_INS WHERE 1=1 ");
            if(StringUtil.isNotEmpty(sgcode))
                sql.append(" AND OI_C='").append(sgcode).append("'");
            List lstResult = dao.executeSql(sql.toString());
            result.setRows(lstResult);
        }
        catch(Exception ex)
        {
            log.error((new StringBuilder("YwBorderheadManagerImpl.searchIns() error:")).append(ex.getMessage()).toString());
            result.setReturnCode("0");
            result.setReturnInfo(ex.getMessage());
        }
        return result;
    }
}
