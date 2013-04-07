package com.bfuture.app.saas.service.impl;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.saas.model.report.Ret;
import com.bfuture.app.saas.model.report.TCDocQuery;
import com.bfuture.app.saas.service.TCDocQueryManager;
import com.bfuture.app.saas.util.StringUtil;
import java.util.List;

public class TCDocQueryManagerImpl extends BaseManagerImpl
    implements TCDocQueryManager
{

    public void setDao(UniversalAppDao dao)
    {
        this.dao = dao;
    }

    public TCDocQueryManagerImpl()
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
        if("getTCDocHead".equals(actionType))
        {
            TCDocQuery tCDocQuery = (TCDocQuery)o[0];
            try
            {
                StringBuffer Sql =  new StringBuffer("select A.Bthbillno,A.bththmfid,C.shpname,to_char(A.Bthshtime,'yyyy-MM-dd') Bthshtime,B.BTDSL,B.BTDHSJJJE,A.BTHSUPID,D.SUPNAME ,cast(A.temp5 as varchar2(20))temp5 from yw_btcdhead A,(select SUM(BTDSL) BTDSL,SUM(BTDHSJJJE) BTDHSJJJE,BTDSGCODE,BTDBILLNO, BTDSHMFID from yw_btcddet group by BTDSGCODE,BTDBILLNO, BTDSHMFID) B,inf_shop C,inf_supinfo D where A.BTHSGCODE=C.SGCODE and A.BTHTHMFID=C.SHPCODE and A.BTHSGCODE=B.BTDSGCODE and A.BTHBILLNO=B.BTDBILLNO and D.Supsgcode=A.BTHSGCODE and A.BTHSUPID=D.SUPID   and A.BTHTHMFID=B.BTDSHMFID ");
                StringBuffer count = new StringBuffer(" SELECT COUNT(A.BTHBILLNO) FROM YW_BTCDHEAD A LEFT JOIN INF_SHOP C ON A.BTHSGCODE = C.SGCODE AND A.BTHTHMFID = C.SHPCODE LEFT JOIN INF_SUPINFO D ON  D.SUPSGCODE = A.BTHSGCODE AND A.BTHSUPID = D.SUPID WHERE 1=1 ");
                StringBuffer sumsql =  new StringBuffer(" select cast('\u5408\u8BA1' as varchar2(30)) BTHBILLNO,sum(B.BTDSL) BTDSL,sum(B.BTDHSJJJE) BTDHSJJJE from yw_btcdhead A,yw_btcddet B,inf_shop C,inf_supinfo D where A.BTHSGCODE=C.SGCODE and A.BTHTHMFID=C.SHPCODE and A.BTHSGCODE=B.BTDSGCODE and A.BTHBILLNO=B.BTDBILLNO AND A.BTHTHMFID=B.BTDSHMFID and D.Supsgcode=A.BTHSGCODE and A.BTHSUPID=D.SUPID");
               
                /*查询条件*/
                StringBuffer whereStr =  new StringBuffer(" ");
                if(StringUtil.isNotEmpty(tCDocQuery.getSgcode()))
                	whereStr.append((new StringBuilder(" and A.BTHSGCODE='")).append(tCDocQuery.getSgcode()).append("' ").toString());
                if(StringUtil.isNotEmpty(tCDocQuery.getShopcode()))
                	whereStr.append((new StringBuilder(" and A.BTHTHMFID='")).append(tCDocQuery.getShopcode()).append("' ").toString());
                if(StringUtil.isNotEmpty(tCDocQuery.getSupcode()))
                	whereStr.append((new StringBuilder(" and A.BTHSUPID='")).append(tCDocQuery.getSupcode()).append("' ").toString());
                if(StringUtil.isNotEmpty(tCDocQuery.getBTLLNO()))
                	whereStr.append((new StringBuilder(" and A.BTHBILLNO='")).append(tCDocQuery.getBTLLNO()).append("' ").toString());
                if(StringUtil.isNotEmpty(tCDocQuery.getTemp5()))
                	whereStr.append((new StringBuilder(" and A.temp5='")).append(tCDocQuery.getTemp5()).append("' ").toString());
                if(StringUtil.isNotEmpty(tCDocQuery.getStartDate()))
                	whereStr.append(" and to_char(A.BTHSHTIME,'yyyy-mm-dd') >= '").append(tCDocQuery.getStartDate()).append("'");
                if(StringUtil.isNotEmpty(tCDocQuery.getEndDate()))
                	whereStr.append(" and to_char(A.BTHSHTIME,'yyyy-mm-dd') <= '").append(tCDocQuery.getEndDate()).append("'");
                
                /*合计，总条数查询*/
                sumsql.append(whereStr);
                List lstSumResult = dao.executeSql(sumsql.toString());
                count.append(whereStr);
                List resultNum = dao.executeSqlCount(count.toString());
                int num = Integer.parseInt(resultNum.get(0).toString());
                
                /*分页查询*/
                if(tCDocQuery.getOrder() != null && tCDocQuery.getSort() != null)
                	whereStr.append(" order by ").append(tCDocQuery.getSort()).append(" ").append(tCDocQuery.getOrder());
                Sql.append(whereStr);
                int limit = tCDocQuery.getRows();
                int start = (tCDocQuery.getPage() - 1) * tCDocQuery.getRows();
                List lstResult = dao.executeSql(Sql.toString(), start, limit);
                if(lstResult != null)
                {
                    result.setTotal(num);
                    result.setReturnCode("1");
                    result.setRows(lstResult);
                    result.setFooter(lstSumResult);
                }
            }
            catch(Exception ex)
            {
                log.error((new StringBuilder("TCDocQueryManagerImpl.getRKDocHead() error :")).append(ex.getMessage()).toString());
                result.setReturnCode("0");
                result.setReturnInfo(ex.getMessage());
            }
        } else if("getTCDocDetail".equals(actionType))
        {
            result = getTCDocDetail(o);
        }else if("getHead".equals(actionType))
        {
            result = getHead(o);
        } 
        return result;
    }
    
    public ReturnObject getTCDocDetail(Object[] o){
    	TCDocQuery tCDocQuery = (TCDocQuery)o[0];
    	ReturnObject result = new ReturnObject();
        try
        {   
        	StringBuffer Sql = new StringBuffer("select A.btdgdid,B.Gdname,B.Gdspec,B.Gdunit,A.btdsl,A.btdhsjj,A.btdhsjjje,D.BTHsupid,C.Supname  from yw_btcddet A,inf_goods B,inf_supinfo C,yw_btcdhead D where A.btdbillno=D.bthbillno  and A.btdgdid=B.Gdid  and C.SUPID=D.BTHsupid and c.supsgcode=D.bthsgcode and a.btdshmfid=d.bththmfid and d.bthsgcode=b.gdsgcode ");
        	StringBuffer sumsql = new StringBuffer("select A.btdgdid,sum(A.btdsl)btdsl,A.btdhsjj,sum(A.btdhsjjje)btdhsjjje from yw_btcddet A,inf_goods B,inf_supinfo C,yw_btcdhead D where A.btdbillno=D.bthbillno  and A.btdgdid=B.Gdid  and C.SUPID=D.BTHsupid and c.supsgcode=D.bthsgcode and a.btdshmfid=d.bththmfid and d.bthsgcode=b.gdsgcode");             	
        	StringBuffer count =  new StringBuffer("select count(A.btdgdid) from yw_btcddet A,inf_goods B,inf_supinfo C,yw_btcdhead D where A.btdbillno=D.bthbillno  and A.btdgdid=B.Gdid  and C.SUPID=D.BTHsupid and c.supsgcode=D.bthsgcode and a.btdshmfid=d.bththmfid and d.bthsgcode=b.gdsgcode ");

        	/*查询条件*/
        	StringBuffer whereStr =  new StringBuffer(" ");
            if(StringUtil.isNotEmpty(tCDocQuery.getSgcode()))
            	whereStr.append((new StringBuilder(" and D.bthsgcode='")).append(tCDocQuery.getSgcode()).append("' ").toString());
            if(StringUtil.isNotEmpty(tCDocQuery.getBTLLNO()))
            	whereStr.append((new StringBuilder(" and D.BTHBILLNO='")).append(tCDocQuery.getBTLLNO()).append("' ").toString());
            if(StringUtil.isNotEmpty(tCDocQuery.getShopcode()))
            	whereStr.append((new StringBuilder(" and d.bththmfid='")).append(tCDocQuery.getShopcode()).append("' ").toString());
            
            /*合计，总条数查询*/
            count.append(whereStr);
            List resultNum = dao.executeSqlCount(count.toString());
            int num = Integer.parseInt(resultNum.get(0).toString());
            sumsql.append(whereStr).append(" group by A.btdgdid,A.btdhsjj");
            List lstSumResult = dao.executeSql(sumsql.toString());
            
            /*分页查询*/
            if(tCDocQuery.getOrder() != null && tCDocQuery.getSort() != null)
                Sql.append(" order by ").append(tCDocQuery.getSort()).append(" ").append(tCDocQuery.getOrder());
            int limit = tCDocQuery.getRows();
            int start = (tCDocQuery.getPage() - 1) * tCDocQuery.getRows();
            List lstResult = dao.executeSql(Sql.toString(), start, limit);
            
            if(lstResult != null)
            {
                result.setReturnCode("1");
                result.setTotal(num);
                result.setRows(lstResult);
                result.setFooter(lstSumResult);
            }
            StringBuffer tcdSql = new StringBuffer("UPDATE YW_BTCDSTATUS SET BTHSTATUS = '3' where 1=1 ");
            if(StringUtil.isNotEmpty(tCDocQuery.getBTLLNO()))
                tcdSql.append((new StringBuilder(" and BTHBILLNO='")).append(tCDocQuery.getBTLLNO()).append("' ").toString());
            log.info((new StringBuilder("\u4FEE\u6539\u9000\u8D27\u5355\u72B6\u6001\uFF1A")).append(tcdSql.toString()).toString());
            dao.updateSql(tcdSql.toString());
        }
        catch(Exception ex)
        {
            log.error((new StringBuilder("TCDocQueryManagerImpl.getTCDocDetail() error :")).append(ex.getMessage()).toString());
            result.setReturnCode("0");
            result.setReturnInfo(ex.getMessage());
        }
    	return result;
    }
    
    public ReturnObject getHead(Object[] o){
    	TCDocQuery tCDocQuery = (TCDocQuery)o[0];
    	ReturnObject result = new ReturnObject();
        try
        {
            StringBuffer Sql = new StringBuffer("select h.BTHBILLNO,h.BTHSUPID,h.BTHTHMFID,to_char(h.BTHSHTIME,'yyyy-MM-dd') as BTHSHTIME,h.BTHMEMO,(select distinct(s.shpname) from inf_shop s where s.shpcode=h.BTHTHMFID and s.sgcode=h.bthsgcode ) as shopname ,(select distinct(sup.supname) from inf_supinfo sup where sup.supid=h.BTHSUPID and sup.supsgcode=h.bthsgcode ) as supname from yw_btcdhead h where  '1'='1'  ");
            if(StringUtil.isNotEmpty(tCDocQuery.getSgcode()))
                Sql.append((new StringBuilder(" and h.BTHSGCODE='")).append(tCDocQuery.getSgcode()).append("' ").toString());
            if(StringUtil.isNotEmpty(tCDocQuery.getShopcode()))
                Sql.append((new StringBuilder(" and h.BTHTHMFID='")).append(tCDocQuery.getShopcode()).append("' ").toString());
            if(StringUtil.isNotEmpty(tCDocQuery.getSupcode()))
                Sql.append((new StringBuilder(" and h.BTHSUPID='")).append(tCDocQuery.getSupcode()).append("' ").toString());
            if(StringUtil.isNotEmpty(tCDocQuery.getBTLLNO()))
                Sql.append((new StringBuilder(" and h.BTHBILLNO='")).append(tCDocQuery.getBTLLNO()).append("' ").toString());
            List lstResult = dao.executeSql(Sql.toString());
            if(lstResult != null)
            {
                result.setReturnCode("1");
                result.setRows(lstResult);
            }
        }
        catch(Exception ex)
        {
            log.error((new StringBuilder("tCDocQueryManagerImpl.getHead() error :")).append(ex.getMessage()).toString());
            result.setReturnCode("0");
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