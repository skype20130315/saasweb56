package com.bfuture.app.saas.service.impl;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.saas.model.report.POPQuery;
import com.bfuture.app.saas.service.POPQueryManager;
import com.bfuture.app.saas.util.StringUtil;
import java.util.List;

public class POPQueryManagerImpl extends BaseManagerImpl
    implements POPQueryManager
{

    public void setDao(UniversalAppDao dao)
    {
        this.dao = dao;
    }

    public POPQueryManagerImpl()
    {
        if(dao == null)
            dao = (UniversalAppDao)getSpringBean("universalAppDao");
    }

    public ReturnObject getResult(Object o)
    {
        ReturnObject result = new ReturnObject();
        return result;
    }

    public ReturnObject ExecOther(String actionType, Object o[])
    {
        ReturnObject result = new ReturnObject();
        if("getPOP".equals(actionType))
        {
            POPQuery popQuery = (POPQuery)o[0];
            try
            {	
            	boolean flag_3010="3010".equals(popQuery.getSgcode());
            	StringBuffer Sql = new StringBuffer();
            	if("3006".equals(popQuery.getSgcode())){
            	Sql = new StringBuffer("select p.popsequece,p.pplb,p.ppsupid,p.ppkssj,p.ppjssj,p.ppcxxl,p.ppkl,p.ppzkfd,p.ppcxzt,p.ppsgcode,p.ppmarket,sup.supname,p.ppgdid,g.gdname,to_char(p.ppksrq,'yyyy-MM-dd') as ppksrq,to_char(p.ppjsrq,'yyyy-MM-dd') AS ppjsrq,p.ppcxsj,p.ppyssj,cast(case when pplb='1' then '促销打折' when pplb='0' then '打折率打折' else '' end as varchar2(30)) as DZLX  from yw_popinfo p,inf_goods g ,inf_supinfo sup where sup.supid=p.ppsupid and sup.supsgcode=p.ppsgcode and p.ppgdid=g.gdid and p.ppsgcode=g.gdsgcode ");
            	}else if(flag_3010){
            		Sql = new StringBuffer("select p.popsequece,p.pplb,p.ppsupid,p.ppkssj,p.ppjssj,p.ppcxxl,p.ppkl,p.ppzkfd,p.ppcxzt,p.ppsgcode,p.ppmarket,sup.supname,p.ppgdid,g.gdname,to_char(p.ppksrq,'yyyy-MM-dd') as ppksrq,to_char(p.ppjsrq,'yyyy-MM-dd') AS ppjsrq,p.ppcxsj,p.ppyssj, s.shpname  as shopname,cast(case when pplb='1' then '促销打折' when pplb='0' then '打折率打折' else '' end as varchar2(30)) as DZLX ,p.ppbarcode barcode from yw_popinfo_m p,inf_goods g ,inf_supinfo sup,inf_shop s where s.shpcode=p.ppmarket and s.sgcode=p.ppsgcode and sup.supid=p.ppsupid and sup.supsgcode=p.ppsgcode and p.ppgdid=g.gdid and p.ppsgcode=g.gdsgcode ");
            	}else if("3023".equals(popQuery.getSgcode())){
            		Sql = new StringBuffer("select p.popsequece,p.pplb as DZLX,p.ppsupid,p.ppkssj,p.ppjssj,p.ppcxxl,p.ppkl,p.ppzkfd,p.ppcxzt,p.ppsgcode,p.ppmarket,sup.supname,p.ppgdid,g.gdname,to_char(p.ppksrq,'yyyy-MM-dd') as ppksrq,to_char(p.ppjsrq,'yyyy-MM-dd') AS ppjsrq,p.ppcxsj,p.ppyssj, s.shpname  as shopname from yw_popinfo p,inf_goods g ,inf_supinfo sup,inf_shop s where s.shpcode=p.ppmarket and s.sgcode=p.ppsgcode and sup.supid=p.ppsupid and sup.supsgcode=p.ppsgcode and p.ppgdid=g.gdid and p.ppsgcode=g.gdsgcode ");
            	}else if("3026".equals(popQuery.getSgcode())){//3026沃美年华促销方法
            		Sql = new StringBuffer("select p.popsequece,p.pplb,p.ppsupid,p.ppkssj,p.ppjssj,p.ppcxxl,p.ppkl,p.ppzkfd,p.ppcxzt,p.ppsgcode,p.ppmarket,sup.supname,p.ppgdid,g.gdname,to_char(p.ppksrq,'yyyy-MM-dd') as ppksrq,to_char(p.ppjsrq,'yyyy-MM-dd') AS ppjsrq,p.ppcxsj,p.ppyssj, s.shpname  as shopname,cast(case when pplb='1' then '促销打折' when pplb='0' then '打折率打折' else '' end as varchar2(30)) as DZLX  from yw_popinfo p left join inf_goods g on p.ppgdid=g.gdid and p.ppsgcode=g.gdsgcode left join inf_supinfo sup on sup.supsgcode=p.ppsgcode and sup.supid=p.ppsupid left join inf_shop s on s.shpcode=p.ppmarket and s.sgcode=p.ppsgcode where 1 = 1 ");
            	}else{
                Sql = new StringBuffer("select p.popsequece,p.pplb,p.ppsupid,p.ppkssj,p.ppjssj,p.ppcxxl,p.ppkl,p.ppzkfd,p.ppcxzt,p.ppsgcode,p.ppmarket,sup.supname,p.ppgdid,g.gdname,to_char(p.ppksrq,'yyyy-MM-dd') as ppksrq,to_char(p.ppjsrq,'yyyy-MM-dd') AS ppjsrq,p.ppcxsj,p.ppyssj, s.shpname  as shopname,cast(case when pplb='1' then '促销打折' when pplb='0' then '打折率打折' else '' end as varchar2(30)) as DZLX  from yw_popinfo p,inf_goods g ,inf_supinfo sup,inf_shop s where s.shpcode=p.ppmarket and s.sgcode=p.ppsgcode and sup.supid=p.ppsupid and sup.supsgcode=p.ppsgcode and p.ppgdid=g.gdid and p.ppsgcode=g.gdsgcode ");
            	}
                if(StringUtil.isNotEmpty(popQuery.getSgcode()))
                    Sql.append((new StringBuilder(" and p.ppsgcode='")).append(popQuery.getSgcode()).append("' ").toString());
                if(!"3006".equals(popQuery.getSgcode())){
                	if(StringUtil.isNotEmpty(popQuery.getPopmarket()))
                		Sql.append((new StringBuilder(" and p.ppmarket='")).append(popQuery.getPopmarket()).append("' ").toString());
                }
                if(StringUtil.isNotEmpty(popQuery.getPopsupcode()))
                    Sql.append((new StringBuilder(" and p.ppsupid='")).append(popQuery.getPopsupcode()).append("' ").toString());
                if(StringUtil.isNotEmpty(popQuery.getPopgdid())){
                	if("3006".equals(popQuery.getSgcode())){
                		Sql.append((new StringBuilder(" and g.gdid like '%")).append(popQuery.getPopgdid()).append("%' ").toString());
                	}else{
                		Sql.append((new StringBuilder(" and g.gdid = '")).append(popQuery.getPopgdid()).append("' ").toString());
                	}
                }
                if(StringUtil.isNotEmpty(popQuery.getPopgdname())){
                    Sql.append((new StringBuilder(" and g.gdname like '%")).append(popQuery.getPopgdname()).append("%' ").toString());
                }
                if(StringUtil.isNotEmpty(popQuery.getStartDate())){
                    Sql.append(" and p.PPSHRQ >= to_date('").append(popQuery.getStartDate()).append("','yyyy-MM-dd')");
                }
                if(StringUtil.isNotEmpty(popQuery.getEndDate())){
                    Sql.append(" and p.PPSHRQ <= to_date('").append(popQuery.getEndDate()).append("','yyyy-MM-dd')");
                }
                if(popQuery.getOrder() != null && popQuery.getSort() != null){
                    Sql.append(" order by ").append(popQuery.getSort()).append(" ").append(popQuery.getOrder());
                }
                StringBuffer sumsql = null;
                if(flag_3010){
                	sumsql = new StringBuffer("select cast('\u5408\u8BA1' as varchar2(30) ) popsequece,sum(p.ppcxsj) as ppcxsj, sum(p.ppyssj) as ppyssj  from yw_popinfo_m p,inf_goods g where 1=1  and  p.ppgdid=g.gdid and p.ppsgcode=g.gdsgcode ");
                }else{
                	sumsql = new StringBuffer("select cast('\u5408\u8BA1' as varchar2(30) ) popsequece,sum(p.ppcxsj) as ppcxsj, sum(p.ppyssj) as ppyssj  from yw_popinfo p,inf_goods g where 1=1  and  p.ppgdid=g.gdid and p.ppsgcode=g.gdsgcode ");
                }
                
                if(StringUtil.isNotEmpty(popQuery.getSgcode()))
                    sumsql.append((new StringBuilder(" and p.ppsgcode='")).append(popQuery.getSgcode()).append("' ").toString());
                if(!"3006".equals(popQuery.getSgcode())){
                	if(StringUtil.isNotEmpty(popQuery.getPopmarket()))
                		sumsql.append((new StringBuilder(" and p.ppmarket='")).append(popQuery.getPopmarket()).append("' ").toString());
                }
                if(StringUtil.isNotEmpty(popQuery.getPopsupcode()))
                    sumsql.append((new StringBuilder(" and p.ppsupid='")).append(popQuery.getPopsupcode()).append("' ").toString());
                if(StringUtil.isNotEmpty(popQuery.getPopgdid())){
                	if("3006".equals(popQuery.getSgcode())){
                		sumsql.append((new StringBuilder(" and g.gdid like '%")).append(popQuery.getPopgdid()).append("%' ").toString());
                	}else{
                		sumsql.append((new StringBuilder(" and g.gdid = '")).append(popQuery.getPopgdid()).append("' ").toString());
                	}
                }
                if(StringUtil.isNotEmpty(popQuery.getPopgdname()))
                    sumsql.append((new StringBuilder(" and g.gdname like '%")).append(popQuery.getPopgdname()).append("%' ").toString());
                if(StringUtil.isNotEmpty(popQuery.getStartDate()))
                    sumsql.append(" and p.PPSHRQ >= to_date('").append(popQuery.getStartDate()).append("','yyyy-MM-dd')");
                if(StringUtil.isNotEmpty(popQuery.getEndDate()))
                    sumsql.append(" and p.PPSHRQ <= to_date('").append(popQuery.getEndDate()).append("','yyyy-MM-dd')");
                List lstSumResult = dao.executeSql(sumsql.toString());
                StringBuffer count = null;
                if(flag_3010){
                	count = new StringBuffer("select count(*) from yw_popinfo_m p,inf_goods g where g.gdid=p.ppgdid  AND p.ppsgcode=g.gdsgcode ");
                }else{
                	count = new StringBuffer("select count(*) from yw_popinfo p,inf_goods g where g.gdid=p.ppgdid  AND p.ppsgcode=g.gdsgcode ");
                }
                if(StringUtil.isNotEmpty(popQuery.getSgcode()))
                    count.append((new StringBuilder(" and p.ppsgcode='")).append(popQuery.getSgcode()).append("' ").toString());
                if(!"3006".equals(popQuery.getSgcode())){
                	if(StringUtil.isNotEmpty(popQuery.getPopmarket()))
                		count.append((new StringBuilder(" and p.ppmarket='")).append(popQuery.getPopmarket()).append("' ").toString());
                }
                if(StringUtil.isNotEmpty(popQuery.getPopsupcode()))
                    count.append((new StringBuilder(" and p.ppsupid='")).append(popQuery.getPopsupcode()).append("' ").toString());
                if(StringUtil.isNotEmpty(popQuery.getPopgdid())){
                	if("3006".equals(popQuery.getSgcode())){
                		count.append((new StringBuilder(" and g.gdid like '%")).append(popQuery.getPopgdid()).append("%' ").toString());
                	}else{
                		count.append((new StringBuilder(" and g.gdid = '")).append(popQuery.getPopgdid()).append("' ").toString());
                	}
                }
                if(StringUtil.isNotEmpty(popQuery.getPopgdname()))
                    count.append((new StringBuilder(" and g.gdname like '%")).append(popQuery.getPopgdname()).append("%' ").toString());
                if(StringUtil.isNotEmpty(popQuery.getStartDate()))
                    count.append(" and p.PPSHRQ >= to_date('").append(popQuery.getStartDate()).append("','yyyy-MM-dd')");
                if(StringUtil.isNotEmpty(popQuery.getEndDate()))
                    count.append(" and p.PPSHRQ <= to_date('").append(popQuery.getEndDate()).append("','yyyy-MM-dd')");
                List resultNum = dao.executeSqlCount(count.toString());
                int num = Integer.parseInt(resultNum.get(0).toString());
                int limit = popQuery.getRows();
                int start = (popQuery.getPage() - 1) * popQuery.getRows();
                List lstResult = dao.executeSql(Sql.toString(), start, limit);
                if(lstResult != null)
                {
                    result.setReturnCode("1");
                    result.setRows(lstResult);
                    result.setFooter(lstSumResult);
                    result.setTotal(num);
                }
            }
            catch(Exception ex)
            {
                log.error((new StringBuilder("popQueryManagerImpl.getPOP() error :")).append(ex.getMessage()).toString());
                result.setReturnCode("0");
                result.setReturnInfo(ex.getMessage());
            }
        }else if("getPopHead".equals(actionType)){
        	POPQuery popQuery = (POPQuery)o[0];
        	String sql = "select distinct phbillno,phshpcode,phshpname,to_char(a.billdate,'yyyy-mm-dd')PHBILLNODATE,a.oper_id from yw_popHead a left join  yw_popdetail b "
        		       + "on a.phbillno = b.pdbillno left join inf_goods c on b.pdgdid = c.gdid where 1=1 ";
        	if(StringUtil.isNotEmpty(popQuery.getSgcode())){
        		sql += " and phsgcode='"+popQuery.getSgcode()+"'";
        	}
        	if(StringUtil.isNotEmpty(popQuery.getBillno())){
        		sql += " and phbillno='"+popQuery.getBillno()+"'";
        	}
        	if(StringUtil.isNotEmpty(popQuery.getPopgdname())){
        		sql += " and c.gdname like '"+popQuery.getPopgdname()+"%'";
        	}
        	if(StringUtil.isNotEmpty(popQuery.getStartDate())){
        		sql += " and to_char(billdate,'yyyy-mm-dd')>='"+popQuery.getStartDate()+"'";
        	}
        	if(StringUtil.isNotEmpty(popQuery.getEndDate())){
        		sql += " and to_char(billdate,'yyyy-mm-dd')<='"+popQuery.getEndDate()+"'";
        	}
        	if(popQuery.getOrder() != null && popQuery.getSort() != null){
            	sql += " order by "+popQuery.getSort() +" "+popQuery.getOrder();
            }
        	int limit = popQuery.getRows();
            int start = (popQuery.getPage() - 1) * popQuery.getRows();
        	try {
				List rowsList = dao.executeSql(sql, start, limit);
				List countList = dao.executeSql(sql);
				if(rowsList.size()>0){
					result.setRows(rowsList);
					result.setTotal(countList.size());
					result.setReturnCode(Constants.SUCCESS_FLAG);
				}
			} catch (Exception e) {
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(e.getMessage());
			}	
        }else if("getPopDetail".equals(actionType)){
        	POPQuery popQuery = (POPQuery)o[0];
        	String sql = "select a.pdbillno,a.pdgdid,b.gdbarcode,b.gdname,to_char(a.startdate,'yyyy-mm-dd')startdate,to_char(a.enddate,'yyyy-mm-dd')enddate,"
        			   + "a.old_price,a.new_price,a.buy_num from yw_popdetail a left join inf_goods b on a.pdsgcode = b.gdsgcode and a.pdgdid = b.gdid where 1=1 " ;
        	
        	if(StringUtil.isNotEmpty(popQuery.getSgcode())){
        		sql += " and a.pdsgcode='"+popQuery.getSgcode()+"'";
        	}
        	if(StringUtil.isNotEmpty(popQuery.getBillno())){
        		sql += " and a.pdbillno='"+popQuery.getBillno()+"'";
        	}
        	String sumsql = "select cast('合计' as varchar2(20))pdbillno,sum(old_price)old_price,sum(new_price)new_price,sum(buy_num)buy_num from ("+sql+")";
        	int limit = popQuery.getRows();
            int start = (popQuery.getPage() - 1) * popQuery.getRows();
        	try {
				List rowsList = dao.executeSql(sql, start, limit);
				List countList = dao.executeSql(sql);
				List sumList = dao.executeSql(sumsql);
				if(rowsList.size()>0){
					result.setRows(rowsList);
					result.setTotal(countList.size());
					result.setFooter(sumList);
					result.setReturnCode(Constants.SUCCESS_FLAG);
				}
			} catch (Exception e) {
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(e.getMessage());
			}	
        }else if("getPOPInfo".equals(actionType)){
        	POPQuery popQuery = (POPQuery)o[0];
            try{
            	StringBuffer Sql = new StringBuffer();
                Sql = new StringBuffer("select p.popsequece,p.pplb,p.ppsupid,p.ppkssj,p.ppjssj,p.ppcxxl,p.ppkl,p.ppzkfd,p.ppcxzt,g.gdbarcode barcode,p.ppmarket,sup.supname,"
                    + "p.ppgdid,g.gdname,to_char(p.ppksrq,'yyyy-MM-dd') as ppksrq,to_char(p.ppjsrq,'yyyy-MM-dd') AS ppjsrq,p.ppcxsj,p.ppyssj,p.pplb as DZLX,p.temp1 "
                    + "from yw_popinfo p left join inf_goods g on p.ppgdid = g.gdid and p.ppsgcode = g.gdsgcode left join inf_supinfo sup on sup.supid = p.ppsupid "
                    + "and sup.supsgcode = p.ppsgcode where 1=1");
                if(StringUtil.isNotEmpty(popQuery.getSgcode()))
                    Sql.append((new StringBuilder(" and p.ppsgcode='")).append(popQuery.getSgcode()).append("' ").toString());
                if(StringUtil.isNotEmpty(popQuery.getPopsupcode()))
                    Sql.append((new StringBuilder(" and p.ppsupid='")).append(popQuery.getPopsupcode()).append("' ").toString());
                if(StringUtil.isNotEmpty(popQuery.getPopgdid())){
                	Sql.append((new StringBuilder(" and p.ppgdid = '")).append(popQuery.getPopgdid()).append("' ").toString());
                }
                if(StringUtil.isNotEmpty(popQuery.getPopgdname())){
                    Sql.append((new StringBuilder(" and g.gdname like '%")).append(popQuery.getPopgdname()).append("%' ").toString());
                }
                if(StringUtil.isNotEmpty(popQuery.getStartDate())){
                    Sql.append(" and p.temp1 >= '"+popQuery.getStartDate()+"'");
                }
                if(StringUtil.isNotEmpty(popQuery.getEndDate())){
                	Sql.append(" and p.temp1 <= '"+popQuery.getEndDate()+"'");
                }
                if(popQuery.getOrder() != null && popQuery.getSort() != null){
                    Sql.append(" order by ").append(popQuery.getSort()).append(" ").append(popQuery.getOrder());
                }
                int limit = popQuery.getRows();
                int start = (popQuery.getPage() - 1) * popQuery.getRows();
                List lstResult = dao.executeSql(Sql.toString(), start, limit);
                if(lstResult != null)
                {
                    result.setReturnCode("1");
                    result.setRows(lstResult);
                    result.setTotal(dao.executeSql(Sql.toString()).size());
                }
            }catch(Exception ex)
            {
                log.error((new StringBuilder("popQueryManagerImpl.getPOPInfo() error :")).append(ex.getMessage()).toString());
                result.setReturnCode("0");
                result.setReturnInfo(ex.getMessage());
            }
        }
        return result;
    }

}