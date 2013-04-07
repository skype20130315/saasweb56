package com.bfuture.app.saas.service.impl;
import java.math.BigDecimal;
import java.util.Map;
import java.math.BigDecimal;
import java.util.Map;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.service.SaleSummary;
import com.bfuture.app.saas.model.newProductApplyBean;
import com.bfuture.app.saas.model.report.SaleReport;
import com.bfuture.app.saas.model.report.Stock;


public class SaleSummaryImpl extends BaseManagerImpl implements SaleSummary {

	protected final Log log = LogFactory.getLog(SaleSummaryImpl.class);

	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}

	public SaleSummaryImpl() {
		if (this.dao == null) {
			this.dao = (UniversalAppDao) getSpringBean("universalAppDao");
		}
	}

	public ReturnObject ExecOther(String actionType, Object[] o) {

		ReturnObject result = new ReturnObject();
		if("getSaleSum".equals(actionType)){
			SaleReport saleReport = (SaleReport) o[0]; // 查询条件
			
			
			String supcode = saleReport.getSupcode();//供应商
			String startDate = saleReport.getStartDate();//开始时间
			String endDate = saleReport.getEndDate();//结束时间
			String gdbarcode = saleReport.getGdbarcode();//商品条码
			String gsgdname = saleReport.getGsgdname();//商品名称
			String temp5 = saleReport.getTemp5();//合同编码
			String gssgcode = saleReport.getGssgcode();//门店
			String goodssaleTable="YW_GOODSSALE"+gssgcode;
			try {
				StringBuffer sumSql_sum = new StringBuffer("SELECT CAST('合计' AS VARCHAR(32)) SHPCODE,ROUND(SUM(S.GSXSSL), 2) GSXSSL,ROUND(SUM(S.GSHSJJJE), 2) GSHSJJJE,ROUND(SUM(S.GSXSSR), 2) GSXSJE FROM "+goodssaleTable+" S left join INF_GOODS G on S.GSGDID = G.GDID and S.GSSGCODE = G.GDSGCODE WHERE 1 = 1");
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql_sum.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getSupcode())) {
					log.debug("saleReport.getSupcode(): "
							+ saleReport.getSupcode());
					sumSql_sum.append(" and S.GSSUPID = '").append(
							saleReport.getSupcode()).append("'");
				}
				
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sumSql_sum.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log
							.debug("saleReport.getEndDate(): "
									+ saleReport.getEndDate());
					sumSql_sum.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(gdbarcode)) {
					sumSql_sum.append(" and G.GDBARCODE = '").append(saleReport.getGdbarcode()).append("'");
				}
				if (!StringUtil.isBlank(gsgdname)) {
					sumSql_sum.append(" and G.GDNAME like '%").append(saleReport.getGsgdname()).append("%'");
				}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					log.debug("saleReport.getGsmfid(): "
							+ saleReport.getGsmfid());
					sumSql_sum.append(" and S.GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if(saleReport.getGssgcode().equals("3007")){
				 if (!StringUtil.isBlank(temp5)) {
					sumSql_sum.append(" and S.TEMP5 = '").append(saleReport.getTemp5()).append("'");
				 }
				}
				System.out.println("sumSql_sum: "+sumSql_sum);
				log.info("saleShopSumSql: " + sumSql_sum);
				List lstSumResult_sum = dao.executeSql(sumSql_sum.toString());
				log.debug("shpsum:" + lstSumResult_sum);
				
				if (lstSumResult_sum != null && lstSumResult_sum.size() > 0) {
					StringBuffer sumSql = new StringBuffer("select S.GSSUPID, D.SUPNAME, G.GDID, G.GDBARCODE, G.GDNAME, G.GDPPNAME, G.GDSPEC, G.GDUNIT, ROUND(SUM(S.GSXSSL),2) GSXSSL,ROUND(SUM(S.GSHSJJJE),2) GSHSJJJE, ROUND(SUM(S.GSXSSR),2) GSXSJE, S.TEMP3, SUM(S.TEMP3) XSSR,S.TEMP5 from "+goodssaleTable+" S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE = D.SUPSGCODE AND S.GSSUPID = D.SUPID left join INF_GOODS G on S.GSGDID = G.GDID and S.GSSGCODE = G.GDSGCODE where 1 = 1 and S.GSXSSL != 0");
					
					if (!StringUtil.isBlank(startDate)) {
						sumSql.append(" and S.GSRQ >= to_date('").append(saleReport.getStartDate()).append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(endDate)) {
						sumSql.append(" and S.GSRQ <= to_date('").append(saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(gssgcode)) {
						sumSql.append(" and S.GSSGCODE = '").append(saleReport.getGssgcode()).append("'");
					}
					if (!StringUtil.isBlank(supcode)) {
						sumSql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
					}
					if (!StringUtil.isBlank(gdbarcode)) {
						sumSql.append(" and G.GDBARCODE = '").append(saleReport.getGdbarcode()).append("'");
					}
					if (!StringUtil.isBlank(gsgdname)) {
						sumSql.append(" and G.GDNAME like '%").append(saleReport.getGsgdname()).append("%'");
					}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						sumSql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					}
					if(saleReport.getGssgcode().equals("3007")){
						 if (!StringUtil.isBlank(temp5)) {
							 sumSql.append(" and S.TEMP5 = '").append(saleReport.getTemp5()).append("'");
						 }
					}
					sumSql.append(" group by S.GSSUPID,S.TEMP3,D.SUPNAME,G.GDID,G.GDBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT,S.TEMP5 ");
					
					log.info("saleShopSumSql: " + sumSql);
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1)
							* saleReport.getRows();
					log.debug("start: " + start);
					
					System.out.println("sumSql: "+sumSql);					
					List lstSumResult = dao.executeSql(sumSql.toString(), start, limit);
					if (lstSumResult != null) {
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setRows(lstSumResult);
						result.setTotal(dao.executeSql(sumSql.toString()).size());
						 result.setFooter(lstSumResult_sum);
					}
					
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getResult() error :" + ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
			
		}else if ("getShopSaleDetail".equals(actionType)) {
			SaleReport saleReport = (SaleReport) o[0]; 
			String gssgcode = saleReport.getGssgcode();//门店
			String goodssaleTable="YW_GOODSSALE"+gssgcode;
			try {
				boolean flag=saleReport.getGssgcode().equals("3009");
				boolean flag_3010=saleReport.getGssgcode().equals("3010");
				StringBuffer sumSql = null;
                if(flag){
    				 sumSql = new StringBuffer(
    				"select cast('合计' as varchar2(32)) GSRQ,SUM(GSXSSL) GSXSSL,round(SUM(GSXSJE),2) GSXSJE,round(SUM(S.GSHSJJJE),2) GSHSJJJE,SUM(S.GSXSSL*S.TEMP3) XSSR FROM YW_GOODSSALE S left join INF_GOODS_JM G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE  and G.GDSUPID=S.GSSUPID AND G.GDMFID=S.GSMFID  where 1 = 1 ");
                }else if(flag_3010){
                	sumSql = new StringBuffer(
    				"select cast('合计' as varchar2(32)) GSRQ,SUM(GSXSSL) GSXSSL,round(SUM(GSXSSR),2) GSXSJE,round(SUM(S.GSHSJJJE),2) GSHSJJJE,SUM(S.GSXSSL*S.TEMP3) XSSR FROM YW_GOODSSALE_M S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1 ");
                }else{
                	sumSql = new StringBuffer(
    				"select cast('合计' as varchar2(32)) GSRQ,SUM(GSXSSL) GSXSSL,round(SUM(GSXSJE),2) GSXSJE,round(SUM(S.GSHSJJJE),2) GSHSJJJE,round(SUM(S.GSXSSR),2) XSSR2,SUM(S.GSXSSL*S.TEMP3) XSSR "+goodssaleTable+" S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1 ");
                }
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				if("3006".equals(saleReport.getGssgcode())){
					if ("S".equals(saleReport.getUserType().toString())) {
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							sumSql.append(" and S.GSSUPID = '").append(
									saleReport.getSupcode()).append("'");
						}
					}
				}else {
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						sumSql.append(" and S.GSSUPID = '").append(
								saleReport.getSupcode()).append("'");
					}
				}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					log.debug("saleReport.getGsmfid(): "
							+ saleReport.getGsmfid());
					sumSql.append(" and S.GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sumSql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate())
							.append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("saleReport.getEndDate(): "
							+ saleReport.getEndDate());
					sumSql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}

				log.info(sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());

				if (lstSumResult != null && lstSumResult.size() > 0) {
					StringBuffer countSql = null;
                     if(flag_3010){
                    	 countSql = new StringBuffer("select count(*) from (select S.GSRQ from YW_GOODSSALE_M S where 1=1");
                     }else if("3006".equals(saleReport.getGssgcode().toString())){
                    	 countSql = new StringBuffer("select count(*) from (select to_char(S.GSRQ,'yyyy-MM-dd') from YW_GOODSSALE S where 1=1");
                     }else{
                    	 countSql = new StringBuffer("select count(*) from (select S.GSRQ from "+goodssaleTable+" S where 1=1");
                     }
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if("3006".equals(saleReport.getGssgcode())){
						if ("S".equals(saleReport.getUserType().toString())) {
							if (!StringUtil.isBlank(saleReport.getSupcode())) {
								log.debug("saleReport.getSupcode(): "
										+ saleReport.getSupcode());
								countSql.append(" and S.GSSUPID = '").append(
										saleReport.getSupcode()).append("'");
							}
						}
					}else {
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							countSql.append(" and S.GSSUPID = '").append(
									saleReport.getSupcode()).append("'");
						}
					}
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						countSql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate()).append(
								"','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						countSql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append(
								"','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						countSql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					}
					if("3006".equals(saleReport.getGssgcode().toString())){
						countSql.append(" GROUP BY to_char(S.GSRQ,'yyyy-MM-dd')) COUNT");
					}else{
						countSql.append(" GROUP BY S.GSRQ) COUNT");
					}

					log.info(countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log
							.debug("SaleSummaryImpl.getShopSaleDetail() lstResult : "
									+ lstResult);

					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getShopSaleDetail() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}
					StringBuffer sql = null;
				    if(flag_3010){
				    	sql = new StringBuffer(
						"SELECT to_char(S.GSRQ,'yyyy-MM-dd') as GSRQ,S.GSSUPID,D.SUPNAME,SUM(S.GSXSSL) AS GSXSSL,round(SUM(S.GSXSSR),2) GSXSJE,round(SUM(S.GSHSJJJE),2) AS GSHSJJJE,SUM(S.GSXSSL*S.TEMP2) AS GSXSSR FROM YW_GOODSSALE_M S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID WHERE 1=1 and S.GSXSSL != 0");
				    }else if("3012".equals(saleReport.getGssgcode())){
				    	sql = new StringBuffer(
						"SELECT to_char(S.GSRQ,'yyyy-MM-dd') as GSRQ,S.GSSUPID,D.SUPNAME,SUM(S.GSXSSL) AS GSXSSL,round(SUM(S.GSXSJE),2) GSXSJE,round(SUM(S.GSHSJJJE),2) AS GSHSJJJE,SUM(S.GSXSSL*S.TEMP2) AS GSXSSR FROM YW_GOODSSALE S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID WHERE 1=1 and S.GSXSSL != 0");
				     }else if ("3006".equals(saleReport.getGssgcode().toString())) {
				    	sql = new StringBuffer("SELECT to_char(S.GSRQ,'yyyy-MM-dd') as GSRQ,SUM(S.GSXSSL) AS GSXSSL,round(SUM(S.GSXSJE),2) GSXSJE,round(SUM(S.GSHSJJJE),2) AS GSHSJJJE,SUM(S.GSXSSL*S.TEMP2) AS GSXSSR FROM YW_GOODSSALE S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID WHERE 1=1");
				    }else{
				    	sql = new StringBuffer(
						"SELECT to_char(S.GSRQ,'yyyy-MM-dd') as GSRQ,S.GSSUPID,D.SUPNAME,SUM(S.GSXSSL) AS GSXSSL,round(SUM(S.GSXSJE),2) GSXSJE,round(SUM(S.GSHSJJJE),2) AS GSHSJJJE,round(SUM(S.GSXSSR),2) AS XSSR2,SUM(S.GSXSSL*S.TEMP2) AS GSXSSR FROM "+goodssaleTable+" S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID WHERE 1=1");
				    }
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1)
							* saleReport.getRows();
					log.debug("start: " + start);

					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if("3006".equals(saleReport.getGssgcode())){
						if ("S".equals(saleReport.getUserType().toString())) {
							if (!StringUtil.isBlank(saleReport.getSupcode())) {
								log.debug("saleReport.getSupcode(): "
										+ saleReport.getSupcode());
								sql.append(" and S.GSSUPID = '").append(
										saleReport.getSupcode()).append("'");
							}
						}
					}else {
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							sql.append(" and S.GSSUPID = '").append(
									saleReport.getSupcode()).append("'");
						}
					}
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						sql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate()).append(
								"','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						sql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append(
								"','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						sql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					}
					if("3006".equals(saleReport.getGssgcode().toString())){
						sql.append(" GROUP BY to_char(S.GSRQ,'yyyy-MM-dd') ORDER BY GSRQ DESC");
					}else{
						sql.append(" GROUP BY S.GSRQ,D.SUPNAME,S.GSSUPID ORDER BY S.GSRQ DESC");
					}
					
					log.info(sql);
					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleSummaryImpl.getResult() lstResult 1 :"
							+ lstResult);
					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getShopSaleDetail() lstResult.size() 1 :"
										+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setRows(lstResult);
						result.setFooter(lstSumResult);
					}
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getShopSaleDetail() error : "
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
			
		}else if ("getShopSaleDetail_YPDM".equals(actionType)) {
			SaleReport saleReport = (SaleReport) o[0]; 
			try {
				StringBuffer sumSql =  new StringBuffer(
    				"select cast('合计' as varchar2(32)) GSRQ,SUM(GSXSSL) GSXSSL,round(SUM(GSXSSR),2) GSXSJE,round(SUM(S.GSHSJJJE),2) GSHSJJJE FROM YW_GOODSSALE_M S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1 ");
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						sumSql.append(" and S.GSSUPID = '").append(
								saleReport.getSupcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					log.debug("saleReport.getGsmfid(): "
							+ saleReport.getGsmfid());
					sumSql.append(" and S.GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sumSql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate())
							.append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("saleReport.getEndDate(): "
							+ saleReport.getEndDate());
					sumSql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}

				log.info(sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());

				if (lstSumResult != null && lstSumResult.size() > 0) {
					StringBuffer countSql =  new StringBuffer("select count(*) from (select S.GSRQ from YW_GOODSSALE_M S where 1=1");
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if("3006".equals(saleReport.getGssgcode())){
						if ("S".equals(saleReport.getUserType().toString())) {
							if (!StringUtil.isBlank(saleReport.getSupcode())) {
								log.debug("saleReport.getSupcode(): "
										+ saleReport.getSupcode());
								countSql.append(" and S.GSSUPID = '").append(
										saleReport.getSupcode()).append("'");
							}
						}
					}else {
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							countSql.append(" and S.GSSUPID = '").append(
									saleReport.getSupcode()).append("'");
						}
					}
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						countSql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate()).append(
								"','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						countSql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append(
								"','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						countSql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					}
						countSql.append(" GROUP BY S.GSRQ) COUNT");
					log.info(countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log
							.debug("SaleSummaryImpl.getShopSaleDetail() lstResult : "
									+ lstResult);

					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getShopSaleDetail() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}
					StringBuffer sql =  new StringBuffer(
						"SELECT to_char(S.GSRQ,'yyyy-MM-dd') as GSRQ,S.GSSUPID,D.SUPNAME,SUM(S.GSXSSL) AS GSXSSL,round(SUM(S.GSXSSR),2) GSXSJE,round(SUM(S.GSHSJJJE),2) AS GSHSJJJE,SUM(S.GSXSSL*S.TEMP2) AS GSXSSR FROM YW_GOODSSALE_M S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID WHERE 1=1 and S.GSXSSL != 0");
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1)
							* saleReport.getRows();
					log.debug("start: " + start);

					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if("3006".equals(saleReport.getGssgcode())){
						if ("S".equals(saleReport.getUserType().toString())) {
							if (!StringUtil.isBlank(saleReport.getSupcode())) {
								log.debug("saleReport.getSupcode(): "
										+ saleReport.getSupcode());
								sql.append(" and S.GSSUPID = '").append(
										saleReport.getSupcode()).append("'");
							}
						}
					}else {
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							sql.append(" and S.GSSUPID = '").append(
									saleReport.getSupcode()).append("'");
						}
					}
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						sql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate()).append(
								"','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						sql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append(
								"','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						sql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					}
						sql.append(" GROUP BY S.GSRQ,D.SUPNAME,S.GSSUPID ORDER BY S.GSRQ DESC");
					
					log.info(sql);
					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleSummaryImpl.getResult() lstResult 1 :"
							+ lstResult);
					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getShopSaleDetail() lstResult.size() 1 :"
										+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setRows(lstResult);
						result.setFooter(lstSumResult);
					}
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getShopSaleDetail() error : "
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
			
		} else if ("getGsrqShopSale".equals(actionType)) {
			SaleReport saleReport = (SaleReport) o[0]; 
			String gssgcode = saleReport.getGssgcode();//门店
			String goodssaleTable="YW_GOODSSALE"+gssgcode;
			try {
				boolean flag=saleReport.getGssgcode().equals("3009");
				boolean flag_3010=saleReport.getGssgcode().equals("3010");
				StringBuffer sumSql = null;
				if(flag_3010){
					sumSql = new StringBuffer(
					"SELECT cast('合计' as varchar2(30)) GDID,SUM(GSXSSL) GSXSSL,round(SUM(GSXSSR),2) GSXSJE,round(SUM(S.GSHSJJJE),2) GSXSSR FROM YW_GOODSSALE_M S where 1=1  and S.GSXSSL != 0 ");					
				}else if(flag){
					sumSql = new StringBuffer(
					"SELECT cast('合计' as varchar2(30)) GSRQ,SUM(GSXSSL) GSXSSL,round(SUM(GSXSJE),2) GSXSJE,round(SUM(S.GSHSJJJE),2) GSXSSR ,round(SUM(S.GSXSSR),2) XSSR ,(CASE WHEN SUM(GSXSJE) IS NULL OR SUM(GSXSJE)=0 THEN '0.00%' ELSE ROUND((SUM(GSXSJE)-SUM(GSHSJJJE))/SUM(GSXSJE)*100,2)||'%' END) MLL FROM YW_GOODSSALE S where 1=1");					
				}else{
					sumSql = new StringBuffer(
					"SELECT cast('合计' as varchar2(30)) GDID,SUM(GSXSSL) GSXSSL,round(SUM(GSXSJE),2) GSXSJE,round(SUM(S.GSHSJJJE),2) GSXSSR ,round(SUM(S.GSXSSR),2) XSSR FROM "+goodssaleTable+" S where 1=1");					
				}
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				if("3006".equals(saleReport.getGssgcode())){
					if ("S".equals(saleReport.getUserType().toString())) {
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							sumSql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
						}
					}
				}else {
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						if(flag){
							sumSql.append(" and substr(S.GSSUPID,0,3)= '").append(saleReport.getSupcode()).append("'");
						}else{
							sumSql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
						}
					}
				}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					log.debug("saleReport.getGsmfid(): "
							+ saleReport.getGsmfid());
					sumSql.append(" and S.GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsrq())) {
					log.debug("saleReport.getGsrq(): "
							+ saleReport.getGsrq());
					sumSql.append(" and to_char(S.GSRQ,'yyyy-MM-dd') = '").append(
							saleReport.getGsrq()).append("'");
				}

				log.info(sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());

				if (lstSumResult != null && lstSumResult.size() > 0) {
					
					StringBuffer countSql = null;
						if(flag){
							 countSql = new StringBuffer(
							"select count(*) from "+goodssaleTable+" S left join INF_GOODS_JM G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE and S.GSSUPID=G.GDSUPID  and G.GDMFID=S.GSMFID  where 1=1");
						}else if(flag_3010){
							 countSql = new StringBuffer(
								"select count(*) from YW_GOODSSALE_M S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1=1   and S.GSXSSL != 0 ");
						}else{
							 countSql = new StringBuffer(
							"select count(*) from "+goodssaleTable+" S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1=1");
						}
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if("3006".equals(saleReport.getGssgcode())){
						if ("S".equals(saleReport.getUserType().toString())) {
							if (!StringUtil.isBlank(saleReport.getSupcode())) {
								log.debug("saleReport.getSupcode(): "
										+ saleReport.getSupcode());
								countSql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
							}
						}
					}else {
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							if(flag){
								countSql.append(" and substr(S.GSSUPID,0,3) = '").append(saleReport.getSupcode()).append("'");
							}else{
								countSql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
							}
						}
					}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						countSql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getGsrq())) {
						log.debug("saleReport.getGsrq(): "
								+ saleReport.getGsrq());
						countSql.append(" and to_char(S.GSRQ,'yyyy-MM-dd') = '").append(
								saleReport.getGsrq()).append("'");
					}
					log.info(countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log.debug("SaleSummaryImpl.getGsrqShopSale() lstResult : "
							+ lstResult);

					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getGsrqShopSale() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}

					StringBuffer sql = null;
					if(flag){
						 sql = new StringBuffer(
								"select to_char(S.GSRQ,'yyyy-mm-dd') GSRQ,G.GDID,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT,S.GSXSSL,S.GSXSJE GSXSJE,S.GSHSJJJE GSXSSR,(CASE WHEN S.GSXSJE IS NULL OR S.GSXSJE=0 THEN '0.00%' ELSE ROUND((S.GSXSJE-S.GSHSJJJE)/S.GSXSJE*100,2)||'%' END )MLL, S.GSSUPID,D.SUPNAME "
								+"from "+goodssaleTable+" S left join INF_GOODS_JM G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE and G.GDSUPID=S.GSSUPID and S.GSMFID=G.GDMFID LEFT JOIN INF_RELATION_JM D ON S.GSSGCODE=D.SGCODE AND SUBSTR(S.GSSUPID,0,3)=D.SUPID where 1=1");
					}else if(flag_3010){
						sql = new StringBuffer(
								"select G.GDID,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT,S.GSXSSL,S.GSXSSR GSXSJE,S.GSHSJJJE GSXSSR,S.GSSUPID,D.SUPNAME,S.GSBARCODE BARCODE "
								+"from YW_GOODSSALE_M S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID where 1=1 and S.GSXSSL != 0");						
					}else if("3012".equals(saleReport.getGssgcode())){
						sql = new StringBuffer(
								"select G.GDID,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT,S.GSXSSL,S.GSXSJE GSXSJE,S.GSHSJJJE GSXSSR,S.GSSUPID,D.SUPNAME "
								+"from YW_GOODSSALE S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID where 1=1 and S.GSXSSL != 0");
					}else{
						 sql = new StringBuffer(
								"select G.GDID,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT,S.GSXSSL,S.GSXSJE GSXSJE,to_char(S.GSRQ, 'yyyy-MM-dd')GSRQ,S.GSHSJJJE GSXSSR ,S.GSXSSR XSSR,S.GSSUPID,D.SUPNAME,G.GDBARCODE BARCODE,s.temp5 "
								+"from "+goodssaleTable+" S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID where 1=1");
					}
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1)
							* saleReport.getRows();
					log.debug("start: " + start);

					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if("3006".equals(saleReport.getGssgcode())){
						if ("S".equals(saleReport.getUserType().toString())) {
							if (!StringUtil.isBlank(saleReport.getSupcode())) {
								log.debug("saleReport.getSupcode(): "
										+ saleReport.getSupcode());
								sql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
							}
						}
					}else {
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							if(flag){
								sql.append(" and substr(S.GSSUPID,0,3) = '").append(saleReport.getSupcode()).append("'");
							}else{
								sql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
							}
						}
					}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						sql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getGsrq())) {
						log.debug("saleReport.getGsrq(): "
								+ saleReport.getGsrq());
						sql.append(" and to_char(S.GSRQ,'yyyy-MM-dd') = '").append(
								saleReport.getGsrq()).append("'");
					}
					log.info(sql);
					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleSummaryImpl.getGsrqShopSale() lstResult 1 :"
							+ lstResult);
					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getGsrqShopSale() lstResult.size() 1 :"
										+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setRows(lstResult);
						result.setFooter(lstSumResult);
					}
				}

			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getResult() error :"
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
			
		}else if ("getGsrqShopSale_YPDM".equals(actionType)) {
			SaleReport saleReport = (SaleReport) o[0]; 
			try {
				StringBuffer sumSql = new StringBuffer(
					"SELECT cast('合计' as varchar2(30)) GDID,SUM(GSXSSL) GSXSSL,round(SUM(GSXSSR),2) GSXSJE,round(SUM(S.GSHSJJJE),2) GSXSSR FROM YW_GOODSSALE_M S where 1=1");					
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						sumSql.append(" and S.GSSUPID = '").append(
								saleReport.getSupcode()).append("'");
					}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					log.debug("saleReport.getGsmfid(): "
							+ saleReport.getGsmfid());
					sumSql.append(" and S.GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsrq())) {
					log.debug("saleReport.getGsrq(): "
							+ saleReport.getGsrq());
					sumSql.append(" and to_char(S.GSRQ,'yyyy-MM-dd') = '").append(
							saleReport.getGsrq()).append("'");
				}

				log.info(sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());

				if (lstSumResult != null && lstSumResult.size() > 0) {
					
					StringBuffer countSql =  new StringBuffer(
								"select count(*) from YW_GOODSSALE_M S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1=1");
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							countSql.append(" and S.GSSUPID = '").append(
									saleReport.getSupcode()).append("'");
						}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						countSql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getGsrq())) {
						log.debug("saleReport.getGsrq(): "
								+ saleReport.getGsrq());
						countSql.append(" and to_char(S.GSRQ,'yyyy-MM-dd') = '").append(
								saleReport.getGsrq()).append("'");
					}
					log.info(countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log.debug("SaleSummaryImpl.getGsrqShopSale() lstResult : "
							+ lstResult);

					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getGsrqShopSale() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}

					StringBuffer sql = new StringBuffer(
								"select G.GDID,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT,S.GSXSSL,S.GSXSSR GSXSJE,S.GSHSJJJE GSXSSR,S.GSSUPID,D.SUPNAME,S.GSBARCODE BARCODE "
								+"from YW_GOODSSALE_M S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID where 1=1 and S.GSXSSL != 0");						
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1)
							* saleReport.getRows();
					log.debug("start: " + start);

					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							sql.append(" and S.GSSUPID = '").append(
									saleReport.getSupcode()).append("'");
						}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						sql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getGsrq())) {
						log.debug("saleReport.getGsrq(): "
								+ saleReport.getGsrq());
						sql.append(" and to_char(S.GSRQ,'yyyy-MM-dd') = '").append(
								saleReport.getGsrq()).append("'");
					}
					log.info(sql);
					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleSummaryImpl.getGsrqShopSale() lstResult 1 :"
							+ lstResult);
					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getGsrqShopSale() lstResult.size() 1 :"
										+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setRows(lstResult);
						result.setFooter(lstSumResult);
					}
				}

			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getResult() error :"
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
			
		}else if("getGoodsDetailStock".equals(actionType)){
			//System.out.println("-------------------------------------");
			try {
				Stock stock = (Stock) o[0]; 
				String stockTable=stock.getSgcode()+"YW_ZRSTOCK";
				boolean flag=stock.getSgcode().equals("3009");
				StringBuffer sumSql = null;
				if("3029".equals(user.getSgcode()) && "S".equals(user.getSutype()+"")){
					sumSql = new StringBuffer(
					"SELECT cast('合计' as varchar2(30)) SHPCODE,SUM(case when Z.ZSKCSL >=0 then Z.ZSKCSL else 0 end ) ZSKCSL,SUM(case when Z.ZSKCJE>=0 then Z.ZSKCJE else 0 end ) ZSKCJE from YW_ZRSTOCK Z left join INF_SHOP P on Z.ZSSGCODE=P.SGCODE and Z.ZSMFID=P.SHPCODE where 1=1");
				}else{
					sumSql = new StringBuffer(
					"SELECT cast('合计' as varchar2(30)) SHPCODE,SUM(Z.ZSKCSL) ZSKCSL,SUM(Z.ZSKCJE) ZSKCJE from "+stockTable+" Z left join INF_SHOP P on Z.ZSSGCODE=P.SGCODE and Z.ZSMFID=P.SHPCODE where 1=1");
				}
				if (!StringUtil.isBlank(stock.getSgcode())) {
					log.debug("stock.getSgcode(): " + stock.getSgcode());
					sumSql.append(" and Z.ZSSGCODE = '").append(
							stock.getSgcode()).append("'");
				}
				if (!StringUtil.isBlank(stock.getSupcode())) {
					log.debug("stock.getSupcode(): " + stock.getSupcode());
					if(flag){
						sumSql.append(" and substr(Z.ZSSUPID,0,3) = '").append(stock.getSupcode()).append("'");
					}else{
						sumSql.append(" and Z.ZSSUPID = '").append(stock.getSupcode()).append("'");
					}
				}
				if (!StringUtil.isBlank(stock.getZsgdid())) {
					log.debug("stock.getZsgdid(): " + stock.getZsgdid());
					sumSql.append(" and Z.ZSGDID = '")
							.append(stock.getZsgdid()).append("'");
				}
				if(stock.getSgcode().equals("3007")){
					if (!StringUtil.isBlank(stock.getZsmfid())) {
						log.debug("stock.getZsmfid(): " + stock.getZsmfid());
						sumSql.append(" and Z.ZSMFID = '")
								.append(stock.getZsmfid()).append("'");
					}
				}else{
					sumSql.append("and Z.zsmfid in (select sp.shpcode from inf_shop sp where sp.sgcode='");
					sumSql.append(stock.getSgcode());
					sumSql.append("')");
				}
				// log.info(sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());
				//log.debug(lstSumResult);
				if (lstSumResult != null && lstSumResult.size() > 0) {
					StringBuffer countSql = new StringBuffer(
							"select count(*) from "+stockTable+" Z left join INF_SHOP P on Z.ZSSGCODE=P.SGCODE and Z.ZSMFID=P.SHPCODE where 1=1");

					if (!StringUtil.isBlank(stock.getSgcode())) {
						log.debug("stock.getSgcode(): " + stock.getSgcode());
						countSql.append(" and Z.ZSSGCODE = '").append(
								stock.getSgcode()).append("'");
					}
					if (!StringUtil.isBlank(stock.getSupcode())) {
						log.debug("stock.getSupcode(): " + stock.getSupcode());
						if(flag){
							countSql.append(" and substr(Z.ZSSUPID,0,3) = '").append(stock.getSupcode()).append("'");
						}else{
							countSql.append(" and Z.ZSSUPID = '").append(stock.getSupcode()).append("'");
						}
					}
					if (!StringUtil.isBlank(stock.getZsgdid())) {
						log.debug("stock.getZsgdid(): " + stock.getZsgdid());
						countSql.append(" and Z.ZSGDID = '").append(
								stock.getZsgdid()).append("'");
					}
					
					if(stock.getSgcode().equals("3007")){
						if (!StringUtil.isBlank(stock.getZsmfid())) {
							log.debug("stock.getZsmfid(): " + stock.getZsmfid());
							countSql.append(" and Z.ZSMFID = '").append(
									stock.getZsmfid()).append("'");
						}
					}else{
						countSql.append("and Z.zsmfid in (select sp.shpcode from inf_shop sp where sp.sgcode='");
						countSql.append(stock.getSgcode());
						countSql.append("')");
					}
					
					log.info(countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log.debug("SaleSummaryImpl.getGoodsStock() lstResult : "
							+ lstResult);

					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getGoodsStock() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}

					StringBuffer sql = null;
					if("3029".equals(user.getSgcode()) && "S".equals(user.getSutype()+"")){
						sql = new StringBuffer(
						"select P.SHPCODE,P.SHPNAME,(case when Z.ZSKCSL>=0 then Z.ZSKCSL else 0 end)ZSKCSL ,(case when Z.ZSKCJE>=0 then Z.ZSKCJE else 0 end)ZSKCJE,ZSSUPID SSUPID,to_char(sysdate-1,'yyyy-mm-dd')KCRQ,SUPNAME from "+stockTable+" Z LEFT JOIN INF_SUPINFO D ON Z.ZSSGCODE=D.SUPSGCODE AND Z.ZSSUPID=D.SUPID left join INF_SHOP P on Z.ZSSGCODE=P.SGCODE and Z.ZSMFID=P.SHPCODE where 1=1");
					}else{
						sql = new StringBuffer(
						"select P.SHPCODE,P.SHPNAME,Z.ZSKCSL,Z.ZSKCJE,ZSSUPID SSUPID,to_char(sysdate-1,'yyyy-mm-dd')KCRQ,SUPNAME from "+stockTable+" Z LEFT JOIN INF_SUPINFO D ON Z.ZSSGCODE=D.SUPSGCODE AND Z.ZSSUPID=D.SUPID left join INF_SHOP P on Z.ZSSGCODE=P.SGCODE and Z.ZSMFID=P.SHPCODE where 1=1");
					}
					int limit = stock.getRows();
					log.debug("limit: " + limit);
					int start = (stock.getPage() - 1) * stock.getRows();
					log.debug("start: " + start);

					if (!StringUtil.isBlank(stock.getSgcode())) {
						log.debug("stock.getSgcode(): " + stock.getSgcode());
						sql.append(" and Z.ZSSGCODE = '").append(
								stock.getSgcode()).append("'");
					}
					if (!StringUtil.isBlank(stock.getSupcode())) {
						log.debug("stock.getSupcode(): " + stock.getSupcode());
						sql.append(" and Z.ZSSUPID = '").append(
								stock.getSupcode()).append("'");
					}
					if (!StringUtil.isBlank(stock.getZsgdid())) {
						log.debug("stock.getZsgdid(): " + stock.getZsgdid());
						sql.append(" and Z.ZSGDID = '").append(
								stock.getZsgdid()).append("'");
					}
					if(stock.getSgcode().equals("3007")){
						if (!StringUtil.isBlank(stock.getZsmfid())) {
							log.debug("stock.getZsmfid(): " + stock.getZsmfid());
							sql.append(" and Z.ZSMFID = '").append(
									stock.getZsmfid()).append("'");
						}
						sql.append(" order by Z.ZSMFID");
					}else{
						sql.append("and Z.zsmfid in (select sp.shpcode from inf_shop sp where sp.sgcode='");
						sql.append(stock.getSgcode());
						sql.append("') order by Z.ZSMFID");
					}
					log.info(sql);

					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleSummaryImpl.getGoodsStock() lstResult 1 :"
							+ lstResult);
					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getGoodsStock() lstResult.size() 1 :"
										+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setRows(lstResult);
						result.setFooter(lstSumResult);
					}
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getSaleDetail() error :"
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		}
		else if ("getGoodsStock".equals(actionType)) {
			try {
				Stock stock = (Stock) o[0]; 
				StringBuffer sumSql = null ;
				String stockTable="YW_ZRSTOCK"+stock.getSgcode();
				if("3029".equals(user.getSgcode()) && "S".equals(user.getSutype()+"")){
					sumSql = new StringBuffer(
					"SELECT cast('合计' as varchar2(30)) SHPCODE,SUM(case when Z.ZSKCSL>=0 then Z.ZSKCSL else 0 end ) ZSKCSL,SUM(case when Z.ZSKCJE>=0 then Z.ZSKCJE else 0 end ) ZSKCJE from YW_ZRSTOCK Z left join INF_SHOP P on Z.ZSSGCODE=P.SGCODE and Z.ZSMFID=P.SHPCODE where 1=1");
				}else{
					sumSql = new StringBuffer(
					"SELECT cast('合计' as varchar2(30)) SHPCODE,SUM(Z.ZSKCSL) ZSKCSL,SUM(Z.ZSKCJE) ZSKCJE from "+stockTable+" Z left join INF_SHOP P on Z.ZSSGCODE=P.SGCODE and Z.ZSMFID=P.SHPCODE where 1=1");
				}
				if (!StringUtil.isBlank(stock.getSgcode())) {
					log.debug("stock.getSgcode(): " + stock.getSgcode());
					sumSql.append(" and Z.ZSSGCODE = '").append(
							stock.getSgcode()).append("'");
				}
				if (!StringUtil.isBlank(stock.getSupcode())) {
					log.debug("stock.getSupcode(): " + stock.getSupcode());
					sumSql.append(" and Z.ZSSUPID = '").append(
							stock.getSupcode()).append("'");
				}
				if (!StringUtil.isBlank(stock.getZsgdid())) {
					log.debug("stock.getZsgdid(): " + stock.getZsgdid());
					sumSql.append(" and Z.ZSGDID = '")
							.append(stock.getZsgdid()).append("'");
				}
				if(stock.getSgcode().equals("3024")){
					if (!StringUtil.isBlank(stock.getZsmfid())) {
						sumSql.append(" and Z.ZSMFID = '").append(
								stock.getZsmfid()).append("'");
					}
				}else{
					sumSql.append("and Z.zsmfid in (select sp.shpcode from inf_shop sp where sp.sgcode='");
					sumSql.append(stock.getSgcode());
					sumSql.append("')");
				}
				log.info(sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());
				log.debug(lstSumResult);
				if (lstSumResult != null && lstSumResult.size() > 0) {
					StringBuffer countSql = new StringBuffer(
							"select count(*) from "+stockTable+" Z left join INF_SHOP P on Z.ZSSGCODE=P.SGCODE and Z.ZSMFID=P.SHPCODE where 1=1");

					if (!StringUtil.isBlank(stock.getSgcode())) {
						log.debug("stock.getSgcode(): " + stock.getSgcode());
						countSql.append(" and Z.ZSSGCODE = '").append(
								stock.getSgcode()).append("'");
					}
					if (!StringUtil.isBlank(stock.getSupcode())) {
						log.debug("stock.getSupcode(): " + stock.getSupcode());
						countSql.append(" and Z.ZSSUPID = '").append(
								stock.getSupcode()).append("'");
					}
					if (!StringUtil.isBlank(stock.getZsgdid())) {
						log.debug("stock.getZsgdid(): " + stock.getZsgdid());
						countSql.append(" and Z.ZSGDID = '").append(
								stock.getZsgdid()).append("'");
					}
					
					if(stock.getSgcode().equals("3024")){
						if (!StringUtil.isBlank(stock.getZsmfid())) {
							log.debug("stock.getZsgdid(): " + stock.getZsgdid());
							countSql.append(" and Z.ZSMFID = '").append(
									stock.getZsmfid()).append("'");
						}
					}else{
						countSql.append("and Z.zsmfid in (select sp.shpcode from inf_shop sp where sp.sgcode='");
						countSql.append(stock.getSgcode());
						countSql.append("')");
					}

					log.info(countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log.debug("SaleSummaryImpl.getGoodsStock() lstResult : "
							+ lstResult);

					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getGoodsStock() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}

					StringBuffer sql = null;
					if(stock.getSgcode().equals("3009")){
						sql = new StringBuffer(
						"select P.SHPCODE,P.SHPNAME,Z.ZSKCSL,Z.ZSKCJE,D.SUPID SSUPID,D.SUPNAME from YW_ZRSTOCK Z LEFT JOIN INF_RELATION_JM D ON Z.ZSSGCODE=D.SGCODE AND substr(Z.ZSSUPID,0,3)=D.SUPID left join INF_SHOP P on Z.ZSSGCODE=P.SGCODE and Z.ZSMFID=P.SHPCODE where 1=1");
					}else{
						
						if("3029".equals(user.getSgcode()) && "S".equals(user.getSutype()+"")){
							sql = new StringBuffer(
							"select P.SHPCODE,P.SHPNAME,(case when Z.ZSKCSL>=0 then Z.ZSKCSL else 0 end)ZSKCSL ,( case when Z.ZSKCJE>=0 then Z.ZSKCJE else 0 end )ZSKCJE,ZSSUPID SSUPID,SUPNAME,to_char(sysdate-1,'yyyy-mm-dd')KCRQ from YW_ZRSTOCK Z LEFT JOIN INF_SUPINFO D ON Z.ZSSGCODE=D.SUPSGCODE AND Z.ZSSUPID=D.SUPID left join INF_SHOP P on Z.ZSSGCODE=P.SGCODE and Z.ZSMFID=P.SHPCODE where 1=1");
						}else{
							sql = new StringBuffer(
							"select P.SHPCODE,P.SHPNAME,Z.ZSKCSL,Z.ZSKCJE,ZSSUPID SSUPID,SUPNAME,to_char(sysdate-1,'yyyy-mm-dd')KCRQ from "+stockTable+" Z LEFT JOIN INF_SUPINFO D ON Z.ZSSGCODE=D.SUPSGCODE AND Z.ZSSUPID=D.SUPID left join INF_SHOP P on Z.ZSSGCODE=P.SGCODE and Z.ZSMFID=P.SHPCODE where 1=1");
							
						}
					}
					int limit = stock.getRows();
					log.debug("limit: " + limit);
					int start = (stock.getPage() - 1) * stock.getRows();
					log.debug("start: " + start);

					if (!StringUtil.isBlank(stock.getSgcode())) {
						log.debug("stock.getSgcode(): " + stock.getSgcode());
						sql.append(" and Z.ZSSGCODE = '").append(
								stock.getSgcode()).append("'");
					}
					if (!StringUtil.isBlank(stock.getSupcode())) {
						log.debug("stock.getSupcode(): " + stock.getSupcode());
						sql.append(" and Z.ZSSUPID = '").append(
								stock.getSupcode()).append("'");
					}
					if (!StringUtil.isBlank(stock.getZsgdid())) {
						log.debug("stock.getZsgdid(): " + stock.getZsgdid());
						sql.append(" and Z.ZSGDID = '").append(stock.getZsgdid()).append("'");
					}
					if(stock.getSgcode().equals("3024")){
						if (!StringUtil.isBlank(stock.getZsmfid())) {
							log.debug("stock.getZsgdid(): " + stock.getZsgdid());
							sql.append(" and Z.ZSMFID = '").append(
									stock.getZsmfid()).append("'");
						}
						sql.append(" order by Z.ZSMFID");
					}else{
						sql.append("and Z.zsmfid in (select sp.shpcode from inf_shop sp where sp.sgcode='");
						sql.append(stock.getSgcode());
						sql.append("') order by Z.ZSMFID");
					}
					log.info(sql);

					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleSummaryImpl.getGoodsStock() lstResult 1 :"
							+ lstResult);
					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getGoodsStock() lstResult.size() 1 :"
										+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setRows(lstResult);
						result.setFooter(lstSumResult);
					}
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getSaleDetail() error :"
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
			
		} else if ("getSaleDetail".equals(actionType)) {
			
		try {
			SaleReport saleReport = (SaleReport) o[0]; // 查询条件
			boolean flag=saleReport.getGssgcode().equals("3009");
			boolean flag_3010=saleReport.getGssgcode().equals("3010");
			String goodssaleTable="YW_GOODSSALE"+saleReport.getGssgcode();
			StringBuffer sumSql = null;
             if(flag){
     			 sumSql = new StringBuffer(
    			"select cast('合计' as varchar2(32)) GSRQ,SUM(GSXSSL) GSXSSL,round(SUM(GSHSJJJE),2) GSXSJE,round(SUM(S.GSXSSR),2) GSXSSR,round(SUM(S.GSHSJJJE),2) XSSR,(CASE WHEN SUM(S.GSXSSR) IS NULL OR SUM(S.GSXSSR)=0 THEN '0.00%' ELSE ROUND((SUM(S.GSXSSR)-SUM(S.GSHSJJJE))/SUM(S.GSXSSR)*100,2)||'%' END )MLL FROM "+goodssaleTable+" S left join INF_GOODS_JM G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE and G.GDSUPID=S.GSSUPID and S.GSMFID=G.GDMFID and S.GSMFID = G.GDMFID where 1 = 1 ");
             }else if(flag_3010){
            	 sumSql = new StringBuffer(
     			"select cast('合计' as varchar2(32)) GSRQ,SUM(GSXSSL) GSXSSL,round(SUM(GSHSJJJE),2) GSXSJE,round(SUM(S.GSXSSR),2) GSXSSR,round(SUM(S.GSHSJJJE),2) XSSR FROM YW_GOODSSALE_M S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1 ");
             }else{
            		 sumSql = new StringBuffer(
         			"select cast('合计' as varchar2(32)) GSRQ,SUM(GSXSSL) GSXSSL,round(SUM(GSHSJJJE),2) GSXSJE,round(SUM(S.GSXSJE),2) GSXSSR,round(SUM(S.GSHSJJJE),2) XSSR,round(SUM(S.GSXSSR),2) XSSR2 ,round(SUM(S.GSVENDREBATE),2) GSVENDREBATE FROM "+goodssaleTable+" S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1 ");
             }
			if (!StringUtil.isBlank(saleReport.getGssgcode())) {
				log.debug("saleReport.getGssgcode(): "
						+ saleReport.getGssgcode());
				sumSql.append(" and S.GSSGCODE = '").append(
						saleReport.getGssgcode()).append("'");
			}
			if (!StringUtil.isBlank(saleReport.getSupcode())) {
				log.debug("saleReport.getSupcode(): "
						+ saleReport.getSupcode());
				if(flag){
					sumSql.append(" and substr(S.GSSUPID,0,3) = '").append(saleReport.getSupcode()).append("'");
				}else{
					sumSql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
				}
			}
			if (!StringUtil.isBlank(saleReport.getGsmfid())) {
				log.debug("saleReport.getGsmfid(): "
						+ saleReport.getGsmfid());
				sumSql.append(" and S.GSMFID = '").append(
						saleReport.getGsmfid()).append("'");
			}
			if (!StringUtil.isBlank(saleReport.getGsgdid())) {
				log.debug("saleReport.getGsgdid(): "
						+ saleReport.getGsgdid());
				if("3006".equals(saleReport.getGssgcode())){
					sumSql.append(" and S.GSGDID like '%").append(
							saleReport.getGsgdid()).append("%'");
				}else{
					sumSql.append(" and S.GSGDID = '").append(
							saleReport.getGsgdid()).append("'");
				}
			}
			if (!StringUtil.isBlank(saleReport.getGdbarcode())) {
				log.debug("saleReport.getGdbarcode(): "
						+ saleReport.getGdbarcode());
				sumSql.append(" and G.GDBARCODE like '%").append(
						saleReport.getGdbarcode()).append("%'");
			}
			if (!StringUtil.isBlank(saleReport.getGsgdname())) {
				log.debug("saleReport.getGsgdname(): "
						+ saleReport.getGsgdname());
				sumSql.append(" and G.GDNAME like '%").append(
						saleReport.getGsgdname()).append("%'");
			}
			if (!StringUtil.isBlank(saleReport.getCategory())) {
				log.debug("saleReport.getCategory(): "
						+ saleReport.getCategory());
				sumSql.append(" and G.GDPPNAME like '%").append(
						saleReport.getCategory()).append("%'");
			}
			if (!StringUtil.isBlank(saleReport.getStartDate())) {
				log.debug("saleReport.getStartDate(): "
						+ saleReport.getStartDate());
				sumSql.append(" and S.GSRQ >= to_date('").append(
						saleReport.getStartDate())
						.append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(saleReport.getEndDate())) {
				log.debug("goodssale.getEndDate(): "
						+ saleReport.getEndDate());
				sumSql.append(" and S.GSRQ <= to_date('").append(
						saleReport.getEndDate()).append("','yyyy-MM-dd')");
			}

			log.info(sumSql);
			List lstSumResult = dao.executeSql(sumSql.toString());

			if (lstSumResult != null && lstSumResult.size() > 0) {
				StringBuffer countSql = null;
              if(flag){
  				 countSql = new StringBuffer(
				"select count(*) from (SELECT GSSUPID,GSGDID,GSRQ FROM "+goodssaleTable+" S left join INF_GOODS_JM G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE and G.GDSUPID=S.GSSUPID  and S.GSMFID=G.GDMFID where 1 = 1");
              }else if(flag_3010){
            	  countSql = new StringBuffer(
  				"select count(*) from (SELECT GSSUPID,GSGDID,GSRQ FROM YW_GOODSSALE_M S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1  and S.GSXSSL!=0 ");            	  
              }else if(saleReport.getGssgcode().equals("3018")){
            	  countSql = new StringBuffer(
            	  "select count(*) from (SELECT GSSUPID,GSGDID FROM YW_GOODSSALE S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1 and S.GSXSSL!=0");
              }else{
            	  countSql = new StringBuffer(
            	  "select count(*) from (SELECT GSSUPID,GSGDID,GSRQ FROM "+goodssaleTable+" S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1 and S.GSXSSL!=0");
            	  
              }
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					countSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getSupcode())) {
					log.debug("saleReport.getSupcode(): "
							+ saleReport.getSupcode());
					if(flag){
						countSql.append(" and substr(S.GSSUPID,0,3) = '").append(saleReport.getSupcode()).append("'");
					}else{
						countSql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
					}
				}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					log.debug("saleReport.getGsmfid(): "
							+ saleReport.getGsmfid());
					countSql.append(" and S.GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsgdid())) {
					log.debug("saleReport.getGsgdid(): "
							+ saleReport.getGsgdid());
					if("3006".equals(saleReport.getGssgcode())){
						countSql.append(" and S.GSGDID like '%").append(
								saleReport.getGsgdid()).append("%'");
					}else{
						countSql.append(" and S.GSGDID = '").append(
								saleReport.getGsgdid()).append("'");
					}
				}
				if (!StringUtil.isBlank(saleReport.getGdbarcode())) {
					log.debug("saleReport.getGdbarcode(): "
							+ saleReport.getGdbarcode());
					countSql.append(" and G.GDBARCODE like '%").append(
							saleReport.getGdbarcode()).append("%'");
				}
				if (!StringUtil.isBlank(saleReport.getGsgdname())) {
					log.debug("saleReport.getGsgdname(): "
							+ saleReport.getGsgdname());
					countSql.append(" and G.GDNAME like '%").append(
							saleReport.getGsgdname()).append("%'");
				}
				if (!StringUtil.isBlank(saleReport.getCategory())) {
					log.debug("saleReport.getCategory(): "
							+ saleReport.getCategory());
					countSql.append(" and G.GDPPNAME like '%").append(
							saleReport.getCategory()).append("%'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					countSql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate()).append(
							"','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("goodssale.getEndDate(): "
							+ saleReport.getEndDate());
					countSql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append(
							"','yyyy-MM-dd')");
				}
				if(saleReport.getGssgcode().equals("3018")){
					countSql.append(" group by GSSUPID,GSGDID) temp1");
				}else{
					countSql.append(" group by GSSUPID,GSGDID,GSRQ) temp1");
				}
				log.debug(countSql);
				List lstResult = dao.executeSqlCount(countSql.toString());
				log.debug("SaleSummaryImpl.getSaleDetail() lstResult : "
						+ lstResult);

				if (lstResult != null) {
					log
							.debug("SaleSummaryImpl.getSaleDetail() lstResult.get(0).toString() : "
									+ lstResult.get(0).toString());
					result.setTotal(Integer.parseInt(lstResult.get(0)
							.toString()));
				}
				
				//判断当前登录的是否是太原好朋友供应商
				StringBuffer sql = null;
				if("3005".equals(saleReport.getGssgcode()) || "3004".equals(saleReport.getGssgcode())){
					sql = new StringBuffer(
					"select S.GSSUPID,D.SUPNAME,G.GDID,G.GDBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT,SUM(S.GSXSSL) GSXSSL,"
                    +"SUM(S.GSHSJJJE) GSXSJE,SUM(S.GSXSJE) GSXSSR,SUM(S.TEMP3) XSSR "
                    +"from YW_GOODSSALE S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1");
				
				}else{
					if(flag){
						sql = new StringBuffer(
								"select to_char(S.GSRQ,'yyyy-MM-dd') as GSRQ,S.GSSUPID,D.SUPNAME,S.GSGDID GDID,G.GDBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT,SUM(S.GSXSSL) GSXSSL,"
								+"SUM(S.GSHSJJJE) GSXSJE,SUM(S.GSXSSR) GSXSSR ,(CASE WHEN SUM(S.GSXSSR) IS NULL OR SUM(S.GSXSSR)=0 THEN '0.00%' ELSE ROUND((SUM(S.GSXSSR)-SUM(S.GSHSJJJE))/SUM(S.GSXSSR)*100,2)||'%' END )MLL "
								+"from "+goodssaleTable+" S LEFT JOIN INF_RELATION_JM D ON S.GSSGCODE=D.SGCODE AND SUBSTR(S.GSSUPID,0,3)=D.SUPID left join INF_GOODS_JM G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE and G.GDSUPID=S.GSSUPID AND G.GDMFID=S.GSMFID where 1 = 1");
					}else if(flag_3010){
						sql = new StringBuffer(
								"select to_char(S.GSRQ,'yyyy-MM-dd') as GSRQ,S.GSSUPID,D.SUPNAME,S.GSGDID GDID,S.GSBARCODE GDBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT,SUM(S.GSXSSL) GSXSSL,"
								+"SUM(S.GSHSJJJE) GSXSJE,SUM(S.GSXSSR) GSXSSR,S.TEMP3,SUM(S.TEMP3) XSSR "
								+"from YW_GOODSSALE_M S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1 and S.GSXSSL!=0");
					}else if("3006".equals(saleReport.getGssgcode())){
						sql = new StringBuffer(
								"select to_char(S.GSRQ,'yyyy-MM-dd') as GSRQ,S.GSSUPID,D.SUPNAME,S.GSGDID AS GDID,G.GDBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT,SUM(S.GSXSSL) GSXSSL,"
								+"SUM(S.GSHSJJJE) GSXSJE,SUM(S.GSXSJE) GSXSSR,SUM(S.GSXSSR) XSSR2,S.TEMP3,SUM(S.TEMP3) XSSR "
								+"from YW_GOODSSALE S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1 and S.GSXSSL!=0");
					}else if("3018".equals(saleReport.getGssgcode())){
						sql = new StringBuffer(		
                                "select S.GSSUPID,D.SUPNAME,S.GSGDID AS GDID,G.GDBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT,SUM(S.GSXSSL) GSXSSL,"
								+"SUM(S.GSHSJJJE) GSXSJE,SUM(S.GSXSJE) GSXSSR,SUM(S.GSXSSR) XSSR2,S.TEMP3,SUM(S.TEMP3) XSSR "
								+"from YW_GOODSSALE S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1 and S.GSXSSL!=0");

					}else{
						sql = new StringBuffer(
								"select to_char(S.GSRQ,'yyyy-MM-dd') as GSRQ,S.GSSUPID,D.SUPNAME,S.GSGDID AS GDID,G.GDBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT,s.temp5,SUM(S.GSXSSL) GSXSSL,"
								+"SUM(S.GSHSJJJE) GSXSJE,SUM(S.GSXSJE) GSXSSR,SUM(S.GSXSSR) XSSR2,S.TEMP3,SUM(S.TEMP3) XSSR,round(SUM(S.GSVENDREBATE),2) GSVENDREBATE "
								+"from "+goodssaleTable+" S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1 and S.GSXSSL!=0");
					}
				}
				int limit = saleReport.getRows();
				log.debug("limit: " + limit);
				int start = (saleReport.getPage() - 1)
						* saleReport.getRows();
				log.debug("start: " + start);

				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getSupcode())) {
					log.debug("saleReport.getSupcode(): "
							+ saleReport.getSupcode());
					if(flag){
						sql.append(" and SUBSTR(S.GSSUPID,0,3) = '").append(saleReport.getSupcode()).append("'");
					}else{
						sql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
					}
				}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					log.debug("saleReport.getGsmfid(): "
							+ saleReport.getGsmfid());
					sql.append(" and S.GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsgdid())) {
					log.debug("saleReport.getGsgdid(): "
							+ saleReport.getGsgdid());
					if("3006".equals(saleReport.getGssgcode())){
						sql.append(" and S.GSGDID like '%").append(
								saleReport.getGsgdid()).append("%'");
					}else{
						sql.append(" and S.GSGDID = '").append(
								saleReport.getGsgdid()).append("'");
					}
				}
				if (!StringUtil.isBlank(saleReport.getGdbarcode())) {
					log.debug("saleReport.getGdbarcode(): "
							+ saleReport.getGdbarcode());
					sql.append(" and G.GDBARCODE like '%").append(
							saleReport.getGdbarcode()).append("%'");
				}
				if (!StringUtil.isBlank(saleReport.getGsgdname())) {
					log.debug("saleReport.getGsgdname(): "
							+ saleReport.getGsgdname());
					sql.append(" and G.GDNAME like '%").append(
							saleReport.getGsgdname()).append("%'");
				}
				if (!StringUtil.isBlank(saleReport.getCategory())) {
					log.debug("saleReport.getCategory(): "
							+ saleReport.getCategory());
					sql.append(" and G.GDPPNAME like '%").append(
							saleReport.getCategory()).append("%'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate()).append(
							"','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("goodssale.getEndDate(): "
							+ saleReport.getEndDate());
					sql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append(
							"','yyyy-MM-dd')");
				}
				if("3005".equals(saleReport.getGssgcode()) || "3004".equals(saleReport.getGssgcode())){
					sql.append(" group by S.GSSUPID,D.SUPNAME,G.GDID,G.GDBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT ");
					sql.append(" order by G.GDPPNAME,G.GDID desc");
				}else if ("3006".equals(saleReport.getGssgcode())) {
					sql.append(" group by to_char(S.GSRQ,'yyyy-MM-dd'),S.GSSUPID,S.TEMP3,D.SUPNAME,S.GSGDID,G.GDBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT ");
					sql.append(" order by GSRQ,G.GDPPNAME,S.GSGDID desc");
				}else if ("3018".equals(saleReport.getGssgcode())) {
					sql.append("  group by S.GSSUPID,S.TEMP3,D.SUPNAME,S.GSGDID,G.GDBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT ");
					sql.append(" order by G.GDPPNAME,S.GSGDID desc");
				}else{
					if(flag_3010){
						sql.append(" group by GSRQ,S.GSSUPID,S.TEMP3,D.SUPNAME,S.GSGDID,S.GSBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT ");
					}else{
						sql.append(" group by GSRQ,S.GSSUPID,S.TEMP3,D.SUPNAME,S.GSGDID,G.GDBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT ,s.temp5 ");
					}
					sql.append(" order by S.GSRQ,G.GDPPNAME,S.GSGDID desc");
				}
				

				log.info(sql);

				lstResult = dao.executeSql(sql.toString(), start, limit);
				
				if("3005".equals(saleReport.getGssgcode()) || "3004".equals(saleReport.getGssgcode())){
					String rownum = "select count(*) from ("+sql.toString()+")";
					result.setTotal(Integer.parseInt(dao.executeSqlCount(rownum).get(0).toString()));
				}
				log.debug("SaleSummaryImpl.getSaleDetail() lstResult 1 :"
						+ lstResult);
				if (lstResult != null) {
					log
							.debug("SaleSummaryImpl.getSaleDetail() lstResult.size() 1 :"
									+ lstResult.size());
					result.setReturnCode(Constants.SUCCESS_FLAG);
					result.setRows(lstResult);
					result.setFooter(lstSumResult);
				}
			}
		} catch (Exception ex) {
			log.error("SaleSummaryImpl.getSaleDetail() error :"
					+ ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
	}else if ("getSalesumReport_jnks".equals(actionType)) {
		
		try {
				SaleReport saleReport = (SaleReport) o[0]; // 鏌ヨ鏉′欢
				String goodssaleTable="YW_GOODSSALE"+saleReport.getGssgcode();
				StringBuffer sumSql = null;

				sumSql = new StringBuffer(
						"select cast('合计' as varchar2(32))  GDID,SUM(GSXSSL) GSXSSL,round(SUM(GSHSJJJE),2) GSXSJE,round(SUM(S.GSXSJE),2) GSXSSR FROM "+goodssaleTable+" S  where 1 = 1 and S.GSXSSL!=0 ");

				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}

				if (!StringUtil.isBlank(saleReport.getSupcode())) {
					log.debug("saleReport.getSupcode(): "
							+ saleReport.getSupcode());

					sumSql.append(" and S.GSSUPID = '").append(
							saleReport.getSupcode()).append("'");

				}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					log.debug("saleReport.getGsmfid(): "
							+ saleReport.getGsmfid());
					sumSql.append(" and S.GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsgdid())) {
					log.debug("saleReport.getGsgdid(): "
							+ saleReport.getGsgdid());

					sumSql.append(" and S.GSGDID = '").append(
							saleReport.getGsgdid()).append("'");

				}
				if (!StringUtil.isBlank(saleReport.getGdbarcode())) {
					log.debug("saleReport.getGdbarcode(): "
							+ saleReport.getGdbarcode());
					sumSql.append(" and G.GDBARCODE = '").append(
							saleReport.getGdbarcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsgdname())) {
					log.debug("saleReport.getGsgdname(): "
							+ saleReport.getGsgdname());
					sumSql.append(" and G.GDNAME like '%").append(
							saleReport.getGsgdname()).append("%'");
				}
				if (!StringUtil.isBlank(saleReport.getCategory())) {
					log.debug("saleReport.getCategory(): "
							+ saleReport.getCategory());
					sumSql.append(" and G.GDPPNAME like '%").append(
							saleReport.getCategory()).append("%'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sumSql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate())
							.append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("goodssale.getEndDate(): "
							+ saleReport.getEndDate());
					sumSql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}

				log.info(sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());
				if (lstSumResult != null && lstSumResult.size() > 0) {
					StringBuffer countSql = null;

					countSql = new StringBuffer(
							"select count(*) from ( select G.GDID,G.GDBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT,SUM(S.GSXSSL) GSXSSL,SUM(S.GSHSJJJE) GSXSJE,SUM(S.GSXSJE) GSXSSR, D.SUPID SUPID,D.SUPNAME SUPNAME  from "+goodssaleTable+" S LEFT JOIN INF_SUPINFO D  ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1 and S.GSXSSL!=0 ");

					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());

						countSql.append(" and S.GSSUPID = '").append(
								saleReport.getSupcode()).append("'");

					}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						countSql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getGsgdid())) {
						log.debug("saleReport.getGsgdid(): "
								+ saleReport.getGsgdid());

						countSql.append(" and S.GSGDID = '").append(
								saleReport.getGsgdid()).append("'");

					}
					if (!StringUtil.isBlank(saleReport.getGdbarcode())) {
						log.debug("saleReport.getGdbarcode(): "
								+ saleReport.getGdbarcode());
						countSql.append(" and G.GDBARCODE = '").append(
								saleReport.getGdbarcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getGsgdname())) {
						log.debug("saleReport.getGsgdname(): "
								+ saleReport.getGsgdname());
						countSql.append(" and G.GDNAME like '%").append(
								saleReport.getGsgdname()).append("%'");
					}
					if (!StringUtil.isBlank(saleReport.getCategory())) {
						log.debug("saleReport.getCategory(): "
								+ saleReport.getCategory());
						countSql.append(" and G.GDPPNAME like '%").append(
								saleReport.getCategory()).append("%'");
					}
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						countSql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate()).append(
								"','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("goodssale.getEndDate(): "
								+ saleReport.getEndDate());
						countSql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append(
								"','yyyy-MM-dd')");
					}
					countSql
							.append(" group by S.TEMP3,G.GDID,G.GDBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT, D.SUPID, D.SUPNAME  order by G.GDPPNAME,G.GDID desc )");
					log.debug(countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log.debug("SaleSummaryImpl.getSaleDetail() lstCount : "
							+ lstResult);

					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getSaleDetail() lstCount.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}
					StringBuffer sql = null;

					sql = new StringBuffer(
							"select G.GDID,G.GDBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT,SUM(S.GSXSSL) GSXSSL,"
									+ "SUM(S.GSHSJJJE) GSXSJE,SUM(S.GSXSJE) GSXSSR,D.SUPID SUPID,D.SUPNAME SUPNAME "
									+ "from "+goodssaleTable+" S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1 and S.GSXSSL!=0");

					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1)
							* saleReport.getRows();
					log.debug("start: " + start);

					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());

						sql.append(" and S.GSSUPID = '").append(
								saleReport.getSupcode()).append("'");

					}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						sql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getGsgdid())) {
						log.debug("saleReport.getGsgdid(): "
								+ saleReport.getGsgdid());

						sql.append(" and S.GSGDID = '").append(
								saleReport.getGsgdid()).append("'");

					}
					if (!StringUtil.isBlank(saleReport.getGdbarcode())) {
						log.debug("saleReport.getGdbarcode(): "
								+ saleReport.getGdbarcode());
						sql.append(" and G.GDBARCODE = '").append(
								saleReport.getGdbarcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getGsgdname())) {
						log.debug("saleReport.getGsgdname(): "
								+ saleReport.getGsgdname());
						sql.append(" and G.GDNAME like '%").append(
								saleReport.getGsgdname()).append("%'");
					}
					if (!StringUtil.isBlank(saleReport.getCategory())) {
						log.debug("saleReport.getCategory(): "
								+ saleReport.getCategory());
						sql.append(" and G.GDPPNAME like '%").append(
								saleReport.getCategory()).append("%'");
					}
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						sql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate()).append(
								"','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("goodssale.getEndDate(): "
								+ saleReport.getEndDate());
						sql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append(
								"','yyyy-MM-dd')");
					}

					sql
							.append(" group by S.TEMP3,G.GDID,G.GDBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT, D.SUPID, D.SUPNAME  ");

					sql.append(" order by G.GDPPNAME,G.GDID desc");

					log.info(sql);
					lstResult = dao.executeSql(sql.toString(), start, limit);
					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getSaleDetail_jnks() lstResult.size() 1 :"
										+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setRows(lstResult);
						result.setFooter(lstSumResult);
					}

				}
			} catch (Exception ex) {
			log.error("SaleSummaryImpl.getSaleDetail() error :"
					+ ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
	}
	    else if ("getSaleDetail_YPDM".equals(actionType)) {
		try {
			SaleReport saleReport = (SaleReport) o[0]; // 查询条件
			StringBuffer sumSql = new StringBuffer(
     			"select cast('合计' as varchar2(32)) GSRQ,SUM(GSXSSL) GSXSSL,round(SUM(GSHSJJJE),2) GSXSJE,round(SUM(S.GSXSSR),2) GSXSSR,round(SUM(S.GSHSJJJE),2) XSSR FROM YW_GOODSSALE_M S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1 ");
			if (!StringUtil.isBlank(saleReport.getGssgcode())) {
				log.debug("saleReport.getGssgcode(): "
						+ saleReport.getGssgcode());
				sumSql.append(" and S.GSSGCODE = '").append(
						saleReport.getGssgcode()).append("'");
			}
			if (!StringUtil.isBlank(saleReport.getSupcode())) {
				log.debug("saleReport.getSupcode(): "
						+ saleReport.getSupcode());
				sumSql.append(" and S.GSSUPID = '").append(
						saleReport.getSupcode()).append("'");
			}
			if (!StringUtil.isBlank(saleReport.getGsmfid())) {
				log.debug("saleReport.getGsmfid(): "
						+ saleReport.getGsmfid());
				sumSql.append(" and S.GSMFID = '").append(
						saleReport.getGsmfid()).append("'");
			}
			if (!StringUtil.isBlank(saleReport.getGsgdid())) {
				log.debug("saleReport.getGsgdid(): "
						+ saleReport.getGsgdid());
					sumSql.append(" and S.GSGDID = '").append(
							saleReport.getGsgdid()).append("'");
			}
			if (!StringUtil.isBlank(saleReport.getGdbarcode())) {
				log.debug("saleReport.getGdbarcode(): "
						+ saleReport.getGdbarcode());
				sumSql.append(" and G.GDBARCODE = '").append(
						saleReport.getGdbarcode()).append("'");
			}
			if (!StringUtil.isBlank(saleReport.getGsgdname())) {
				log.debug("saleReport.getGsgdname(): "
						+ saleReport.getGsgdname());
				sumSql.append(" and G.GDNAME like '%").append(
						saleReport.getGsgdname()).append("%'");
			}
			if (!StringUtil.isBlank(saleReport.getCategory())) {
				log.debug("saleReport.getCategory(): "
						+ saleReport.getCategory());
				sumSql.append(" and G.GDPPNAME like '%").append(
						saleReport.getCategory()).append("%'");
			}
			if (!StringUtil.isBlank(saleReport.getStartDate())) {
				log.debug("saleReport.getStartDate(): "
						+ saleReport.getStartDate());
				sumSql.append(" and S.GSRQ >= to_date('").append(
						saleReport.getStartDate())
						.append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(saleReport.getEndDate())) {
				log.debug("goodssale.getEndDate(): "
						+ saleReport.getEndDate());
				sumSql.append(" and S.GSRQ <= to_date('").append(
						saleReport.getEndDate()).append("','yyyy-MM-dd')");
			}

			log.info(sumSql);
			List lstSumResult = dao.executeSql(sumSql.toString());

			if (lstSumResult != null && lstSumResult.size() > 0) {
				StringBuffer countSql = new StringBuffer(
  				"select count(*) from (select S.GSRQ,S.GSSUPID,D.SUPNAME, G.GDID,S.GSBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT from YW_GOODSSALE_M S LEFT JOIN INF_SUPINFO D  ON S.GSSGCODE = D.SUPSGCODE  AND S.GSSUPID = D.SUPID  left join INF_GOODS G  on S.GSGDID = G.GDID and S.GSSGCODE = G.GDSGCODE  where 1 = 1 ");            	  
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					countSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getSupcode())) {
					log.debug("saleReport.getSupcode(): "
							+ saleReport.getSupcode());
					countSql.append(" and S.GSSUPID = '").append(
							saleReport.getSupcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					log.debug("saleReport.getGsmfid(): "
							+ saleReport.getGsmfid());
					countSql.append(" and S.GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsgdid())) {
					log.debug("saleReport.getGsgdid(): "
							+ saleReport.getGsgdid());
						countSql.append(" and S.GSGDID = '").append(
								saleReport.getGsgdid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGdbarcode())) {
					log.debug("saleReport.getGdbarcode(): "
							+ saleReport.getGdbarcode());
					countSql.append(" and G.GDBARCODE = '").append(
							saleReport.getGdbarcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsgdname())) {
					log.debug("saleReport.getGsgdname(): "
							+ saleReport.getGsgdname());
					countSql.append(" and G.GDNAME like '%").append(
							saleReport.getGsgdname()).append("%'");
				}
				if (!StringUtil.isBlank(saleReport.getCategory())) {
					log.debug("saleReport.getCategory(): "
							+ saleReport.getCategory());
					countSql.append(" and G.GDPPNAME like '%").append(
							saleReport.getCategory()).append("%'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					countSql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate()).append(
							"','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("goodssale.getEndDate(): "
							+ saleReport.getEndDate());
					countSql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append(
							"','yyyy-MM-dd')");
				}
				countSql.append(" group by S.GSRQ, S.GSSUPID,  D.SUPNAME, G.GDID, S.GSBARCODE, G.GDNAME,  G.GDPPNAME, G.GDSPEC, G.GDUNIT) temp1");
				log.debug(countSql);
				List lstResult = dao.executeSqlCount(countSql.toString());
				log.debug("SaleSummaryImpl.getSaleDetail_YPDM() lstResult : "
						+ lstResult);

				if (lstResult != null) {
					log
							.debug("SaleSummaryImpl.getSaleDetail_YPDM() lstResult.get(0).toString() : "
									+ lstResult.get(0).toString());
					result.setTotal(Integer.parseInt(lstResult.get(0)
							.toString()));
				}
				
				StringBuffer sql =  new StringBuffer(
								"select to_char(S.GSRQ,'yyyy-MM-dd') as GSRQ,S.GSSUPID,D.SUPNAME,G.GDID,S.GSBARCODE GDBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT,SUM(S.GSXSSL) GSXSSL,"
								+"SUM(S.GSHSJJJE) GSXSJE,SUM(S.GSXSSR) GSXSSR "
								+"from YW_GOODSSALE_M S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1 = 1 ");
				int limit = saleReport.getRows();
				log.debug("limit: " + limit);
				int start = (saleReport.getPage() - 1)
						* saleReport.getRows();
				log.debug("start: " + start);

				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getSupcode())) {
					log.debug("saleReport.getSupcode(): "
							+ saleReport.getSupcode());
					sql.append(" and S.GSSUPID = '").append(
							saleReport.getSupcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					log.debug("saleReport.getGsmfid(): "
							+ saleReport.getGsmfid());
					sql.append(" and S.GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsgdid())) {
					log.debug("saleReport.getGsgdid(): "
							+ saleReport.getGsgdid());
						sql.append(" and S.GSGDID = '").append(
								saleReport.getGsgdid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGdbarcode())) {
					log.debug("saleReport.getGdbarcode(): "
							+ saleReport.getGdbarcode());
					sql.append(" and G.GDBARCODE = '").append(
							saleReport.getGdbarcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsgdname())) {
					log.debug("saleReport.getGsgdname(): "
							+ saleReport.getGsgdname());
					sql.append(" and G.GDNAME like '%").append(
							saleReport.getGsgdname()).append("%'");
				}
				if (!StringUtil.isBlank(saleReport.getCategory())) {
					log.debug("saleReport.getCategory(): "
							+ saleReport.getCategory());
					sql.append(" and G.GDPPNAME like '%").append(
							saleReport.getCategory()).append("%'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate()).append(
							"','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("goodssale.getEndDate(): "
							+ saleReport.getEndDate());
					sql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append(
							"','yyyy-MM-dd')");
				}
						sql.append(" group by GSRQ,S.GSSUPID,S.TEMP3,D.SUPNAME,G.GDID,S.GSBARCODE,G.GDNAME,G.GDPPNAME,G.GDSPEC,G.GDUNIT ");
					sql.append(" order by S.GSRQ,G.GDPPNAME,G.GDID desc");
				log.info(sql);

				lstResult = dao.executeSql(sql.toString(), start, limit);
				
				log.debug("SaleSummaryImpl.getSaleDetail_YPDM() lstResult 1 :"
						+ lstResult);
				if (lstResult != null) {
					log
							.debug("SaleSummaryImpl.getSaleDetail_YPDM() lstResult.size() 1 :"
									+ lstResult.size());
					result.setReturnCode(Constants.SUCCESS_FLAG);
					result.setRows(lstResult);
					result.setFooter(lstSumResult);
				}
			}
		} catch (Exception ex) {
			log.error("SaleSummaryImpl.getSaleDetail_YPDM() error :"
					+ ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
	}else if ("getAllBrand".equals(actionType)) {
			SaleReport saleReport = (SaleReport) o[0]; 
			boolean flag=saleReport.getGssgcode().equals("3009");
			try {
				StringBuffer sql = null;
				if(flag){
					 sql = new StringBuffer(
					"SELECT distinct(GDPPNAME) as GDPPNAME from INF_GOODS_JM G where 1 = 1 ");
					
				}else{
					 sql = new StringBuffer(
					"SELECT distinct(GDPPNAME) as GDPPNAME from INF_GOODS G where 1 = 1 ");
					
				}
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sql.append(" and gdsgcode = '").append(
							saleReport.getGssgcode()).append("'");
				}
				log.info(sql);
				List lstResult = dao.executeSql(sql.toString());
				log.debug("SaleSummaryImpl.getAllBrand() lstResult 1 :"
						+ lstResult);
				if (lstResult != null) {
					log
							.debug("SaleSummaryImpl.getAllBrand() lstResult.size() 1 :"
									+ lstResult.size());
					result.setReturnCode(Constants.SUCCESS_FLAG);
					result.setRows(lstResult);
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getAllBrand() error :"
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		
		}else if ("getAllCategoryname".equals(actionType)) {
			SaleReport saleReport = (SaleReport) o[0]; 
			try {
				StringBuffer sql = null;
			    if(user.getSgcode().equals("3034")){
					sql = new StringBuffer(
					"SELECT distinct gcname name from inf_goodscat where 1 = 1 and gcid != ' ' ");
			    }else{
					 sql = new StringBuffer(
					"SELECT distinct gcname name from inf_goodscat where 1 = 1 ");
					
				}
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ user.getSgcode());
					sql.append(" and gcsgcode = '").append(user.getSgcode()).append("'");
				}
				log.info(sql);
				List lstResult = dao.executeSql(sql.toString());
				log.debug("SaleSummaryImpl.getAllCategory() lstResult 1 :"
						+ lstResult);
				if (lstResult != null) {
					log
							.debug("SaleSummaryImpl.getAllCategory() lstResult.size() 1 :"
									+ lstResult.size());
					result.setReturnCode(Constants.SUCCESS_FLAG);
					result.setRows(lstResult);
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getAllCategory() error :"
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		} else if ("getAllCategory".equals(actionType)) {
			SaleReport saleReport = (SaleReport) o[0]; 
			try {
				boolean flag=user.getSgcode().equals("3009");
				StringBuffer sql = null;
				if(flag){
					 sql = new StringBuffer(
					"SELECT gcid code,gcname name from inf_goodscat_JM where 1 = 1 ");
					
				}else if(user.getSgcode().equals("3034")){
					sql = new StringBuffer(
					"SELECT gcid code,gcname name from inf_goodscat where 1 = 1 and gcid != ' ' ");
			    }else{
					 sql = new StringBuffer(
					"SELECT gcid code,gcname name from inf_goodscat where 1 = 1 ");
					
				}
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ user.getSgcode());
					sql.append(" and gcsgcode = '").append(user.getSgcode()).append("'");
				}
				log.info(sql);
				List lstResult = dao.executeSql(sql.toString());
				log.debug("SaleSummaryImpl.getAllCategory() lstResult 1 :"
						+ lstResult);
				if (lstResult != null) {
					log
							.debug("SaleSummaryImpl.getAllCategory() lstResult.size() 1 :"
									+ lstResult.size());
					result.setReturnCode(Constants.SUCCESS_FLAG);
					result.setRows(lstResult);
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getAllCategory() error :"
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		} else if ("getAllBigCat".equals(actionType)) {
			SaleReport saleReport = (SaleReport) o[0]; 
			try {
				StringBuffer sql = new StringBuffer(
					"SELECT gcid,gcname from inf_goodscat where length(GCID)=2 ");
					
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sql.append(" and gcsgcode = '").append(
							saleReport.getGssgcode()).append("'");
				}
				log.info(sql);
				List lstResult = dao.executeSql(sql.toString());
				log.debug("SaleSummaryImpl.getAllCategory() lstResult 1 :"
						+ lstResult);
				if (lstResult != null) {
					log
							.debug("SaleSummaryImpl.getAllCategory() lstResult.size() 1 :"
									+ lstResult.size());
					result.setReturnCode(Constants.SUCCESS_FLAG);
					result.setRows(lstResult);
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getAllCategory() error :"
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		} else if ("getSaleCategory".equals(actionType)) {
			try {
				SaleReport saleReport = (SaleReport) o[0];
				String goodssaleTable="YW_GOODSSALE"+saleReport.getGssgcode();
				boolean flag=saleReport.getGssgcode().equals("3009");
				boolean flag_3010=saleReport.getGssgcode().equals("3010");
				boolean flag_3018=saleReport.getGssgcode().equals("3018");
				StringBuffer sumSql = null;
                 if(flag){
                	  sumSql = new StringBuffer(
                			 "SELECT cast('合计' as varchar2(30)) GCID,SUM(GSXSSL) GSXSSL,round(SUM(S.GSHSJJJE),2) GSHSJJJE ,round(SUM(S.GSXSJE),2) GSXSSR ,(CASE WHEN SUM(S.GSXSJE) IS NULL OR SUM(S.GSXSJE)=0 THEN '0.00%' ELSE ROUND((SUM(S.GSXSJE)-SUM(S.GSHSJJJE))/SUM(S.GSXSJE)*100,2)||'%' END) MLL "
                			 +"from "+goodssaleTable+" S left join INF_GOODS_JM G on S.GSGDID = G.GDID and S.GSSGCODE = G.GDSGCODE  and G.GDSUPID=S.GSSUPID and G.GDMFID=S.GSMFID left join INF_GOODSCAT_JM C on G.GDCATID = C.GCID and G.GDSGCODE = C.GCSGCODE AND G.GDSUPID=C.GCSUPID and G.GDMFID=C.GCMFID where 1 = 1");
                	 
                 }else if("3006".equals(saleReport.getGssgcode())){
                	 sumSql = new StringBuffer(
                			 "SELECT cast('合计' as varchar2(30)) GCID,SUM(GSXSSL) GSXSSL,round(SUM(S.GSXSSR),2) GSXSSR,round(SUM(S.GSHSJJJE),2) GSHSJJJE "
                			 +"from YW_GOODSSALE S left join INF_GOODS G on S.GSGDID = G.GDID and S.GSSGCODE = G.GDSGCODE left join INF_GOODSCAT C on substr(G.GDCATID,0,2) = C.GCID and G.GDSGCODE = C.GCSGCODE where 1 = 1");
                 }else if(flag_3010){
                	 sumSql = new StringBuffer(
                			 "SELECT cast('合计' as varchar2(30)) GCID,SUM(GSXSSL) GSXSSL,round(SUM(S.GSXSSR),2) GSXSSR,round(SUM(S.GSHSJJJE),2) GSHSJJJE "
                			 +"from YW_GOODSSALE_M S left join INF_GOODS G on S.GSGDID = G.GDID and S.GSSGCODE = G.GDSGCODE left join INF_GOODSCAT C on G.GDCATID = C.GCID and G.GDSGCODE = C.GCSGCODE where 1 = 1");
                 }else{
                	 sumSql = new StringBuffer(
                			 "SELECT cast('合计' as varchar2(30)) GCID,SUM(GSXSSL) GSXSSL,round(SUM(S.GSXSJE),2) GSXSSR,round(SUM(S.GSHSJJJE),2) GSHSJJJE ,round(SUM(S.GSXSSR),2) XSSR,round(SUM(S.GSVENDREBATE),2) GSVENDREBATE "
                			 +"from "+goodssaleTable+" S left join INF_GOODS G on S.GSGDID = G.GDID and S.GSSGCODE = G.GDSGCODE left join INF_GOODSCAT C on G.GDCATID = C.GCID and G.GDSGCODE = C.GCSGCODE where 1 = 1");
                	 
                 }
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				if("3006".equals(saleReport.getGssgcode())){
					if ("S".equals(saleReport.getUserType().toString())) {
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							sumSql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
						}
					}
				}else {
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						if(flag){
							sumSql.append(" and substr(S.GSSUPID,0,3) = '").append(saleReport.getSupcode()).append("'");
						}else{
							sumSql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
						}
					}
				}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					log.debug("saleReport.getGsmfid(): "
							+ saleReport.getGsmfid());
					sumSql.append(" and S.GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsgcid())) {
					log.debug("saleReport.getGsgcid(): "
							+ saleReport.getGsgcid());
					if(!flag_3018){
						sumSql.append(" and C.GCID = '").append(
								saleReport.getGsgcid()).append("'");
					}else{
						if(!"所有类别".equals(saleReport.getGsgcid())){
							sumSql.append(" and C.GCID like '").append(
									saleReport.getGsgcid()).append("%'");
						}
					}
				}
				if (!StringUtil.isBlank(saleReport.getGsgcname())) {
					log.debug("saleReport.getGsgdname(): "
							+ saleReport.getGsgcname());
					sumSql.append(" and C.GCNAME like '%").append(
							saleReport.getGsgcname()).append("%'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sumSql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("goodssale.getEndDate(): "
							+ saleReport.getEndDate());
					sumSql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}
//				if("3006".equals(saleReport.getGssgcode())){
//					sumSql.append(" and c.gcid in(01,02,05,06)");
//				}

				log.info(sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());

				if (lstSumResult != null && lstSumResult.size() > 0) {
					StringBuffer countSql = null;
					if(flag){
						 countSql = new StringBuffer(
						"select count(*) from (SELECT C.GCID,C.GCNAME, S.GSSUPID,D.SUPNAME from "+goodssaleTable+" S LEFT JOIN INF_RELATION_JM D ON S.GSSGCODE = D.SGCODE AND SUBSTR(S.GSSUPID, 0, 3) = D.SUPID left join INF_GOODS_JM G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE AND G.GDSUPID=S.GSSUPID and G.GDMFID=S.GSMFID left join INF_GOODSCAT_JM C on G.GDCATID=C.GCID and G.GDSGCODE=C.GCSGCODE AND G.GDSUPID=C.GCSUPID and G.GDMFID=C.GCMFID where 1=1");
						
					}else if("3006".equals(saleReport.getGssgcode())){
						countSql = new StringBuffer(
						"select count(*) from (SELECT GCID from YW_GOODSSALE S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE left join INF_GOODSCAT C on substr(G.GDCATID,0,2) = C.GCID and G.GDSGCODE=C.GCSGCODE where 1=1");                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
					}else if("3022".equals(saleReport.getGssgcode())){
						countSql = new StringBuffer(
						"select count(*) from (SELECT GDCATID,GSSUPID from YW_GOODSSALE S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE left join INF_GOODSCAT C on G.GDCATID=C.GCID and G.GDSGCODE=C.GCSGCODE where 1=1");                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
					}else if(flag_3010){
						countSql = new StringBuffer(
						"select count(*) from (SELECT GCID,GSSUPID from YW_GOODSSALE_M S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE left join INF_GOODSCAT C on G.GDCATID=C.GCID and G.GDSGCODE=C.GCSGCODE where 1=1");
					}else{
						countSql = new StringBuffer(
						"select count(*) from (SELECT GCID,GSSUPID from "+goodssaleTable+" S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE left join INF_GOODSCAT C on G.GDCATID=C.GCID and G.GDSGCODE=C.GCSGCODE where 1=1");
						
					}
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if("3006".equals(saleReport.getGssgcode())){
						if ("S".equals(saleReport.getUserType().toString())) {
							if (!StringUtil.isBlank(saleReport.getSupcode())) {
								log.debug("saleReport.getSupcode(): "
										+ saleReport.getSupcode());
								countSql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
							}
						}
					}else {
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							if(flag){
								countSql.append(" and substr(S.GSSUPID,0,3) = '").append(saleReport.getSupcode()).append("'");
							}else{
								countSql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
							}
						}
					}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						countSql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					} 
					if (!StringUtil.isBlank(saleReport.getGsgcid())) {
						log.debug("saleReport.getGsgcid(): "
								+ saleReport.getGsgcid());
						if(!flag_3018){
							countSql.append(" and C.GCID = '").append(
									saleReport.getGsgcid()).append("'");
						}else{
							if(!"所有类别".equals(saleReport.getGsgcid())){
								countSql.append(" and C.GCID like '").append(
										saleReport.getGsgcid()).append("%'");
							}
						}
					}
					if (!StringUtil.isBlank(saleReport.getGsgcname())) {
						log.debug("saleReport.getGsgdname(): "
								+ saleReport.getGsgcname());
						countSql.append(" and C.GCNAME like '%").append(
								saleReport.getGsgcname()).append("%'");
					}
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						countSql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate()).append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("goodssale.getEndDate(): "
								+ saleReport.getEndDate());
						countSql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}
					if("3006".equals(saleReport.getGssgcode())){
						countSql.append(" group by GCID) temp1");
					}else if ("3022".equals(saleReport.getGssgcode())) {
						countSql.append(" group by GDCATID,GSSUPID) temp1");
					}else if(flag){
						countSql.append(" group by C.GCID,C.GCNAME, S.GSSUPID,D.SUPNAME) temp1");
					}else{
						countSql.append(" group by GCID,GSSUPID) temp1");
					}
					log.info(countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log.info(lstResult.get(0));
					log.debug("SaleCategoryImpl.getSaleCategory() lstResult : "
									+ lstResult);

					if (lstResult != null) {
						log.debug("SaleCategoryImpl.getSaleCategory() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}

					StringBuffer sql = null;
					if(flag){
						 sql = new StringBuffer(
								"select C.GCID,C.GCNAME,SUM(S.GSXSSL) GSXSSL,sum(S.GSXSSR)GSXSSR,"
								+"SUM(S.GSHSJJJE) GSHSJJJE,(CASE WHEN SUM(S.GSXSSR) IS NULL OR SUM(S.GSXSSR)=0 THEN '0.00%' ELSE ROUND((SUM(S.GSXSSR)-SUM(S.GSHSJJJE))/SUM(S.GSXSSR)*100,2)||'%' END)MLL,S.GSSUPID,D.SUPNAME from "+goodssaleTable+" S "
								+"LEFT JOIN INF_relation_jm  D ON S.GSSGCODE=D.SGCODE AND SUBSTR(S.GSSUPID,0,3)=D.SUPID left join INF_GOODS_JM G on S.GSGDID=G.GDID "
								+"and S.GSSGCODE=G.GDSGCODE and G.GDSUPID=S.GSSUPID and G.GDMFID=S.GSMFID left join INF_GOODSCAT_JM C on G.GDCATID=C.GCID and G.GDSGCODE=C.GCSGCODE AND G.GDSUPID=C.GCSUPID and G.GDMFID=C.GCMFID where 1=1");
						
					}else if("3006".equals(saleReport.getGssgcode())){
						sql = new StringBuffer(
								"select C.GCID,C.GCNAME,SUM(S.GSXSSL) GSXSSL,sum(S.GSXSSR)GSXSSR,"
								+"SUM(S.GSHSJJJE) GSHSJJJE from YW_GOODSSALE S "
								+"left join INF_GOODS G on S.GSGDID=G.GDID "
								+"and S.GSSGCODE=G.GDSGCODE left join INF_GOODSCAT C on substr(G.GDCATID,0,2) = C.GCID and G.GDSGCODE=C.GCSGCODE where 1=1");
					}else if(flag_3010){
						sql = new StringBuffer(
								"select C.GCID,C.GCNAME,SUM(S.GSXSSL) GSXSSL,sum(S.GSXSSR)GSXSSR,"
								+"SUM(S.GSHSJJJE) GSHSJJJE,S.GSSUPID,D.SUPNAME from YW_GOODSSALE_M S "
								+"LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID left join INF_GOODS G on S.GSGDID=G.GDID "
								+"and S.GSSGCODE=G.GDSGCODE left join INF_GOODSCAT C on G.GDCATID=C.GCID and G.GDSGCODE=C.GCSGCODE where 1=1 ");
					}else if("3022".equals(saleReport.getGssgcode())){
						sql = new StringBuffer(
								"select G.GDCATID as GCID,C.GCNAME,SUM(S.GSXSSL) GSXSSL,sum(S.GSXSJE)GSXSSR,"
								+"SUM(S.GSHSJJJE) GSHSJJJE,S.GSSUPID,D.SUPNAME from YW_GOODSSALE S "
								+"LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID left join INF_GOODS G on S.GSGDID=G.GDID "
								+"and S.GSSGCODE=G.GDSGCODE left join INF_GOODSCAT C on G.GDCATID=C.GCID and G.GDSGCODE=C.GCSGCODE where 1=1 and S.GSXSSL!=0");
						
					}else{
						sql = new StringBuffer(
								"select C.GCID,C.GCNAME,SUM(S.GSXSSL) GSXSSL,sum(S.GSXSJE)GSXSSR,"
								+"SUM(S.GSHSJJJE) GSHSJJJE,SUM(S.GSXSSR) XSSR,round(SUM(S.GSVENDREBATE),2) GSVENDREBATE,S.GSSUPID,D.SUPNAME ,S.TEMP5 from "+goodssaleTable+" S "
								+"LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID left join INF_GOODS G on S.GSGDID=G.GDID "
								+"and S.GSSGCODE=G.GDSGCODE left join INF_GOODSCAT C on G.GDCATID=C.GCID and G.GDSGCODE=C.GCSGCODE where 1=1 and S.GSXSSL!=0");
						
					}
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1)
							* saleReport.getRows();
					log.debug("start: " + start);

					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if("3006".equals(saleReport.getGssgcode())){
						if ("S".equals(saleReport.getUserType().toString())) {
							if (!StringUtil.isBlank(saleReport.getSupcode())) {
								log.debug("saleReport.getSupcode(): "
										+ saleReport.getSupcode());
								sql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
								}
						}
					}else {
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							if(flag){
								sql.append(" and SUBSTR(S.GSSUPID,0,3) = '").append(saleReport.getSupcode()).append("'");
							}else{
								sql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
							}
							}
					}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						sql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					} 
					if (!StringUtil.isBlank(saleReport.getGsgcid())) {
						log.debug("saleReport.getGsgcid(): "
								+ saleReport.getGsgcid());
						if(!flag_3018){
							sql.append(" and C.GCID = '").append(
									saleReport.getGsgcid()).append("'");
						}else{
							if(!"所有类别".equals(saleReport.getGsgcid())){
								sql.append(" and C.GCID like '").append(
										saleReport.getGsgcid()).append("%'");
							}
						}
					}
					if (!StringUtil.isBlank(saleReport.getGsgcname())) {
						log.debug("saleReport.getGsgdname(): "
								+ saleReport.getGsgcname());
						sql.append(" and C.GCNAME like '%").append(
								saleReport.getGsgcname()).append("%'");
					}
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						sql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate()).append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("goodssale.getEndDate(): "
								+ saleReport.getEndDate());
						sql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}
					if("3006".equals(saleReport.getGssgcode())){
						sql.append(" group by GCID,C.GCNAME");
						sql.append(" order by C.GCID");
					}else if ("3022".equals(saleReport.getGssgcode())) {
						sql.append(" group by G.GDCATID,C.GCNAME,S.GSSUPID,D.SUPNAME ");
						sql.append(" order by G.GDCATID asc");
					}else{
					sql.append(" group by GCID,C.GCNAME,S.GSSUPID,D.SUPNAME ,S.TEMP5 ");
					sql.append(" order by C.GCID desc");
					}
					log.info(sql);
					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleCategoryImpl.getSaleCategory() lstResult 1 :"
									+ lstResult);
					if (lstResult != null) {
						log.debug("SaleCategoryImpl.getSaleCategory() lstResult.size() 1 :"
										+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setRows(lstResult);
						result.setFooter(lstSumResult);
					}
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getSaleCategory() error :"+ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		}else if ("getSaleCategoryDetail".equals(actionType)) {
			try {
				SaleReport saleReport = (SaleReport) o[0];
				String goodssaleTable="YW_GOODSSALE"+saleReport.getGssgcode();
				StringBuffer sumSql =new StringBuffer("SELECT CAST('合计' AS VARCHAR2(30)) GDID,SUM(S.GSXSSL)GSXSSL,SUM(S.GSXSSR)GSXSSR,SUM(GSHSJJJE)GSHSJJJE,(CASE WHEN SUM(S.GSXSSR) IS NULL OR SUM(S.GSXSSR)=0 THEN '0.00%' ELSE ROUND((SUM(S.GSXSSR)-SUM(S.GSHSJJJE))/SUM(S.GSXSSR)*100,2)||'%' END) MLL FROM "+goodssaleTable+" S LEFT JOIN INF_RELATION_JM D ON S.GSSGCODE = D.SGCODE AND SUBSTR(S.GSSUPID, 0, 3) = D.SUPID LEFT JOIN INF_GOODS_JM G ON S.GSGDID = G.GDID  AND S.GSSGCODE = G.GDSGCODE   AND G.GDSUPID = S.GSSUPID  AND G.GDMFID = S.GSMFID LEFT JOIN INF_GOODSCAT_JM C  ON G.GDCATID = C.GCID AND G.GDSGCODE = C.GCSGCODE AND G.GDSUPID = C.GCSUPID  AND G.GDMFID = C.GCMFID WHERE 1=1"); 
                  
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql.append(" AND S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
							sumSql.append(" AND S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
				    }
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					log.debug("saleReport.getGsmfid(): "
							+ saleReport.getGsmfid());
					sumSql.append(" AND S.GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsgcid())) {
					log.debug("saleReport.getGsgcid(): "
							+ saleReport.getGsgcid());
						sumSql.append(" ANd C.GCID = '").append(
								saleReport.getGsgcid()).append("'");
				}
				
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sumSql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("goodssale.getEndDate(): "
							+ saleReport.getEndDate());
					sumSql.append(" AND S.GSRQ <= TO_DATE('").append(
							saleReport.getEndDate()).append("','YYYY-MM-DD')");
				}
				log.info(sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());

				if (lstSumResult != null && lstSumResult.size() > 0) {
					StringBuffer countSql =new StringBuffer("SELECT COUNT(*) FROM ( SELECT S.GSGDID,G.GDNAME,C.GCNAME,C.GCID,D.SUPID,D.SUPNAME,S.GSMFID FROM YW_GOODSSALE S LEFT JOIN INF_RELATION_JM D ON S.GSSGCODE = D.SGCODE AND SUBSTR(S.GSSUPID, 0, 3) = D.SUPID LEFT JOIN INF_GOODS_JM G ON S.GSGDID = G.GDID  AND S.GSSGCODE = G.GDSGCODE   AND G.GDSUPID = S.GSSUPID  AND G.GDMFID = S.GSMFID LEFT JOIN INF_GOODSCAT_JM C  ON G.GDCATID = C.GCID AND G.GDSGCODE = C.GCSGCODE AND G.GDSUPID = C.GCSUPID  AND G.GDMFID = C.GCMFID WHERE 1=1 ");
						
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" AND S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
				
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
								countSql.append(" and S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
						}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						countSql.append(" AND S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					} 
					if (!StringUtil.isBlank(saleReport.getGsgcid())) {
						log.debug("saleReport.getGsgcid(): "
								+ saleReport.getGsgcid());
							countSql.append(" AND C.GCID = '").append(
									saleReport.getGsgcid()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						countSql.append(" AND S.GSRQ >= TO_DATE('").append(
								saleReport.getStartDate()).append("','YYYY-MM-DD')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("goodssale.getEndDate(): "
								+ saleReport.getEndDate());
						countSql.append(" and S.GSRQ <= TO_DATE('").append(
								saleReport.getEndDate()).append("','YYYY-MM-DD')");
					}
					countSql.append(" GROUP BY S.GSGDID,G.GDNAME,C.GCNAME,C.GCID,D.SUPID,D.SUPNAME,S.GSMFID	)");
					log.info(countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log.info(lstResult.get(0));
					log.debug("SaleCategoryImpl.getSaleCategory() lstResult : "
									+ lstResult);

					if (lstResult != null) {
						log.debug("SaleCategoryImpl.getSaleCategory() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}

					StringBuffer sql = new StringBuffer("SELECT S.GSGDID,G.GDNAME,C.GCNAME,C.GCID,D.SUPID,D.SUPNAME,s.temp5,S.GSMFID,SUM(S.GSXSSL)GSXSSL,SUM(S.GSXSSR)GSXSSR,SUM(S.GSHSJJJE)GSHSJJJE	,(CASE WHEN SUM(S.GSXSSR) IS NULL OR SUM(S.GSXSSR)=0 THEN '0.00%' ELSE ROUND((SUM(S.GSXSSR)-SUM(S.GSHSJJJE))/SUM(S.GSXSSR)*100,2)||'%' END) MLL FROM YW_GOODSSALE S LEFT JOIN INF_RELATION_JM D ON S.GSSGCODE = D.SGCODE AND SUBSTR(S.GSSUPID, 0, 3) = D.SUPID LEFT JOIN INF_GOODS_JM G ON S.GSGDID = G.GDID  AND S.GSSGCODE = G.GDSGCODE   AND G.GDSUPID = S.GSSUPID  AND G.GDMFID = S.GSMFID LEFT JOIN INF_GOODSCAT_JM C  ON G.GDCATID = C.GCID AND G.GDSGCODE = C.GCSGCODE AND G.GDSUPID = C.GCSUPID  AND G.GDMFID = C.GCMFID WHERE 1=1 ");
						
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1)
							* saleReport.getRows();
					log.debug("start: " + start);

					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" AND S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
								sql.append(" AND S.GSSUPID = '").append(saleReport.getSupcode()).append("'");
							}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						sql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					} 
					if (!StringUtil.isBlank(saleReport.getGsgcid())) {
						log.debug("saleReport.getGsgcid(): "
								+ saleReport.getGsgcid());
							sql.append(" and C.GCID = '").append(
									saleReport.getGsgcid()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						sql.append(" and S.GSRQ >= TO_DATE('").append(
								saleReport.getStartDate()).append("','YYYY-MM-DD')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("goodssale.getEndDate(): "
								+ saleReport.getEndDate());
						sql.append(" AND S.GSRQ <= TO_DATE('").append(
								saleReport.getEndDate()).append("','YYYY-MM-DD')");
					}
					sql.append(" GROUP BY S.GSGDID,G.GDNAME,C.GCNAME,C.GCID,D.SUPID,D.SUPNAME,S.GSMFID ,s.temp5 ");
					log.info(sql);
					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleCategoryImpl.getSaleCategoryDetail() lstResult 1 :"
									+ lstResult);
					if (lstResult != null) {
						log.debug("SaleCategoryImpl.getSaleCategoryDetail() lstResult.size() 1 :"
										+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setRows(lstResult);
						result.setFooter(lstSumResult);
					}
			} }catch (Exception ex) {
				log.error("SaleSummaryImpl.getSaleCategoryDetail() error :"+ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		}else if ("getSaleCategory_YPDM".equals(actionType)) {
			try {
				SaleReport saleReport = (SaleReport) o[0];
				StringBuffer sumSql =  new StringBuffer(
                			 "SELECT cast('合计' as varchar2(30)) GCID,SUM(GSXSSL) GSXSSL,round(SUM(S.GSXSSR),2) GSXSSR,round(SUM(S.GSHSJJJE),2) GSHSJJJE "
                			 +"from YW_GOODSSALE_M S left join INF_GOODS G on S.GSGDID = G.GDID and S.GSSGCODE = G.GDSGCODE left join INF_GOODSCAT C on G.GDCATID = C.GCID and G.GDSGCODE = C.GCSGCODE where 1 = 1");
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
					log.debug("saleReport.getSupcode(): "
							+ saleReport.getSupcode());
					sumSql.append(" and S.GSSUPID = '").append(
							saleReport.getSupcode()).append("'");
					}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					log.debug("saleReport.getGsmfid(): "
							+ saleReport.getGsmfid());
					sumSql.append(" and S.GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsgcid())) {
					log.debug("saleReport.getGsgcid(): "
							+ saleReport.getGsgcid());
						sumSql.append(" and C.GCID like '").append(
								saleReport.getGsgcid()).append("%'");
				}
				if (!StringUtil.isBlank(saleReport.getGsgcname())) {
					log.debug("saleReport.getGsgdname(): "
							+ saleReport.getGsgcname());
					sumSql.append(" and C.GCNAME like '%").append(
							saleReport.getGsgcname()).append("%'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sumSql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("goodssale.getEndDate(): "
							+ saleReport.getEndDate());
					sumSql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}

				log.info(sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());

				if (lstSumResult != null && lstSumResult.size() > 0) {
					StringBuffer countSql = new StringBuffer(
						"select count(*) from (SELECT GCID,GSSUPID from YW_GOODSSALE_M S LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE left join INF_GOODSCAT C on G.GDCATID=C.GCID and G.GDSGCODE=C.GCSGCODE where 1=1");
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							countSql.append(" and S.GSSUPID = '").append(
									saleReport.getSupcode()).append("'");
						}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						countSql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					} 
					if (!StringUtil.isBlank(saleReport.getGsgcid())) {
						log.debug("saleReport.getGsgcid(): "
								+ saleReport.getGsgcid());
							countSql.append(" and C.GCID like '").append(
									saleReport.getGsgcid()).append("%'");
					}
					if (!StringUtil.isBlank(saleReport.getGsgcname())) {
						log.debug("saleReport.getGsgdname(): "
								+ saleReport.getGsgcname());
						countSql.append(" and C.GCNAME like '%").append(
								saleReport.getGsgcname()).append("%'");
					}
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						countSql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate()).append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("goodssale.getEndDate(): "
								+ saleReport.getEndDate());
						countSql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}
						countSql.append(" group by GCID,GSSUPID) temp1");
					log.info(countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log.info(lstResult.get(0));
					log.debug("SaleCategoryImpl.getSaleCategory() lstResult : "
									+ lstResult);

					if (lstResult != null) {
						log.debug("SaleCategoryImpl.getSaleCategory() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}

					StringBuffer sql = new StringBuffer(
								"select C.GCID,C.GCNAME,SUM(S.GSXSSL) GSXSSL,sum(S.GSXSSR)GSXSSR,"
								+"SUM(S.GSHSJJJE) GSHSJJJE,S.GSSUPID,D.SUPNAME from YW_GOODSSALE_M S "
								+"LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID left join INF_GOODS G on S.GSGDID=G.GDID "
								+"and S.GSSGCODE=G.GDSGCODE left join INF_GOODSCAT C on G.GDCATID=C.GCID and G.GDSGCODE=C.GCSGCODE where 1=1 ");
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1)
							* saleReport.getRows();
					log.debug("start: " + start);

					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						sql.append(" and S.GSSUPID = '").append(
								saleReport.getSupcode()).append("'");
						}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						sql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					} 
					if (!StringUtil.isBlank(saleReport.getGsgcid())) {
						log.debug("saleReport.getGsgcid(): "
								+ saleReport.getGsgcid());
							sql.append(" and C.GCID like '").append(
									saleReport.getGsgcid()).append("%'");
					}
					if (!StringUtil.isBlank(saleReport.getGsgcname())) {
						log.debug("saleReport.getGsgdname(): "
								+ saleReport.getGsgcname());
						sql.append(" and C.GCNAME like '%").append(
								saleReport.getGsgcname()).append("%'");
					}
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						sql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate()).append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("goodssale.getEndDate(): "
								+ saleReport.getEndDate());
						sql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}
					sql.append(" group by GCID,C.GCNAME,S.GSSUPID,D.SUPNAME ");
					sql.append(" order by C.GCID desc");
					log.info(sql);
					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleCategoryImpl.getSaleCategory() lstResult 1 :"
									+ lstResult);
					if (lstResult != null) {
						log.debug("SaleCategoryImpl.getSaleCategory() lstResult.size() 1 :"
										+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setRows(lstResult);
						result.setFooter(lstSumResult);
					}
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getSaleCategory() error :"+ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		}else if("getSaleStore".equals(actionType)){
			try{
				SaleReport saleReport = (SaleReport) o[0]; 
				StringBuffer sql = null;
				if("3012".equals(saleReport.getGssgcode())){
					sql = new StringBuffer("SELECT P.SHPCODE,S.GSSUPID,D.SUPNAME,P.SHPNAME,SUM(S.GSXSSL) AS GSXSSL,SUM(S.GSXSJE) GSXSJE,SUM(S.GSHSJJJE) AS GSHSJJJE,SUM(S.GSXSSR) AS GSXSSR FROM YW_GOODSSALE S LEFT JOIN INF_SHOP P ON S.GSMFID=P.SHPCODE AND S.GSSGCODE = P.SGCODE LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID  WHERE 1=1 and S.GSXSSL != 0");
				}else{
					sql = new StringBuffer("SELECT P.SHPCODE,S.GSSUPID,D.SUPNAME,P.SHPNAME,s.temp5,SUM(S.GSXSSL) AS GSXSSL,SUM(S.GSXSJE) GSXSJE,SUM(S.GSHSJJJE) AS GSHSJJJE,SUM(S.GSXSSR) AS GSXSSR FROM YW_GOODSSALE S LEFT JOIN INF_SHOP P ON S.GSMFID=P.SHPCODE AND S.GSSGCODE = P.SGCODE LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID  WHERE 1=1");
				}
		int limit = 5;
		log.debug("limit: " + limit);
		int start = (saleReport.getPage() - 1) * saleReport.getRows();
		log.debug("start: " + start);
		if (!StringUtil.isBlank(saleReport.getGssgcode())) {
			log.debug("saleReport.getGssgcode(): "
					+ saleReport.getGssgcode());
			sql.append(" and S.GSSGCODE = '").append(
					saleReport.getGssgcode()).append("'");
		}
		if (!StringUtil.isBlank(saleReport.getSupcode())) {
			log.debug("saleReport.getSupcode(): "
					+ saleReport.getSupcode());
			sql.append(" and S.GSSUPID = '").append(
					saleReport.getSupcode()).append("'");
		}
	
		
		if (!StringUtil.isBlank(saleReport.getEndDate())) {
			log.debug("goodssale.getEndDate(): "
					+ saleReport.getEndDate());
			sql.append(" and S.GSRQ = to_date('").append(
					saleReport.getEndDate()).append("','yyyy-MM-dd')");
		}
		sql.append(" GROUP BY P.SHPCODE,P.SHPNAME,S.GSSUPID,SUPNAME,s.temp5 order by GSXSSR DESC");
		log.info("saleShopResultSql: " + sql);
		List lstResult = dao.executeSql(sql.toString(), start, limit);
		log.debug("SaleSummaryImpl.getResult() lstResult 1 :"
				+ lstResult);
				
				if( lstResult != null ){
					
					result.setReturnCode( Constants.SUCCESS_FLAG );
					result.setRows( lstResult );
				}
				
				StringBuffer sumSql  = new StringBuffer(
					"select cast('合计' as varchar2(32)) SHPCODE, SUM(GSXSSL) AS GSXSSL,round(SUM(GSXSJE),2)GSXSJE,round(SUM(GSHSJJJE),2) AS GSHSJJJE,round(SUM(GSXSSR),2) AS GSXSSR from ( SELECT P.SHPCODE,S.GSSUPID,D.SUPNAME,P.SHPNAME,SUM(S.GSXSSL) AS GSXSSL,SUM(S.GSXSJE) GSXSJE,SUM(S.GSHSJJJE) AS GSHSJJJE,SUM(S.GSXSSR) AS GSXSSR FROM YW_GOODSSALE S LEFT JOIN INF_SHOP P ON S.GSMFID=P.SHPCODE AND S.GSSGCODE = P.SGCODE LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID  WHERE 1=1 ");
				
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getSupcode())) {
					log.debug("saleReport.getSupcode(): "
							+ saleReport.getSupcode());
					sumSql.append(" and S.GSSUPID = '").append(
							saleReport.getSupcode()).append("'");
				}
				
				
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("goodssale.getEndDate(): "
							+ saleReport.getEndDate());
					sumSql.append(" and S.GSRQ = to_date('").append(
							saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}
				sumSql.append(" GROUP BY P.SHPCODE,P.SHPNAME,S.GSSUPID,SUPNAME order by GSXSSR DESC) WHERE ROWNUM <= 5");
				log.info("saleShopSumSql: " + sumSql);
				lstResult = dao.executeSql(sumSql.toString());
				log.debug("shpsum:" + lstResult);
				if( lstResult != null && lstResult.size() > 0 ){
					result.setFooter( lstResult );
				}
				
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getResult() error :" + ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
			return result;
			
		}else if("getGDLHZ".equals(actionType)){
			SaleReport saleReport = (SaleReport) o[0];
			String param = "";
			SimpleDateFormat dateformat1=new SimpleDateFormat("yyyy-MM-dd");
			String createTime=dateformat1.format(new Date());
			String temp="";
			String searchDate = saleReport.getStartDate().replace(".","-");
			if(!searchDate.equals(createTime.subSequence(1,7))){
				temp="select * from yw_gdltj where GZRQ='"+saleReport.getStartDate()+"'";
				if(dao.executeSql(temp).size()>0){
					String temp2 = "select to_char(max(createtime),'yyyy-mm-dd') from yw_gdltj where GZRQ='"+saleReport.getStartDate()+"'";
					createTime = dao.executeSqlCount(temp2).get(0).toString();
				}
			}else{
				temp = "select csbm from yw_gdltj where to_char(createtime,'yyyy-mm-dd')='"+createTime+"'";
				List temp1 = dao.executeSql(temp);
				if(temp1.size()==0){//今天没有抽数据，显示昨天的数据
					createTime=this.getSpecifiedDayBefore(createTime);
				}
			}
			if (!StringUtil.isBlank(saleReport.getGssgcode())){
				param += " and sgcode='"+saleReport.getGssgcode()+"'";
			}
			if(!StringUtil.isBlank(saleReport.getGysbm())){
				param += " and csbm = '"+saleReport.getGysbm()+"'";
			}
			if("S".equalsIgnoreCase(saleReport.getUserType())){
				param += " and csbm = '"+saleReport.getSupcode()+"'";
			}
			if (!StringUtil.isBlank(saleReport.getStartDate())) {
				param += " and GZRQ = '"+saleReport.getStartDate()+"'";
			}
			String sql = "select a.*,sup.supname from (select sgcode,csbm,(sykcsl+byrksl-byxssl) bykcsl,"
					   + "(bykcje)bykcje,byxssl,byxssr,byxscb,(byxssr-byxscb)ml,"
					   + "round((case byxssr when 0 then 0 else (byxssr-byxscb)*100/byxssr end),2) || '%' mll, "
					   + "sykcsl,sykcje,byrksl,byrkje from yw_gdltj where 1= 1 "+param+" and to_char(createtime,'yyyy-mm-dd')='"+createTime+"') a,inf_supinfo sup "
					   + "where a.csbm=sup.supid and a.sgcode=sup.supsgcode ";
			if( saleReport.getOrder() != null && saleReport.getSort() != null ){
				sql +="order by " + saleReport.getSort()+" "+saleReport.getOrder();
			}
			/*
			String sql = "select b.*,round((case byxssr when 0 then 0 else b.ml * 100 / byxssr end),2) || '%' mll "
					   + "from (select csbm,sup.supname,sum(bykcsl) bykcsl,sum(bykcje) bykcje,sum(byxssl) byxssl,sum(byxssr) byxssr,"
					   + "sum(byxscb) byxscb,sum(ml) ml,sum(sykcsl) sykcsl,sum(sykcje) sykcje,sum(byrksl) byrksl,sum(byrkje) byrkje "
					   + "from (select csbm,sgcode,byxssl,byxssr,byxscb,(byxssr - byxscb) ml,(sykcsl + byrksl - byxssl) bykcsl,(sykcje + byrksl * byjj - byxscb) bykcje,"
					   + "byrksl,(byrksl * byjj) byrkje,sykcsl,sykcje from yw_gdlhz where 1 = 1 "+param+") a,inf_supinfo sup where a.csbm = sup.supid and a.sgcode = sup.supsgcode group by csbm, sup.supname) b";
			*/
			
			//查询总条数
			String countSql = "select count(*) from ("+sql+")";
			List countList = dao.executeSqlCount(countSql);
		
			//统计
			String sumsql = "select b.*,round(case byxssr when 0 then 0 else ml*100/byxssr end,2)||'%' mll "
						  + "from (select cast('合计' as varchar2(20)) csbm,round(sum(bykcsl),2)bykcsl,round(sum(bykcje),2)bykcje,"
						  + "round(sum(byxssl),2)byxssl,round(sum(byxssr),2)byxssr,round(sum(byxscb),2)byxscb,round(sum(ml),2)ml,round(sum(sykcsl),2)sykcsl,"
						  + "round(sum(sykcje),2)sykcje,round(sum(byrksl),2)byrksl,round(sum(byrkje),2)byrkje from ("+sql+"))b";

			List sumList = dao.executeSql(sumsql);
			//分页
			int limit = saleReport.getRows();
			int start = (saleReport.getPage() - 1)* saleReport.getRows();
			List resultList = dao.executeSql(sql, start, limit);
			
			if (countList != null) {
				result.setReturnCode(Constants.SUCCESS_FLAG);
				result.setTotal(Integer.parseInt(countList.get(0).toString()));
				result.setRows(resultList);
				result.setFooter(sumList);
			}
		}else if("getGDLMDHZ".equals(actionType)){
			String param = "";
			SaleReport saleReport = (SaleReport) o[0];
			if (!StringUtil.isBlank(saleReport.getGssgcode())){
				param += " and a.sgcode='"+saleReport.getGssgcode()+"'";
			}
			if(!StringUtil.isBlank(saleReport.getGysbm())){
				param += " and a.csbm = '"+saleReport.getGysbm()+"'";
			}
			if("S".equalsIgnoreCase(saleReport.getUserType())){
				param += " and a.csbm = '"+saleReport.getSupcode()+"'";
			}
			if (!StringUtil.isBlank(saleReport.getStartDate())) {
				param += " and a.GZRQ = '"+saleReport.getStartDate()+"'";
			}if (!StringUtil.isBlank(saleReport.getGsmfid())) {
				param += " and a.CWBM = '"+saleReport.getGsmfid()+"'";
			}
			String sql = "select cwbm,b.shpname,round(sum(SYKCSL),2)SYKCSL,round(sum(SYKCJE),2)SYKCJE,round(sum(SYKCSL+BYRKSL-BYXSSL),2)BYKCSL,round(sum(BYKCJE),2)BYKCJE,"
					   + "round(sum(BYXSSL),2)BYXSSL,round(sum(BYXSSR),2)BYXSJE,round(sum(BYXSCB),2)BYXSCB ,round(sum(BYXSSR-BYXSCB),2) ml,round((case sum(BYXSSR) "
					   + "when 0 then 0.00 else (sum(BYXSSR)-sum(BYXSCB))*100/sum(BYXSSR) end),2)||'%' mll ,round(sum(BYRKSl),2)BYRKSL,round(sum(BYRKJE),2)BYRKJE "
					   + "from yw_gdlcwhz a,inf_shop b where a.sgcode = b.sgcode and a.cwbm=b.shpcode "+param+" group by cwbm,b.shpname ";
			if( saleReport.getOrder() != null && saleReport.getSort() != null ){
				sql +="order by " + saleReport.getSort()+" "+saleReport.getOrder();
			}
			//查询总条数	
			String countSql = "select count(*) from ("+sql+")";
			List countList = dao.executeSqlCount(countSql);
		
			String sql1 = "select cwbm,b.shpname,sum(SYKCSL)SYKCSL,sum(SYKCJE)SYKCJE,sum(SYKCSL+BYRKSL-BYXSSL)BYKCSL,sum(BYKCJE)BYKCJE,"
				   + "sum(BYXSSL)BYXSSL,sum(BYXSSR)BYXSJE,sum(BYXSCB)BYXSCB ,sum(BYXSSR-BYXSCB)ml,round((case sum(BYXSSR) "
				   + "when 0 then 0.00 else (sum(BYXSSR)-sum(BYXSCB))*100/sum(BYXSSR) end),2)||'%' mll ,sum(BYRKSl)BYRKSL,sum(BYRKJE)BYRKJE "
				   + "from yw_gdlcwhz a,inf_shop b where a.sgcode = b.sgcode and a.cwbm=b.shpcode "+param+" group by cwbm,b.shpname order by cwbm";
			//统计
			String sumsql = "select cast('合计' as varchar2(20))CWBM,round(sum(SYKCSL),2)SYKCSL,round(sum(SYKCJE),2)SYKCJE,round(sum(SYKCSL+BYRKSL-BYXSSL),2)BYKCSL,round(sum(BYKCJE),2)BYKCJE,"
						  + "round(sum(BYXSSL),2)BYXSSL,round(sum(BYXSJE),2)BYXSJE,round(sum(BYXSCB),2)BYXSCB ,round(sum(BYXSJE-BYXSCB),2) ml,round((case sum(BYXSJE) "
						  + "when 0 then 0.00 else (sum(BYXSJE)-sum(BYXSCB))*100/sum(BYXSJE) end),2)||'%' mll ,round(sum(BYRKSl),2)BYRKSL,round(sum(BYRKJE),2)BYRKJE from("+sql1+")";
			List sumList = dao.executeSql(sumsql);
			//分页
			int limit = saleReport.getRows();
			int start = (saleReport.getPage() - 1)* saleReport.getRows();
			List resultList = dao.executeSql(sql, start, limit);
			
			if (countList != null) {
				result.setReturnCode(Constants.SUCCESS_FLAG);
				result.setTotal(Integer.parseInt(countList.get(0).toString()));
				result.setRows(resultList);
				result.setFooter(sumList);
			}
			
		}else if("getGDLSPHZ".equals(actionType)){
			String param = "";
			SaleReport saleReport = (SaleReport) o[0];
			if (!StringUtil.isBlank(saleReport.getGssgcode())){
				param += " and yw.sgcode='"+saleReport.getGssgcode()+"'";
			}
			if(!StringUtil.isBlank(saleReport.getGysbm())){
				param += " and yw.csbm = '"+saleReport.getGysbm()+"'";
			}
			if("S".equalsIgnoreCase(saleReport.getUserType())){
				param += " and yw.csbm = '"+saleReport.getSupcode()+"'";
			}
			if (!StringUtil.isBlank(saleReport.getStartDate())) {
				param += " and yw.GZRQ = '"+saleReport.getStartDate()+"'";
			}if (!StringUtil.isBlank(saleReport.getGsmfid())) {
				param += " and yw.CWBM = '"+saleReport.getGsmfid()+"'";
			}
			String sql = "select a.*,b.gdname,b.gdbarcode,b.gdunit from(select yw.sgcode,yw.spbm,sum(sykcsl+byrksl-byxssl)bykcsl,"
				       + "sum(bykcje)bykcje,sum(byxssl)byxssl,sum(byxssr)BYXSJE,sum(byxscb)byxscb,(sum(byxssr)-sum(byxscb))ml,"
				       + "round(decode(sum(byxssr),0,0,(sum(byxssr)-sum(byxscb))/sum(byxssr)),2)*100 || '%' mll,sum(sykcsl)sykcsl,sum(sykcje)sykcje,"
				       + "sum(byrksl)byrksl,sum(byrkje)byrkje from yw_gdlcwhz yw where 1=1 "+param+" group by yw.sgcode,yw.spbm)a,inf_goods b "
				       + "where a.sgcode=b.gdsgcode and a.spbm=b.gdid ";

			if( saleReport.getOrder() != null && saleReport.getSort() != null ){
				sql +="order by " + saleReport.getSort()+" "+saleReport.getOrder();
			}
			//查询总条数
			String countSql = "select count(*) from ("+sql+")";
			List countList = dao.executeSqlCount(countSql);

			//统计
			String sumsql = "select cast('合计' as varchar2(20))spbm,round(sum(SYKCSL),2)SYKCSL,round(sum(SYKCJE),2)SYKCJE,round(sum(BYKCSL),2)BYKCSL,round(sum(BYKCJE),2)BYKCJE,"
						  + "round(sum(BYXSSL),2)BYXSSL,round(sum(BYXSJE),2)BYXSJE,round(sum(BYXSCB),2)BYXSCB ,round(sum(BYXSJE-BYXSCB),2) ml,round((case sum(BYXSJE) "
						  + "when 0 then 0.00 else (sum(BYXSJE)-sum(BYXSCB))*100/sum(BYXSJE) end),2)||'%' mll ,round(sum(BYRKSl),2)BYRKSL,round(sum(BYRKJE),2)BYRKJE from("+sql+")";
			List sumList = dao.executeSql(sumsql);
			//分页
			int limit = saleReport.getRows();
			int start = (saleReport.getPage() - 1)* saleReport.getRows();
			List resultList = dao.executeSql(sql, start, limit);
			
			if (countList != null) {
				result.setReturnCode(Constants.SUCCESS_FLAG);
				result.setTotal(Integer.parseInt(countList.get(0).toString()));
				result.setRows(resultList);
				result.setFooter(sumList);
			}
			
		}else if("getGDLCWSPHZ".equals(actionType)){
			String param = "";
			SaleReport saleReport = (SaleReport) o[0];
			if (!StringUtil.isBlank(saleReport.getGssgcode())){
				param += " and yw.sgcode='"+saleReport.getGssgcode()+"'";
			}
			if(!StringUtil.isBlank(saleReport.getGysbm())){
				param += " and yw.csbm = '"+saleReport.getGysbm()+"'";
			}
			if("S".equalsIgnoreCase(saleReport.getUserType())){
				param += " and yw.csbm = '"+saleReport.getSupcode()+"'";
			}
			if (!StringUtil.isBlank(saleReport.getStartDate())) {
				param += " and yw.GZRQ = '"+saleReport.getStartDate()+"'";
			}if (!StringUtil.isBlank(saleReport.getGsmfid())) {
				param += " and yw.CWBM = '"+saleReport.getGsmfid()+"'";
			}
			String sql = "select a.*,b.gdname,b.gdbarcode,b.gdunit,c.shpname from(select yw.sgcode,yw.spbm,yw.cwbm,sum(sykcsl+byrksl-byxssl)bykcsl,"
				       + "sum(bykcje)bykcje,sum(byxssl)byxssl,sum(byxssr)BYXSJE,sum(byxscb)byxscb,(sum(byxssr)-sum(byxscb))ml,"
				       + "round(decode(sum(byxssr),0,0,(sum(byxssr)-sum(byxscb))/sum(byxssr)),2)*100 || '%' mll,sum(sykcsl)sykcsl,sum(sykcje)sykcje,"
				       + "sum(byrksl)byrksl,sum(byrkje)byrkje from yw_gdlcwhz yw where 1=1 "+param+" group by yw.sgcode,yw.cwbm,yw.spbm)a,inf_goods b ,inf_shop c "
				       + "where a.sgcode=b.gdsgcode and a.spbm=b.gdid and a.sgcode = c.sgcode and a.cwbm=c.shpcode ";

			if( saleReport.getOrder() != null && saleReport.getSort() != null ){
				sql +="order by " + saleReport.getSort()+" "+saleReport.getOrder();
			}
			//查询总条数
			String countSql = "select count(*) from ("+sql+")";
			List countList = dao.executeSqlCount(countSql);

			//统计
			String sumsql = "select cast('合计' as varchar2(20))cwbm,round(sum(SYKCSL),2)SYKCSL,round(sum(SYKCJE),2)SYKCJE,round(sum(SYKCSL+BYRKSL-BYXSSL),2)BYKCSL,round(sum(BYKCJE),2)BYKCJE,"
						  + "round(sum(BYXSSL),2)BYXSSL,round(sum(BYXSJE),2)BYXSJE,round(sum(BYXSCB),2)BYXSCB ,round(sum(BYXSJE-BYXSCB),2) ml,round((case sum(BYXSJE) "
						  + "when 0 then 0.00 else (sum(BYXSJE)-sum(BYXSCB))*100/sum(BYXSJE) end),2)||'%' mll ,round(sum(BYRKSl),2)BYRKSL,round(sum(BYRKJE),2)BYRKJE from("+sql+")";
			List sumList = dao.executeSql(sumsql);
			//分页
			int limit = saleReport.getRows();
			int start = (saleReport.getPage() - 1)* saleReport.getRows();
			List resultList = dao.executeSql(sql, start, limit);
			
			if (countList != null) {
				result.setReturnCode(Constants.SUCCESS_FLAG);
				result.setTotal(Integer.parseInt(countList.get(0).toString()));
				result.setRows(resultList);
				result.setFooter(sumList);
			}
			
		}else if("getShopSale_JM".equals(actionType)){
			SaleReport saleReport = (SaleReport) o[0]; 
			try {
				StringBuffer sumSql = new StringBuffer("SELECT CAST('合计' AS VARCHAR(32)) SHPCODE, SUM(S.GSXSSL) GSXSSL,ROUND(SUM(S.GSHSJJJE),2) GSHSJJJE ,ROUND(SUM(S.GSXSSR),2) GSXSJE ,(CASE WHEN SUM(S.GSXSSR) IS NULL OR SUM(S.GSXSSR)=0  THEN '0.00%' ELSE ROUND((SUM(S.GSXSSR)-SUM(S.GSHSJJJE))/SUM(S.GSXSSR)*100,2)||'%' END) MLL FROM YW_GOODSSALE S WHERE 1=1 ");
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getSupcode())) {
					log.debug("saleReport.getSupcode(): "
							+ saleReport.getSupcode());
					sumSql.append(" and substr(S.GSSUPID,0,3) = '").append(
							saleReport.getSupcode()).append("'");
				}
				
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sumSql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log
							.debug("saleReport.getEndDate(): "
									+ saleReport.getEndDate());
					sumSql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}

				
				log.info("saleShopSumSql: " + sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());
				log.debug("shpsum:" + lstSumResult);
				if (lstSumResult != null && lstSumResult.size() > 0) {
					StringBuffer countSql = new StringBuffer(
							"SELECT COUNT(*) FROM  (SELECT SHPCODE,SHPNAME,SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSJE) GSXSJE,GSSUPID,SUPNAME FROM ( SELECT B.GSMFID SHPCODE ,C.SHPNAME SHPNAME,SUM(B.GSXSSL) GSXSSL,ROUND(SUM(B.GSHSJJJE),2) GSHSJJJE,ROUND(SUM(B.GSXSSR),2) GSXSJE,A.SUPID GSSUPID,A.SUPNAME SUPNAME FROM INF_RELATION_JM A LEFT JOIN YW_GOODSSALE B ON A.SGCODE=B.GSSGCODE AND A.SUPID=SUBSTR(B.GSSUPID,0,3) LEFT JOIN INF_SHOP C ON B.GSMFID=C.SHPCODE AND B.GSSGCODE=C.SGCODE WHERE 1=1  ");

					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" and a.SGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						countSql.append(" and a.SUPID = '").append(
								saleReport.getSupcode()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						countSql.append(" and b.GSRQ >= to_date('").append(
								saleReport.getStartDate())
								.append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						countSql.append(" and b.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}

					
					countSql.append("  GROUP BY B.GSMFID,C.SHPNAME,A.SUPID,A.SUPNAME ");
					countSql.append(" UNION ALL SELECT A.SHPCODE ,A.SHPNAME ,0 GSXSSL,0 GSHSJJJE,0 GSXSJE,C.SUPID GSSUPID,C.SUPNAME SUPNAME FROM INF_SHOP A ,INF_RELATION_JM C WHERE  A.SGCODE=C.SGCODE ");
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" and a.SGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						countSql.append(" and c.SUPID = '").append(
								saleReport.getSupcode()).append("'");
					}
					countSql.append(" )GROUP BY SHPCODE,SHPNAME,GSSUPID,SUPNAME )");

					log.info("saleShopCountSql: " + countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log.debug("SaleSummaryImpl.getResult() lstResult : "
							+ lstResult);

					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getResult() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}
					StringBuffer sql = new StringBuffer(" select shpcode,shpname,sum(gsxssl) gsxssl,sum(gshsjjje) gshsjjje,sum(gsxsje) gsxsje,(case when sum(gsxsje) is null or sum(gsxsje)=0 then '0.00%' else round((sum(gsxsje)-sum(gshsjjje))/sum(gsxsje)*100,2)||'%' end) mll, gssupid,supname from ( SELECT B.GSMFID SHPCODE ,C.SHPNAME SHPNAME,SUM(B.GSXSSL) GSXSSL,ROUND(SUM(B.GSHSJJJE),2) GSHSJJJE,ROUND(SUM(B.GSXSSR),2) GSXSJE,A.SUPID GSSUPID,A.SUPNAME SUPNAME FROM INF_RELATION_JM A LEFT JOIN YW_GOODSSALE B ON A.SGCODE=B.GSSGCODE AND A.SUPID=SUBSTR(B.GSSUPID,0,3) LEFT JOIN INF_SHOP C ON B.GSMFID=C.SHPCODE AND B.GSSGCODE=C.SGCODE WHERE 1=1 ");
					
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1) * saleReport.getRows();
					log.debug("start: " + start);
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" and a.SGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						sql.append(" and a.SUPID = '").append(
								saleReport.getSupcode()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						sql.append(" and b.GSRQ >= to_date('").append(
								saleReport.getStartDate())
								.append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						sql.append(" and b.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}
					
					sql.append(" GROUP BY B.GSMFID,C.SHPNAME,A.SUPID,A.SUPNAME");
					sql.append("  UNION ALL SELECT A.SHPCODE ,A.SHPNAME ,0 GSXSSL,0 GSHSJJJE,0 GSXSJE,C.SUPID GSSUPID,C.SUPNAME SUPNAME FROM INF_SHOP A ,INF_RELATION_JM C WHERE A.SGCODE=C.SGCODE  ");
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" and a.SGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						sql.append(" and c.SUPID = '").append(
								saleReport.getSupcode()).append("'");
					}
					sql.append(" ) GROUP BY SHPCODE,SHPNAME,GSSUPID,SUPNAME ");
					log.info("saleShopResultSql: " + sql);
					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleSummaryImpl.getResult() lstResult 1 :"
							+ lstResult);
					if (lstResult != null) {
						log.debug("SaleSummaryImpl.getResult() lstResult.size() :"
								+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setFooter(lstSumResult);
						result.setRows(lstResult);
					}
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getResult() error :" + ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		}else if("getShopSale_lss_JM".equals(actionType)){
			SaleReport saleReport = (SaleReport) o[0]; 
			try {
				StringBuffer sumSql = new StringBuffer("SELECT CAST('合计' AS VARCHAR(32)) SHPCODE, SUM(S.GSXSSL) GSXSSL,ROUND(SUM(S.GSHSJJJE),2) GSHSJJJE ,ROUND(SUM(S.GSXSSR),2) GSXSJE FROM YW_GOODSSALE S WHERE 1=1 ");
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sumSql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log
							.debug("saleReport.getEndDate(): "
									+ saleReport.getEndDate());
					sumSql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}

				
				log.info("saleShopSumSql: " + sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());
				log.debug("shpsum:" + lstSumResult);
				if (lstSumResult != null && lstSumResult.size() > 0) {
					StringBuffer countSql = new StringBuffer(
							"SELECT COUNT(*) FROM  (SELECT SHPCODE,SHPNAME,SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSJE) GSXSJE FROM ( SELECT B.GSMFID SHPCODE ,C.SHPNAME SHPNAME,SUM(B.GSXSSL) GSXSSL,ROUND(SUM(B.GSHSJJJE),2) GSHSJJJE,ROUND(SUM(B.GSXSSR),2) GSXSJE FROM  YW_GOODSSALE B  LEFT JOIN INF_SHOP C ON B.GSMFID=C.SHPCODE AND B.GSSGCODE=C.SGCODE WHERE 1=1  ");

					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" and B.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						countSql.append(" and b.GSRQ >= to_date('").append(
								saleReport.getStartDate())
								.append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						countSql.append(" and b.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}

					
					countSql.append("  GROUP BY B.GSMFID,C.SHPNAME ");
					countSql.append(" UNION ALL SELECT A.SHPCODE ,A.SHPNAME ,0 GSXSSL,0 GSHSJJJE,0 GSXSJE FROM INF_SHOP A where 1=1 ");
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" and a.SGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					
					countSql.append(" )GROUP BY SHPCODE,SHPNAME )");

					log.info("saleShopCountSql: " + countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log.debug("SaleSummaryImpl.getResult() lstResult : "
							+ lstResult);

					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getResult() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}
					StringBuffer sql = new StringBuffer(" select shpcode,shpname,sum(gsxssl) gsxssl,sum(gshsjjje) gshsjjje,sum(gsxsje) gsxsje from ( SELECT B.GSMFID SHPCODE ,C.SHPNAME SHPNAME,SUM(B.GSXSSL) GSXSSL,ROUND(SUM(B.GSHSJJJE),2) GSHSJJJE,ROUND(SUM(B.GSXSSR),2) GSXSJE FROM  YW_GOODSSALE B  LEFT JOIN INF_SHOP C ON B.GSMFID=C.SHPCODE AND B.GSSGCODE=C.SGCODE WHERE 1=1 ");
					
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1) * saleReport.getRows();
					log.debug("start: " + start);
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" and B.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						sql.append(" and b.GSRQ >= to_date('").append(
								saleReport.getStartDate())
								.append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						sql.append(" and b.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}
					
					sql.append(" GROUP BY B.GSMFID,C.SHPNAME ");
					sql.append("  UNION ALL SELECT A.SHPCODE ,A.SHPNAME ,0 GSXSSL,0 GSHSJJJE,0 GSXSJE  FROM INF_SHOP A  WHERE 1=1  ");
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" and A.SGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					
					sql.append(" ) GROUP BY SHPCODE,SHPNAME ");
					log.info("saleShopResultSql: " + sql);
					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleSummaryImpl.getResult() lstResult 1 :"
							+ lstResult);
					if (lstResult != null) {
						log.debug("SaleSummaryImpl.getResult() lstResult.size() :"
								+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setFooter(lstSumResult);
						result.setRows(lstResult);
					}
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getResult() error :" + ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		}
		else if ("getGSRQSale".equals(actionType)) {
			SaleReport saleReport = (SaleReport) o[0]; 
			try {
				StringBuffer sumSql =new StringBuffer("SELECT CAST('合计' AS VARCHAR(32)) GSRQ, SUM(GSXSSL) GSXSSL,ROUND(SUM(GSHSJJJE),2) GSHSJJJE,SUM(GSXSJE) GSXSJE,(CASE WHEN SUM(GSXSJE) IS NULL OR SUM(GSXSJE)=0  THEN '0.00%' ELSE ROUND((SUM(GSXSJE)-SUM(GSHSJJJE))/SUM(GSXSJE)*100,2)||'%' END) MLL FROM YW_GOODSSALE WHERE 1=1 ");
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql.append(" and GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getSupcode())) {
					log.debug("saleReport.getSupcode(): "
							+ saleReport.getSupcode());
					sumSql.append(" and substr(GSSUPID,0,3) = '").append(
							saleReport.getSupcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					log.debug("saleReport.getGsmfid(): "
							+ saleReport.getGsmfid());
					sumSql.append(" and GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sumSql.append(" and GSRQ >= to_date('").append(
							saleReport.getStartDate())
							.append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("saleReport.getEndDate(): "
							+ saleReport.getEndDate());
					sumSql.append(" and GSRQ <= to_date('").append(
							saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}

				log.info(sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());

				if (lstSumResult != null && lstSumResult.size() > 0) {
					StringBuffer countSql = new StringBuffer(
							"SELECT COUNT(*) FROM (SELECT TO_CHAR(B.GSRQ,'YYYY-MM-DD') GSRQ ,SUM(B.GSXSSL) GXXSSL,ROUND(SUM(B.GSHSJJJE),2) GSHSJJJE,ROUND(SUM(B.GSXSJE),2)GSXSJE,A.SUPID GSSUPID,A.SUPNAME SUPNAME FROM INF_RELATION_JM A LEFT JOIN   YW_GOODSSALE B ON A.SGCODE=B.GSSGCODE AND A.SUPID=SUBSTR(B.GSSUPID,0,3) WHERE 1=1 ");

					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" and a.SGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						countSql.append(" and a.SUPID = '").append(
								saleReport.getSupcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						countSql.append(" and b.GSRQ >= to_date('").append(
								saleReport.getStartDate()).append(
								"','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						countSql.append(" and b.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append(
								"','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						countSql.append(" and b.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					}
					countSql.append(" GROUP BY B.GSRQ,A.SUPID,A.SUPNAME ORDER BY GSRQ DESC) COUNT");

					log.info(countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log
							.debug("SaleSummaryImpl.getShopSaleDetail() lstResult : "
									+ lstResult);

					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getShopSaleDetail() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}
					StringBuffer sql = new StringBuffer(
					"SELECT TO_CHAR(B.GSRQ,'YYYY-MM-DD') GSRQ ,SUM(B.GSXSSL) GSXSSL,ROUND(SUM(B.GSHSJJJE),2) GSHSJJJE,ROUND(SUM(B.GSXSJE),2)GSXSJE,(CASE WHEN SUM(B.GSXSJE) IS NULL OR SUM(B.GSXSJE)=0 THEN '0.00%' ELSE ROUND((SUM(B.GSXSJE)-SUM(B.GSHSJJJE))/SUM(B.GSXSJE)*100,2)||'%' END) MLL,A.SUPID GSSUPID,A.SUPNAME SUPNAME FROM INF_RELATION_JM A LEFT JOIN   YW_GOODSSALE B ON A.SGCODE=B.GSSGCODE AND A.SUPID=SUBSTR(B.GSSUPID,0,3) WHERE 1=1 and B.GSXSSL !=0");
				
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1)
							* saleReport.getRows();
					log.debug("start: " + start);

					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" and a.SGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						sql.append(" and a.SUPID = '").append(
								saleReport.getSupcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						sql.append(" and b.GSRQ >= to_date('").append(
								saleReport.getStartDate()).append(
								"','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						sql.append(" and b.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append(
								"','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						sql.append(" and b.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					}
					sql.append(" GROUP BY B.GSRQ,A.SUPID,A.SUPNAME ORDER BY GSRQ DESC ");
					log.info(sql);
					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleSummaryImpl.getResult() lstResult 1 :"
							+ lstResult);
					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getShopSaleDetail() lstResult.size() 1 :"
										+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setRows(lstResult);
						result.setFooter(lstSumResult);
					}
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getShopSaleDetail() error : "
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
			
		} else if ("saleSum_shop".equals(actionType)) {
			SaleReport saleReport = (SaleReport) o[0]; 
			try {
				
				
				StringBuffer sumSql = null;
			
					sumSql = new StringBuffer(
							"SELECT cast('合计' as varchar2(32)) SHPCODE,SUM(GSXSSL) GSXSSL,round(SUM(GSXSJE),2) GSXSJE,round(SUM(GSHSJJJE),2) AS GSHSJJJE,"
							+"SUM(S.TEMP2) GSXSSR FROM YW_GOODSSALE S LEFT JOIN INF_SHOP P ON S.GSMFID = P.SHPCODE "
							+"AND S.GSSGCODE = P.SGCODE WHERE 1 = 1");
				
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					log.debug("saleReport.getGsmfid(): "
							+ saleReport.getGsmfid());
					sumSql.append(" and P.SHPCODE = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sumSql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log
							.debug("saleReport.getEndDate(): "
									+ saleReport.getEndDate());
					sumSql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}

				
				log.info("saleShopSumSql: " + sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());
				log.debug("shpsum:" + lstSumResult);
				if (lstSumResult != null && lstSumResult.size() > 0) {
					StringBuffer countSql = null;
	               
	                	countSql = new StringBuffer(
						"select count(*) from (SELECT P.SHPCODE,P.SHPNAME,SUM(S.GSXSSL) AS GSXSSL,round(SUM( S.GSXSJE),2) GSXSJE,round(SUM(S.GSHSJJJE),2) AS GSHSJJJE,SUM(S.TEMP2) AS GSXSSR FROM YW_GOODSSALE S LEFT JOIN INF_SHOP P ON S.GSMFID=P.SHPCODE AND S.GSSGCODE = P.SGCODE   WHERE 1=1");
	              
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						countSql.append(" and P.SHPCODE = '").append(
								saleReport.getGsmfid()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						countSql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate())
								.append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						countSql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}

					
					countSql.append(" GROUP BY P.SHPCODE,P.SHPNAME) COUNT");

					log.info("saleShopCountSql: " + countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log.debug("SaleSummaryImpl.getResult() lstResult : "
							+ lstResult);

					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getResult() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}
					StringBuffer sql = null;
					
						sql=new StringBuffer(
						"SELECT P.SHPCODE,P.SHPNAME,SUM(S.GSXSSL) AS GSXSSL,round(SUM( S.GSXSJE),2) GSXSJE,round(SUM(S.GSHSJJJE),2) AS GSHSJJJE,SUM(S.TEMP2) AS GSXSSR FROM YW_GOODSSALE S LEFT JOIN INF_SHOP P ON S.GSMFID=P.SHPCODE AND S.GSSGCODE = P.SGCODE   WHERE 1=1 ");
					
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1) * saleReport.getRows();
					log.debug("start: " + start);
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						sql.append(" and P.SHPCODE = '").append(
								saleReport.getGsmfid()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						sql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate())
								.append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						sql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}
					
					sql.append(" GROUP BY P.SHPCODE,P.SHPNAME");
					log.info("saleShopResultSql: " + sql);
					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleSummaryImpl.getResult() lstResult 1 :"
							+ lstResult);
					if (lstResult != null) {
						log.debug("SaleSummaryImpl.getResult() lstResult.size() :"
								+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setFooter(lstSumResult);
						result.setRows(lstResult);
					}
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getResult() error :" + ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
			
		}else if ("saleSum_shop_detil".equals(actionType)) {
			SaleReport saleReport = (SaleReport) o[0]; 
			try {
			
				StringBuffer sumSql = null;
				
					sumSql = new StringBuffer(
					"SELECT cast('合计' as varchar2(30)) GSRQ,SUM(GSXSSL) GSXSSL,round(SUM(GSXSJE),2) GSXSJE,round(SUM(S.GSHSJJJE),2) GSXSSR FROM YW_GOODSSALE S where 1=1");					
				
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					log.debug("saleReport.getGsmfid(): "
							+ saleReport.getGsmfid());
					sumSql.append(" and S.GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sumSql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate())
							.append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("saleReport.getEndDate(): "
							+ saleReport.getEndDate());
					sumSql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}

				log.info(sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());

				if (lstSumResult != null && lstSumResult.size() > 0) {
					
					StringBuffer countSql = null;
						
							 countSql = new StringBuffer(
							"select count(*) from YW_GOODSSALE S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE where 1=1");
						
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						countSql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						countSql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate())
								.append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						countSql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}
					
					log.info(countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log.debug("SaleSummaryImpl.getGsrqShopSale() lstResult : "
							+ lstResult);

					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getGsrqShopSale() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}

					StringBuffer sql = null;
					
						 sql = new StringBuffer(
								"select to_char(S.GSRQ,'yyyy-MM-dd') as GSRQ,G.GDBARCODE, G.GDID,G.GDNAME,G.GDSPEC,G.GDUNIT,S.GSXSSL,S.GSXSJE GSXSJE,S.GSHSJJJE GSXSSR,"
+" S.GSSUPID,D.SUPNAME from YW_GOODSSALE S left join INF_GOODS G on S.GSGDID=G.GDID and S.GSSGCODE=G.GDSGCODE LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID where 1=1 ");
					
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1)
							* saleReport.getRows();
					log.debug("start: " + start);

					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getGsmfid(): "
								+ saleReport.getGsmfid());
						sql.append(" and S.GSMFID = '").append(
								saleReport.getGsmfid()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						sql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate())
								.append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						sql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}
					
					log.info(sql);
					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleSummaryImpl.getGsrqShopSale() lstResult 1 :"
							+ lstResult);
					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getGsrqShopSale() lstResult.size() 1 :"
										+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setRows(lstResult);
						result.setFooter(lstSumResult);
					}
				}

			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getResult() error :"
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		}else if("getGysSaleSum".equals(actionType)){//供应商销售汇总查询
			SaleReport saleReport = (SaleReport) o[0];
			try {
				boolean flag_3010=saleReport.getGssgcode().equals("3010");
				StringBuffer sumSql = new StringBuffer(
							"SELECT cast('合计' as varchar2(32)) GSSUPID,SUM(GSXSSL) GSXSSL,round(SUM(GSXSJE),2) GSXSJE,round(SUM(GSHSJJJE),2) AS GSHSJJJE,"
							+"SUM(S.TEMP2) GSXSSR FROM YW_GOODSSALE S LEFT JOIN INF_SHOP P ON S.GSMFID = P.SHPCODE "
							+"AND S.GSSGCODE = P.SGCODE " +
							"LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID WHERE 1 = 1");
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getSupcode())) {
					log.debug("saleReport.getSupcode(): "
							+ saleReport.getSupcode());
					sumSql.append(" and S.GSSUPID = '").append(
							saleReport.getSupcode()).append("'");
				}
				
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sumSql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log
							.debug("saleReport.getEndDate(): "
									+ saleReport.getEndDate());
					sumSql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}
				if(!StringUtil.isBlank(saleReport.getSuname())){
					sumSql.append(" and D.SUPNAME like '%").append(
							saleReport.getSuname()).append("%'");
				}
				
				log.info("saleShopSumSql: " + sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());
				log.debug("shpsum:" + lstSumResult);
				if (lstSumResult != null && lstSumResult.size() > 0) {
					StringBuffer countSql = new StringBuffer(
						"select count(*) from (select s.gssupid,d.supname,sum(s.gsxssl) as gsxssl,round(sum( s.gsxsje),2) gsxsje,round(sum(s.gshsjjje),2) as gshsjjje from yw_goodssale s left join inf_supinfo d on s.gssgcode=d.supsgcode and s.gssupid=d.supid where 1=1 and s.gsxssl != 0");
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						countSql.append(" and S.GSSUPID = '").append(
								saleReport.getSupcode()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						countSql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate())
								.append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						countSql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}
					if(!StringUtil.isBlank(saleReport.getSuname())){
						countSql.append(" and D.SUPNAME like '%").append(
								saleReport.getSuname()).append("%'");
					}
					
					countSql.append(" GROUP BY GSSUPID,D.SUPNAME) COUNT");

					log.info("saleShopCountSql: " + countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log.debug("SaleSummaryImpl.getResult() lstResult : "
							+ lstResult);

					if (lstResult != null) {
						log.debug("SaleSummaryImpl.getResult() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}
					StringBuffer sql = new StringBuffer(
						"select s.gssupid,d.supname,sum(s.gsxssl) as gsxssl,round(sum( s.gsxsje),2) gsxsje,round(sum(s.gshsjjje),2) as gshsjjje from yw_goodssale s left join inf_supinfo d on s.gssgcode=d.supsgcode and s.gssupid=d.supid where 1=1 and s.gsxssl != 0 ");
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1) * saleReport.getRows();
					log.debug("start: " + start);
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" and s.gssgcode = '").append(
								saleReport.getGssgcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						sql.append(" and s.gssupid = '").append(
								saleReport.getSupcode()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						sql.append(" and s.gsrq >= to_date('").append(
								saleReport.getStartDate())
								.append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						sql.append(" and s.gsrq <= to_date('").append(
								saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}
					
					if(!StringUtil.isBlank(saleReport.getSuname())){
						sql.append(" and d.supname like '%").append(
								saleReport.getSuname()).append("%'");
					}	
					sql.append(" group by gssupid,d.supname");
					log.info("saleShopResultSql: " + sql);
					if(result.getTotal()>1){
						lstResult = dao.executeSql(sql.toString(), start, limit);
					}else{
						lstResult = dao.executeSql(sql.toString());
					}
					log.debug("SaleSummaryImpl.getResult() lstResult 1 :"+ lstResult);
					if (lstResult != null) {
						log.debug("SaleSummaryImpl.getResult() lstResult.size() :"+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						if(result.getTotal()>1){
							result.setFooter(lstSumResult);
						}
						result.setRows(lstResult);
					}
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getResult() error :" + ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		}else if("getLssSaleSum".equals(actionType)){//零售商销售汇总查询
			SaleReport saleReport = (SaleReport) o[0];
			try {
				boolean flag_3010=saleReport.getGssgcode().equals("3010");
					StringBuffer sql = new StringBuffer("select d.shpcode,d.shpname,round(sum(gsxsje),2) gsxsje,round(sum(s.gsxsje-s.gshsjjje),2)maole  from yw_goodssale s left join inf_shop d on s.gsmfid = d.shpcode and s.gssgcode = d.sgcode where 1 = 1");	
					if(!StringUtil.isBlank(saleReport.getGssgcode())){
						sql.append(" and s.gssgcode = '").append(saleReport.getGssgcode()).append("'");
					}
					Calendar yd = Calendar.getInstance(); 
					yd.add(Calendar.DATE, -1);//当前时间的前一天
					Date yday = yd.getTime();
					SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");//创建一个日期格式.  
					String yesterday = format.format(yday);//以格式处理date 
					
					Calendar nd = Calendar.getInstance(); 
					Date nday = nd.getTime();
					SimpleDateFormat formatnow = new SimpleDateFormat("yyyy-MM-dd");//创建一个日期格式.  
					String now = format.format(nday);//以格式处理date 
					
					if ("Y".equals( saleReport.getYesterdayFlag() ) ) { 
					sql.append(" and  to_char(s.gsrq,'yyyy-mm-dd') >=  to_char('"+ yesterday +"') ");
					sql.append(" and  to_char(s.gsrq,'yyyy-mm-dd') <=  to_char('"+ now +"') ");
					}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "	+ saleReport.getStartDate());
						sql.append(" and s.gsrq >= to_date('").append( saleReport.getStartDate()).append("','yyyy-MM-dd ')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "+ saleReport.getEndDate());
						sql.append(" and s.gsrq <= to_date('").append(saleReport.getEndDate()).append("','yyyy-MM-dd ')");
					}
						sql.append(" group by d.shpcode,d.shpname");
						
					StringBuffer lsql = new StringBuffer("select * from ("+sql.toString()+")  order by gsxsje desc");
					log.info("saleShopResultSql: " + lsql);
					System.out.println("零售商销售汇总查询SQL:"+lsql);
				    List lstResult = dao.executeSql(lsql.toString());
					log.debug("SaleSummaryImpl.getResult() lstResult 1 :"+ lstResult);
					//汇总的查询footer
					StringBuffer sumSql= new StringBuffer("select cast('合计' as varchar2(32)) shpcode, round(sum(gsxsje),2) gsxsje,round(sum(s.gsxsje-s.gshsjjje),2) maole from yw_goodssale s left join inf_shop p on s.gsmfid = p.shpcode and s.gssgcode = p.sgcode where 1 = 1 ");
					
					if(!StringUtil.isBlank(saleReport.getGssgcode())){
						sumSql.append(" and s.gssgcode = '").append(saleReport.getGssgcode()).append("'");
					}
					
    				if ("Y".equals( saleReport.getYesterdayFlag()) ) { 
    					sumSql.append(" and  to_char(s.gsrq,'yyyy-mm-dd') >=  to_char('"+ yesterday +"') ");
    					sumSql.append(" and  to_char(s.gsrq,'yyyy-mm-dd') <=  to_char('"+ now +"') ");
					}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "	+ saleReport.getStartDate());
						sumSql.append(" and s.gsrq >= to_date('").append( saleReport.getStartDate()).append("','yyyy-MM-dd ')");
					}
					
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "+ saleReport.getEndDate());
						sumSql.append(" and s.gsrq <= to_date('").append(saleReport.getEndDate()).append("','yyyy-MM-dd ')");
					}
					
					log.info("sumSql:"+sumSql);
					System.out.println("合计查询SQL:"+sumSql);
					List sumResult= dao.executeSql(sumSql.toString()); 
					log.debug("SaleSummaryImpl.getResult() lstResult 1 :"+ sumResult);
					
					if (lstResult != null) {
						log.debug("SaleSummaryImpl.getResult() lstResult.size() :"+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						
						result.setFooter(sumResult);
						result.setRows(lstResult);
					}
				}
			  catch (Exception ex) {
				log.error("SaleSummaryImpl.getResult() error :" + ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			} 
		}else if("getResult_YPDM".equals(actionType)){
			SaleReport saleReport = (SaleReport) o[0];
			try {
				StringBuffer sumSql = new StringBuffer(
							"SELECT cast('合计' as varchar2(32)) SHPCODE,SUM(GSXSSL) GSXSSL,round(SUM(GSXSSR),2) GSXSJE,round(SUM(GSHSJJJE),2) AS GSHSJJJE "
							+" FROM YW_GOODSSALE_M S LEFT JOIN INF_SHOP P ON S.GSMFID = P.SHPCODE "
							+"AND S.GSSGCODE = P.SGCODE WHERE 1 = 1");
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sumSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						sumSql.append(" and S.GSSUPID = '").append(
								saleReport.getSupcode()).append("'");
					}
				
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sumSql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log
							.debug("saleReport.getEndDate(): "
									+ saleReport.getEndDate());
					sumSql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}

				
				log.info("saleShopSumSql: " + sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());
				log.debug("shpsum:" + lstSumResult);
				if (lstSumResult != null && lstSumResult.size() > 0) {
					StringBuffer countSql =new StringBuffer(
						"select count(*) from (select GSMFID,S.GSSUPID from YW_GOODSSALE_M S LEFT JOIN INF_SHOP P ON S.GSMFID=P.SHPCODE AND S.GSSGCODE = P.SGCODE  WHERE 1=1");
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						countSql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							countSql.append(" and S.GSSUPID = '").append(
									saleReport.getSupcode()).append("'");
						}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						countSql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate())
								.append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						countSql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}
						countSql.append(" GROUP BY GSMFID,S.GSSUPID) COUNT");

					log.info("saleShopCountSql: " + countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log.debug("SaleSummaryImpl.getResult() lstResult : "
							+ lstResult);

					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getResult() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}
					StringBuffer sql =new StringBuffer(
						"SELECT P.SHPCODE,S.GSSUPID,D.SUPNAME,P.SHPNAME,SUM(S.GSXSSL) AS GSXSSL,round(SUM( S.GSXSSR),2) GSXSJE,round(SUM(S.GSHSJJJE),2) AS GSHSJJJE,SUM(S.TEMP2) AS GSXSSR FROM YW_GOODSSALE_M S LEFT JOIN INF_SHOP P ON S.GSMFID=P.SHPCODE AND S.GSSGCODE = P.SGCODE LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID  WHERE 1=1 ");
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1) * saleReport.getRows();
					log.debug("start: " + start);
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "
								+ saleReport.getGssgcode());
						sql.append(" and S.GSSGCODE = '").append(
								saleReport.getGssgcode()).append("'");
					}
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							sql.append(" and S.GSSUPID = '").append(
									saleReport.getSupcode()).append("'");
						}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "
								+ saleReport.getStartDate());
						sql.append(" and S.GSRQ >= to_date('").append(
								saleReport.getStartDate())
								.append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
						sql.append(" and S.GSRQ <= to_date('").append(
								saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}
						sql.append(" GROUP BY P.SHPCODE,P.SHPNAME,S.GSSUPID,SUPNAME");
					log.info("saleShopResultSql: " + sql);
					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleSummaryImpl.getResult() lstResult 1 :"
							+ lstResult);
					if (lstResult != null) {
						log.debug("SaleSummaryImpl.getResult() lstResult.size() :"
								+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setFooter(lstSumResult);
						result.setRows(lstResult);
					}
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getResult() error :" + ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		}else if("getSaleByMonth".equals(actionType)){
			SaleReport saleReport = (SaleReport) o[0];
			try {
				StringBuffer sumSql = new StringBuffer(" SELECT CAST('合计' AS VARCHAR2(32)) AYEAR,SUM(TAMONEY)TAMONEY,SUM(CTCOST)CTCOST FROM YW_GOODSSALE_FL WHERE 1=1 ");
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): " + saleReport.getGssgcode());
					sumSql.append(" and SGCODE = '").append( saleReport.getGssgcode()).append("'");
				}
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): " + saleReport.getSupcode());
						sumSql.append(" and SUPID = '").append( saleReport.getSupcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getTemp5())) {
						log.debug("saleReport.getSupcode(): " + saleReport.getSupcode());
						sumSql.append(" and pactid = '").append( saleReport.getTemp5()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getGsmfid())) {
						log.debug("saleReport.getSupcode(): " + saleReport.getSupcode());
						sumSql.append(" and shopid = '").append( saleReport.getGsmfid()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "+ saleReport.getEndDate());
						sumSql.append(" and ayear='").append(saleReport.getEndDate().substring(0, 4)).append("'");
						sumSql.append(" and amonth='").append(saleReport.getEndDate().substring(4)).append("'");
					}

				
				log.info("saleShopSumSql: " + sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());
				log.debug("shpsum:" + lstSumResult);
				if (lstSumResult != null && lstSumResult.size() > 0) {
					StringBuffer countSql =new StringBuffer(" SELECT COUNT(*) FROM YW_GOODSSALE_FL A WHERE 1=1  ");
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): " + saleReport.getGssgcode());
						countSql.append(" and SGCODE = '").append( saleReport.getGssgcode()).append("'");
					}
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): " + saleReport.getSupcode());
							countSql.append(" and SUPID = '").append( saleReport.getSupcode()).append("'");
						}
						if (!StringUtil.isBlank(saleReport.getTemp5())) {
							log.debug("saleReport.getSupcode(): " + saleReport.getSupcode());
							countSql.append(" and pactid = '").append( saleReport.getTemp5()).append("'");
						}
						if (!StringUtil.isBlank(saleReport.getGsmfid())) {
							log.debug("saleReport.getGsmfid(): " + saleReport.getSupcode());
							countSql.append(" and shopid = '").append( saleReport.getGsmfid()).append("'");
						}
						if (!StringUtil.isBlank(saleReport.getEndDate())) {
							log.debug("saleReport.getEndDate(): "+ saleReport.getEndDate());
							countSql.append(" and ayear='").append(saleReport.getEndDate().substring(0, 4)).append("'");
							countSql.append(" and amonth='").append(saleReport.getEndDate().substring(4)).append("'");
						}

					log.info("saleShopCountSql: " + countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log.debug("SaleSummaryImpl.getResult() lstResult : "
							+ lstResult);

					if (lstResult != null) {
						log.debug("SaleSummaryImpl.getResult() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}
					StringBuffer sql =new StringBuffer(" SELECT A.SHOPID||C.SHPNAME SHOPID,A.SUPID||B.SUPNAME SUPID,A.AYEAR,A.AMONTH,A.PACTID,A.TAMONEY,A.CTCOST FROM YW_GOODSSALE_FL A LEFT JOIN INF_SUPINFO B ON A.SGCODE=B.SUPSGCODE AND A.SUPID=B.SUPID LEFT JOIN INF_SHOP C ON A.SGCODE=C.SGCODE AND A.SHOPID=C.SHPCODE WHERE 1=1 ");
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1) * saleReport.getRows();
					log.debug("start: " + start);
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): " + saleReport.getGssgcode());
						sql.append(" and a.SGCODE = '").append( saleReport.getGssgcode()).append("'");
					}
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): " + saleReport.getSupcode());
							sql.append(" and a.SUPID = '").append( saleReport.getSupcode()).append("'");
						}
						if (!StringUtil.isBlank(saleReport.getTemp5())) {
							log.debug("saleReport.getSupcode(): " + saleReport.getSupcode());
							sql.append(" and a.pactid = '").append( saleReport.getTemp5()).append("'");
						}
						if (!StringUtil.isBlank(saleReport.getGsmfid())) {
							log.debug("saleReport.getGsmfid(): " + saleReport.getSupcode());
							sql.append(" and a.shopid = '").append( saleReport.getGsmfid()).append("'");
						}
						if (!StringUtil.isBlank(saleReport.getEndDate())) {
							log.debug("saleReport.getEndDate(): "+ saleReport.getEndDate());
							sql.append(" and a.ayear='").append(saleReport.getEndDate().substring(0, 4)).append("'");
							sql.append(" and a.amonth='").append(saleReport.getEndDate().substring(4)).append("'");
						}
						if (!StringUtil.isBlank(saleReport.getSort())&&!StringUtil.isBlank(saleReport.getOrder())) {
							log.debug("saleReport.getOrder(): " + saleReport.getSort());
							sql.append(" order by ").append( saleReport.getSort()).append(" "+saleReport.getOrder());
						}
							
					log.info("saleShopResultSql: " + sql);
					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleSummaryImpl.getResult() lstResult 1 :"
							+ lstResult);
					if (lstResult != null) {
						log.debug("SaleSummaryImpl.getResult() lstResult.size() :"
								+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setFooter(lstSumResult);
						result.setRows(lstResult);
					}
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getResult() error :" + ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		}else if("getGoodsalepop".equals(actionType)){
			SaleReport saleReport = (SaleReport) o[0];
			try {	
				String sql = "select yg.*, sup.supname, sp.shpname from yw_goodsalepop yg,inf_supinfo sup,inf_shop sp "
						   + "where yg.sgcode = sup.supsgcode and yg.sglsupid = sup.supid and yg.sgcode = sp.sgcode and yg.sglmarket = sp.shpcode ";
				if(!StringUtil.isBlank(saleReport.getGssgcode())){
					sql += " and yg.sgcode = '"+saleReport.getGssgcode()+"'";
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					sql += " and to_char(yg.sgldate,'yyyy-mm-dd') >= '"+saleReport.getStartDate()+"'";
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					sql += " and to_char(yg.sgldate,'yyyy-mm-dd') <= '"+saleReport.getEndDate()+"'";
				}
				if(!StringUtil.isBlank(saleReport.getGsmfid())){
					sql += " and yg.sglmarket = '"+saleReport.getGsmfid()+"'";
				}
				if(!StringUtil.isBlank(saleReport.getSupcode())){
					sql += " and yg.sglsupid = '"+saleReport.getSupcode()+"'";
				}
				if(!StringUtil.isBlank(saleReport.getGsgdid())){
					sql += " and yg.sglgdid = '"+saleReport.getGsgdid()+"'";
				}
				if( saleReport.getOrder() != null && saleReport.getSort() != null ){
					sql +=" order by " + saleReport.getSort()+" "+saleReport.getOrder();
				}
				String sumSQL = "select cast('合计' as varchar2(20)) sglmarket,sum(sglsl)sglsl,sum(sglxssr)sglxssr,sum(sglsupzk)sglsupzk,sum(sgltotzk)sgltotzk,sum(sglpopzk)sglpopzk,sum(sgln1)sgln1 from("+sql+")";
				String countSql = "select count(*) from ("+sql+")";
				
				int limit = saleReport.getRows();
				int start = (saleReport.getPage() - 1) * saleReport.getRows();
				//分页查询
				List listRows = dao.executeSql(sql, start, limit);
				//统计
				List lstResult = dao.executeSqlCount(countSql);
				//合计
				List sumResult = dao.executeSql(sumSQL);
				if(listRows.size()>0){
					result.setTotal(Integer.parseInt(lstResult.get(0).toString()));
					result.setRows(listRows);
					result.setFooter(sumResult);
					result.setReturnCode(Constants.SUCCESS_FLAG);
				}
				
			} catch (Exception e) {
				log.error("getGoodsalepop.getResult() error :" + e.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(e.getMessage());
			}
		}else if("getSumKPI_JBDSJ".equals(actionType)){
			SaleReport saleReport = (SaleReport) o[0];
			try {
				StringBuffer sumSql = new StringBuffer(" select cast('合计' as varchar2(32)) gdcatname,sum(gs.GSXSJE) GSXSJE from yw_goodssale gs ,INF_KPI_JBDSJ ikj,Inf_Goods ig,inf_supinfo isi where gs.gssgcode = ikj.sgcode and gs.temp5 = ikj.hth and gs.gssupid = ikj.wldw and gs.gssgcode = ig.gdsgcode and gs.gsgdid = ig.gdid and gs.gssupid = ig.temp5 and gs.gssgcode = isi.supsgcode and gs.gssupid = isi.supid and 1=1 ");
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "+ saleReport.getGssgcode());
					sumSql.append(" and gs.gssgcode = '").append(saleReport.getGssgcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getSupcode())) {
					log.debug("saleReport.getSupcode(): "+ saleReport.getSupcode());
					sumSql.append(" and gs.gssupid = '").append(saleReport.getSupcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getHth())) {
					log.debug("saleReport.getHth(): "+ saleReport.getHth());
					sumSql.append(" and gs.temp5 = '").append(saleReport.getHth()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "+ saleReport.getStartDate());
					sumSql.append(" and gs.gsrq >= to_date('").append(saleReport.getStartDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("saleReport.getEndDate(): "+ saleReport.getEndDate());
					sumSql.append(" and gs.gsrq <= to_date('").append(saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getFloor())) {
					log.debug("saleReport.getFloor(): "+ saleReport.getFloor());
					sumSql.append(" and ikj.floor = '").append(saleReport.getFloor()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getDeptname())) {
					log.debug("saleReport.getDeptname(): "+ saleReport.getDeptname());
					sumSql.append(" and ikj.deptname = '").append(saleReport.getDeptname()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGdppname())) {
					log.debug("saleReport.getGdppname(): "+ saleReport.getGdppname());
					sumSql.append(" and ig.gdppname = '").append(saleReport.getGdppname()).append("'");
				}

				log.info("saleShopSumSql: " + sumSql);
				List lstSumResult = dao.executeSql(sumSql.toString());
				log.debug("shpsum:" + lstSumResult);
				if (lstSumResult != null && lstSumResult.size() > 0) {
				StringBuffer countSql =new StringBuffer("select count(*) from (select ikj.deptname GDCATNAME,ikj.floor,isi.supid,isi.supname,ikj.hth,ig.gdppname,sum(gs.GSXSJE) GSXSJE,row_number() over(partition by ikj.deptname order by sum(gs.GSXSJE) desc) row_number from yw_goodssale gs,INF_KPI_JBDSJ ikj,Inf_Goods ig,inf_supinfo isi where gs.gssgcode = ikj.sgcode and gs.temp5 = ikj.hth and gs.gssupid = ikj.wldw and gs.gssgcode = ig.gdsgcode and gs.gsgdid = ig.gdid and gs.gssupid = ig.temp5 and gs.gssgcode = isi.supsgcode and gs.gssupid = isi.supid and 1=1 ");
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "+ saleReport.getGssgcode());
					  countSql.append(" and gs.gssgcode = '").append(saleReport.getGssgcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getSupcode())) {
					log.debug("saleReport.getSupcode(): "+ saleReport.getSupcode());
					countSql.append(" and gs.gssupid = '").append(saleReport.getSupcode()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getHth())) {
					log.debug("saleReport.getHth(): "+ saleReport.getHth());
					    countSql.append(" and gs.temp5 = '").append(saleReport.getHth()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "+ saleReport.getStartDate());
					countSql.append(" and gs.gsrq >= to_date('").append(saleReport.getStartDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("saleReport.getEndDate(): "+ saleReport.getEndDate());
					countSql.append(" and gs.gsrq <= to_date('").append(saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getFloor())) {
					log.debug("saleReport.getFloor(): "+ saleReport.getFloor());
					countSql.append(" and ikj.floor = '").append(saleReport.getFloor()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getDeptname())) {
					log.debug("saleReport.getDeptname(): "+ saleReport.getDeptname());
					countSql.append(" and ikj.deptname = '").append(saleReport.getDeptname()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getGdppname())) {
					log.debug("saleReport.getGdppname(): "+ saleReport.getGdppname());
					countSql.append(" and ig.gdppname like '%").append(saleReport.getGdppname()).append("%'");
				}
				countSql.append("group by ikj.deptname,ikj.floor,ikj.deptname,isi.supid,gs.gssupid,isi.supname,ikj.hth,ig.gdppname order by ikj.deptname,ikj.floor,sum(gs.GSXSJE) desc)z");
							

					log.info("saleShopCountSql: " + countSql);
					List lstResult = dao.executeSqlCount(countSql.toString());
					log.debug("SaleSummaryImpl.getResult() lstResult : "
							+ lstResult);

					if (lstResult != null) {
						log
								.debug("SaleSummaryImpl.getResult() lstResult.get(0).toString() : "
										+ lstResult.get(0).toString());
						result.setTotal(Integer.parseInt(lstResult.get(0)
								.toString()));
					}
					StringBuffer sql =new StringBuffer(
					"select x.*,y.gdcatnamecount,LPAD(x.hth,8,'0') HTHEG,'共'||y.gdcatnamecount||'个品牌，排名第'||row_number||'位' ROWNUMBERCOUNT from(select ikj.deptname GDCATNAME,ikj.floor,isi.supid,isi.supname,ikj.hth,ig.gdppname,sum(gs.GSXSJE) GSXSJE,row_number() over(partition by ikj.deptname order by sum(gs.GSXSJE) desc) row_number from yw_goodssale gs,INF_KPI_JBDSJ ikj,Inf_Goods ig,inf_supinfo isi where gs.gssgcode = ikj.sgcode and gs.temp5 = ikj.hth and gs.gssupid = ikj.wldw and gs.gssgcode = ig.gdsgcode and gs.gsgdid = ig.gdid and gs.gssupid = ig.temp5 and gs.gssgcode = isi.supsgcode and gs.gssupid = isi.supid and 1=1 ");
					int limit = saleReport.getRows();
					log.debug("limit: " + limit);
					int start = (saleReport.getPage() - 1) * saleReport.getRows();
					log.debug("start: " + start);
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "+ saleReport.getGssgcode());
						sql.append(" and gs.gssgcode = '").append(saleReport.getGssgcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "+ saleReport.getStartDate());
						sql.append(" and gs.gsrq >= to_date('").append(saleReport.getStartDate()).append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "+ saleReport.getEndDate());
						sql.append(" and gs.gsrq <= to_date('").append(saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}
					
					sql.append(" group by ikj.deptname,ikj.floor,ikj.deptname,isi.supid,gs.gssupid,isi.supname,ikj.hth,ig.gdppname order by ikj.deptname,ikj.floor,sum(gs.GSXSJE) desc)x left join(select GDCATNAME,floor,count(GDCATNAME) gdcatnamecount from(select ikj.deptname GDCATNAME,ikj.floor,isi.supid,isi.supname,ikj.hth,ig.gdppname,sum(gs.GSXSJE) GSXSJE,row_number() over(partition by ikj.deptname order by sum(gs.GSXSJE) desc) row_number from yw_goodssale gs,INF_KPI_JBDSJ ikj,Inf_Goods ig,inf_supinfo isi where gs.gssgcode = ikj.sgcode and gs.temp5 = ikj.hth and gs.gssupid = ikj.wldw and gs.gssgcode = ig.gdsgcode and gs.gsgdid = ig.gdid and gs.gssupid = ig.temp5 and gs.gssgcode = isi.supsgcode and gs.gssupid = isi.supid and 1=1");
					
					if (!StringUtil.isBlank(saleReport.getGssgcode())) {
						log.debug("saleReport.getGssgcode(): "+ saleReport.getGssgcode());
						sql.append(" and gs.gssgcode = '").append(saleReport.getGssgcode()).append("'");
					}
					
					if (!StringUtil.isBlank(saleReport.getStartDate())) {
						log.debug("saleReport.getStartDate(): "+ saleReport.getStartDate());
						sql.append(" and gs.gsrq >= to_date('").append(saleReport.getStartDate()).append("','yyyy-MM-dd')");
					}
					if (!StringUtil.isBlank(saleReport.getEndDate())) {
						log.debug("saleReport.getEndDate(): "+ saleReport.getEndDate());
						sql.append(" and gs.gsrq <= to_date('").append(saleReport.getEndDate()).append("','yyyy-MM-dd')");
					}					
					
					sql.append(" group by ikj.deptname,ikj.floor,ikj.deptname,isi.supid,gs.gssupid,isi.supname,ikj.hth,ig.gdppname order by ikj.deptname,ikj.floor,sum(gs.GSXSJE) desc)z group by GDCATNAME,floor order by GDCATNAME,floor)y on x.gdcatname = y.gdcatname and x.floor = y.floor where 1=1 ");
					
					if (!StringUtil.isBlank(saleReport.getHth())) {
						log.debug("saleReport.getHth(): "+ saleReport.getHth());
						sql.append(" and x.hth = '").append(saleReport.getHth()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "+ saleReport.getSupcode());
							sql.append(" and x.supid = '").append(saleReport.getSupcode()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getFloor())) {
						log.debug("saleReport.getFloor(): "+ saleReport.getFloor());
						sql.append(" and x.floor = '").append(saleReport.getFloor()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getDeptname())) {
						log.debug("saleReport.getDeptname(): "+ saleReport.getDeptname());
						sql.append(" and x.gdcatname = '").append(saleReport.getDeptname()).append("'");
					}
					if (!StringUtil.isBlank(saleReport.getGdppname())) {
						log.debug("saleReport.getGdppname(): "+ saleReport.getGdppname());
						sql.append(" and x.gdppname like '%").append(saleReport.getGdppname()).append("%'");
					}
					
					sql.append(" order by x.row_number ");
					
					log.info("saleShopResultSql: " + sql);
					lstResult = dao.executeSql(sql.toString(), start, limit);
					log.debug("SaleSummaryImpl.getResult() lstResult 1 :"
							+ lstResult);
					if (lstResult != null) {
						log.debug("SaleSummaryImpl.getResult() lstResult.size() :"
								+ lstResult.size());
						result.setReturnCode(Constants.SUCCESS_FLAG);
						result.setFooter(lstSumResult);
						result.setRows(lstResult);
					}
				}
			} catch (Exception ex) {
				log.error("SaleSummaryImpl.getResult() error :" + ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		}else if("getSaleTotal".equals(actionType)){
			SaleReport saleReport = (SaleReport) o[0];
			String sql = "select gs.gsgdid,gd.gdbarcode,gd.gdname,gd.gdspec gg,gd.gdunit dw,gs.gssupid,sup.supname,sum(gs.gsxssl)gsxssl,sum(gs.gsxssr)gsxssr,"
				       + "sum(gs.gsxsje)gsxsje,sum(gs.gshsjjje)gshsjjje,round(sum(gsvendrebate),2) as gsvendrebate from yw_goodssale gs  left join inf_goods gd on gs.gssgcode = gd.gdsgcode and gs.gsgdid = gd.gdid "
				       + "left join inf_supinfo sup on gs.gssgcode = sup.supsgcode and gs.gssupid = sup.supid left join inf_shop sp on gs.gssgcode = sp.sgcode and gs.gsmfid = sp.shpcode where 1=1 ";
			if(!StringUtil.isBlank(saleReport.getGssgcode())){
				sql += " and gs.gssgcode = '"+saleReport.getGssgcode()+"' ";	
			}
			if(!StringUtil.isBlank(saleReport.getSupcode())){
				sql += " and gs.gssupid = '"+saleReport.getSupcode()+"' ";	
			}
			if(!StringUtil.isBlank(saleReport.getGsmfid())){
				sql += " and gs.gsmfid = '"+saleReport.getGsmfid()+"' ";	
			}
			if(!StringUtil.isBlank(saleReport.getGdbarcode())){
				sql += " and gd.gdbarcode like '%"+saleReport.getGdbarcode()+"%' ";	
			}
			if(!StringUtil.isBlank(saleReport.getGsgdid())){
				sql += " and gs.gsgdid = '"+saleReport.getGsgdid()+"' ";	
			}
			if(!StringUtil.isBlank(saleReport.getStartDate())){
				sql += " and to_char(gs.gsrq,'yyyy-mm-dd') >= '"+saleReport.getStartDate()+"' ";	
			}
			if(!StringUtil.isBlank(saleReport.getEndDate())){
				sql += " and to_char(gs.gsrq,'yyyy-mm-dd') <= '"+saleReport.getEndDate()+"' ";	
			}
			sql += " group by gs.gsgdid,gd.gdbarcode,gd.gdname,gd.gdspec ,gd.gdunit ,gs.gssupid,sup.supname ";
			//排序
			if( saleReport.getOrder() != null && saleReport.getSort() != null ){
				sql +=" order by " + saleReport.getSort()+" "+saleReport.getOrder();
			}else{
				sql +=" order by gs.gsgdid ";
			}
			try {
				String sumSQL = "select cast('合计' as varchar2(20)) gsgdid,sum(gsxssl)gsxssl,sum(gsxssr)gsxssr,sum(gsxsje)gsxsje,sum(gshsjjje)gshsjjje,round(sum(gsvendrebate),2) as gsvendrebate from("+sql+")";
				String countSql = "select count(*) from ("+sql+")";
				
				int limit = saleReport.getRows();
				int start = (saleReport.getPage() - 1) * saleReport.getRows();
				//分页查询
				List listRows = dao.executeSql(sql, start, limit);
				//统计
				List lstResult = dao.executeSqlCount(countSql);
				//合计
				List sumResult = dao.executeSql(sumSQL);
				if(listRows.size()>0){
					result.setTotal(Integer.parseInt(lstResult.get(0).toString()));
					result.setRows(listRows);
					result.setFooter(sumResult);
					result.setReturnCode(Constants.SUCCESS_FLAG);
				}
				
			} catch (Exception e) {
				log.error("getSaleTotal.getResult() error :" + e.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(e.getMessage());
			}
		}
		return result;
	}

	
	public String getSpecifiedDayBefore(String specifiedDay) {
	     Calendar c = Calendar.getInstance();
	     Date date = null;
	     try {
	         date = new SimpleDateFormat("yy-MM-dd").parse(specifiedDay);
	     } catch (ParseException e) {
	         e.printStackTrace();
	     }
	     c.setTime(date);
	     int day = c.get(Calendar.DATE);
	     c.set(Calendar.DATE, day - 1);

	     String dayBefore = new SimpleDateFormat("yyyy-MM-dd").format(c
	             .getTime());
	     return dayBefore;
	 }
	
	@Override
	public ReturnObject getResult(Object o) {
		ReturnObject result = new ReturnObject();
		
		try {
			SaleReport saleReport = (SaleReport) o; 
			String goodssaleTable="YW_GOODSSALE"+saleReport.getGssgcode();
			boolean flag_3010=saleReport.getGssgcode().equals("3010");
			StringBuffer sumSql = null;
			if(flag_3010){
				sumSql = new StringBuffer(
						"SELECT cast('合计' as varchar2(32)) SHPCODE,SUM(GSXSSL) GSXSSL,round(SUM(GSXSSR),2) GSXSJE,round(SUM(GSHSJJJE),2) AS GSHSJJJE,"
						+"SUM(S.TEMP2) GSXSSR FROM YW_GOODSSALE_M S LEFT JOIN INF_SHOP P ON S.GSMFID = P.SHPCODE "
						+"AND S.GSSGCODE = P.SGCODE WHERE 1 = 1");
			}else{
				sumSql = new StringBuffer(
						"SELECT cast('合计' as varchar2(32)) SHPCODE,SUM(GSXSSL) GSXSSL,round(SUM(GSXSJE),2) GSXSJE,round(SUM(GSHSJJJE),2) AS GSHSJJJE,"
						+"SUM(S.TEMP2) GSXSSR ,round(SUM(GSXSSR), 2) AS XSSR,round(sum(gsvendrebate),2) as gsvendrebate FROM "+goodssaleTable+" S LEFT JOIN INF_SHOP P ON S.GSMFID = P.SHPCODE "
						+"AND S.GSSGCODE = P.SGCODE WHERE 1 = 1");
			}
			if (!StringUtil.isBlank(saleReport.getGssgcode())) {
				log.debug("saleReport.getGssgcode(): "
						+ saleReport.getGssgcode());
				sumSql.append(" and S.GSSGCODE = '").append(
						saleReport.getGssgcode()).append("'");
			}
			if("3006".equals(saleReport.getGssgcode())){
				if ("S".equals(saleReport.getUserType().toString())) {
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						sumSql.append(" and S.GSSUPID = '").append(
								saleReport.getSupcode()).append("'");
					}
				}
			}else {
				if (!StringUtil.isBlank(saleReport.getSupcode())) {
					log.debug("saleReport.getSupcode(): "
							+ saleReport.getSupcode());
					sumSql.append(" and S.GSSUPID = '").append(
							saleReport.getSupcode()).append("'");
				}
			}
			if (!StringUtil.isBlank(saleReport.getGsmfid())) {
				sumSql.append(" and S.GSMFID = '").append(
						saleReport.getGsmfid()).append("'");
			}
			if (!StringUtil.isBlank(saleReport.getStartDate())) {
				log.debug("saleReport.getStartDate(): "
						+ saleReport.getStartDate());
				sumSql.append(" and S.GSRQ >= to_date('").append(
						saleReport.getStartDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(saleReport.getEndDate())) {
				log
						.debug("saleReport.getEndDate(): "
								+ saleReport.getEndDate());
				sumSql.append(" and S.GSRQ <= to_date('").append(
						saleReport.getEndDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(saleReport.getGsmfid())) {
				sumSql.append(" and S.gsmfid = '").append(
						saleReport.getGsmfid()).append("'");
			}
			
			log.info("saleShopSumSql: " + sumSql);
			List lstSumResult = dao.executeSql(sumSql.toString());
			log.debug("shpsum:" + lstSumResult);
			if (lstSumResult != null && lstSumResult.size() > 0) {
				StringBuffer countSql = null;
                if(flag_3010){
                	countSql = new StringBuffer(
					"select count(*) from (select GSMFID,S.GSSUPID from YW_GOODSSALE_M S LEFT JOIN INF_SHOP P ON S.GSMFID=P.SHPCODE AND S.GSSGCODE = P.SGCODE  WHERE 1=1 and S.GSXSSL != 0 ");
                }else if ("3006".equals(saleReport.getGssgcode())) {
                	countSql = new StringBuffer(
					"select count(*) from (select GSMFID from YW_GOODSSALE S LEFT JOIN INF_SHOP P ON S.GSMFID=P.SHPCODE AND S.GSSGCODE = P.SGCODE  WHERE 1=1");
				}else{
                	countSql = new StringBuffer(
					"select count(*) from (select GSMFID,S.GSSUPID from "+goodssaleTable+" S LEFT JOIN INF_SHOP P ON S.GSMFID=P.SHPCODE AND S.GSSGCODE = P.SGCODE  WHERE 1=1");
                }
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					countSql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				if("3006".equals(saleReport.getGssgcode())){
					if ("S".equals(saleReport.getUserType().toString())) {
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							countSql.append(" and S.GSSUPID = '").append(
									saleReport.getSupcode()).append("'");
						}
					}
				}else {
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						countSql.append(" and S.GSSUPID = '").append(
								saleReport.getSupcode()).append("'");
					}
				}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					countSql.append(" and S.GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					countSql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate())
							.append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("saleReport.getEndDate(): "
							+ saleReport.getEndDate());
					countSql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					countSql.append(" and S.gsmfid = '").append(
							saleReport.getGsmfid()).append("'");
				}

				if("3006".equals(saleReport.getGssgcode())){
					countSql.append(" GROUP BY GSMFID) COUNT");
				}else {
					countSql.append(" GROUP BY GSMFID,S.GSSUPID) COUNT");
				}

				log.info("saleShopCountSql: " + countSql);
				List lstResult = dao.executeSqlCount(countSql.toString());
				log.debug("SaleSummaryImpl.getResult() lstResult : "
						+ lstResult);

				if (lstResult != null) {
					log
							.debug("SaleSummaryImpl.getResult() lstResult.get(0).toString() : "
									+ lstResult.get(0).toString());
					result.setTotal(Integer.parseInt(lstResult.get(0)
							.toString()));
				}
				StringBuffer sql = null;
				if("3016".equals(saleReport.getGssgcode())){
					sql=new StringBuffer(
					"SELECT P.SHPCODE,S.GSSUPID,D.SUPNAME,P.SHPNAME,SUM(S.GSXSSL) AS GSXSSL,round(SUM( S.GSXSJE),2) GSXSJE,round(SUM(S.GSHSJJJE),2) AS GSHSJJJE,SUM(S.TEMP2) AS GSXSSR FROM YW_GOODSSALE S LEFT JOIN INF_SHOP P ON S.GSMFID=P.SHPCODE AND S.GSSGCODE = P.SGCODE LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID  WHERE 1=1 and S.GSXSSL != 0 ");
				}else if(flag_3010){
					sql=new StringBuffer(
					"SELECT P.SHPCODE,S.GSSUPID,D.SUPNAME,P.SHPNAME,SUM(S.GSXSSL) AS GSXSSL,round(SUM( S.GSXSSR),2) GSXSJE,round(SUM(S.GSHSJJJE),2) AS GSHSJJJE,SUM(S.TEMP2) AS GSXSSR FROM YW_GOODSSALE_M S LEFT JOIN INF_SHOP P ON S.GSMFID=P.SHPCODE AND S.GSSGCODE = P.SGCODE LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID  WHERE 1=1 and S.GSXSSL != 0 ");
				}else if("3012".equals(saleReport.getGssgcode())){
					sql=new StringBuffer(
					"SELECT P.SHPCODE,S.GSSUPID,D.SUPNAME,P.SHPNAME,SUM(S.GSXSSL) AS GSXSSL,round(SUM( S.GSXSJE),2) GSXSJE,round(SUM(S.GSHSJJJE),2) AS GSHSJJJE,SUM(S.TEMP2) AS GSXSSR FROM YW_GOODSSALE S LEFT JOIN INF_SHOP P ON S.GSMFID=P.SHPCODE AND S.GSSGCODE = P.SGCODE LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID  WHERE 1=1 and S.GSXSSL != 0 ");
				}else if ("3006".equals(saleReport.getGssgcode())) {
					sql=new StringBuffer(
					"SELECT P.SHPCODE,P.SHPNAME,SUM(S.GSXSSL) AS GSXSSL,round(SUM( S.GSXSJE),2) GSXSJE,round(SUM(S.GSHSJJJE),2) AS GSHSJJJE,SUM(S.TEMP2) AS GSXSSR FROM YW_GOODSSALE S LEFT JOIN INF_SHOP P ON S.GSMFID=P.SHPCODE AND S.GSSGCODE = P.SGCODE LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID  WHERE 1=1 ");
				}else{
					sql=new StringBuffer(
					"SELECT P.SHPCODE,S.GSSUPID,D.SUPNAME,P.SHPNAME,SUM(S.GSXSSL) AS GSXSSL,round(SUM( S.GSXSJE),2) GSXSJE,round(SUM(S.GSHSJJJE),2) AS GSHSJJJE,round(SUM(S.GSXSSR), 2) AS XSSR,SUM(S.TEMP2) AS GSXSSR,sum(s.gsvendrebate) as gsvendrebate FROM "+goodssaleTable+" S LEFT JOIN INF_SHOP P ON S.GSMFID=P.SHPCODE AND S.GSSGCODE = P.SGCODE LEFT JOIN INF_SUPINFO D ON S.GSSGCODE=D.SUPSGCODE AND S.GSSUPID=D.SUPID  WHERE 1=1 ");
				}
				int limit = saleReport.getRows();
				log.debug("limit: " + limit);
				int start = (saleReport.getPage() - 1) * saleReport.getRows();
				log.debug("start: " + start);
				if (!StringUtil.isBlank(saleReport.getGssgcode())) {
					log.debug("saleReport.getGssgcode(): "
							+ saleReport.getGssgcode());
					sql.append(" and S.GSSGCODE = '").append(
							saleReport.getGssgcode()).append("'");
				}
				if("3006".equals(saleReport.getGssgcode())){
					if ("S".equals(saleReport.getUserType().toString())) {
						if (!StringUtil.isBlank(saleReport.getSupcode())) {
							log.debug("saleReport.getSupcode(): "
									+ saleReport.getSupcode());
							sql.append(" and S.GSSUPID = '").append(
									saleReport.getSupcode()).append("'");
						}
					}
				}else {
					if (!StringUtil.isBlank(saleReport.getSupcode())) {
						log.debug("saleReport.getSupcode(): "
								+ saleReport.getSupcode());
						sql.append(" and S.GSSUPID = '").append(
								saleReport.getSupcode()).append("'");
					}
				}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					sql.append(" and S.GSMFID = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if (!StringUtil.isBlank(saleReport.getStartDate())) {
					log.debug("saleReport.getStartDate(): "
							+ saleReport.getStartDate());
					sql.append(" and S.GSRQ >= to_date('").append(
							saleReport.getStartDate())
							.append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getEndDate())) {
					log.debug("saleReport.getEndDate(): "
							+ saleReport.getEndDate());
					sql.append(" and S.GSRQ <= to_date('").append(
							saleReport.getEndDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(saleReport.getGsmfid())) {
					sql.append(" and S.gsmfid = '").append(
							saleReport.getGsmfid()).append("'");
				}
				if("3006".equals(saleReport.getGssgcode())){
					sql.append(" GROUP BY P.SHPCODE,P.SHPNAME order by P.SHPCODE");
				}else{
					sql.append(" GROUP BY P.SHPCODE,P.SHPNAME,S.GSSUPID,SUPNAME order by P.SHPCODE asc ");
				}
				log.info("saleShopResultSql: " + sql);
				lstResult = dao.executeSql(sql.toString(), start, limit);
				log.debug("SaleSummaryImpl.getResult() lstResult 1 :"
						+ lstResult);
				if (lstResult != null) {
					log.debug("SaleSummaryImpl.getResult() lstResult.size() :"
							+ lstResult.size());
					result.setReturnCode(Constants.SUCCESS_FLAG);
					result.setFooter(lstSumResult);
					result.setRows(lstResult);
				}
			}
		} catch (Exception ex) {
			log.error("SaleSummaryImpl.getResult() error :" + ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
		return result;
	}
}
