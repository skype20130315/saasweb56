<%@ page language="java" contentType="text/html; charset=GBK"pageEncoding="GBK"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.bfuture.app.basic.AppSpringContext"%>
<%@page import="com.bfuture.app.saas.service.YwBorderdetManager"%>
<%@page import="com.bfuture.app.saas.model.YwBorderdet"%>
<%@page import="com.bfuture.app.basic.model.ReturnObject"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.bfuture.app.saas.model.YwBorderhead"%>
<%@page import="com.bfuture.app.saas.service.YwBorderheadManager"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="com.bfuture.app.basic.util.xml.StringUtil"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>������ѯ--������ϸ--��ӡ��ϸ</title>
<style type="text/css">
<!--
.STYLE4 {color: #000000; font-weight: bold; }
.STYLE5 {
	color: #000000;
	font-weight: bold;
	font-size: 24px;
}
-->
</style>
</head>
	<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
		SysScmuser scmuser = (SysScmuser)obj;
		String sgcode = scmuser.getSgcode();
		AppSpringContext appContext = AppSpringContext.getInstance();
		YwBorderdetManager ybdetManager = (YwBorderdetManager)appContext.getAppContext().getBean("ywBorderdet");
		YwBorderheadManager ybheadManager = (YwBorderheadManager)appContext.getAppContext().getBean("ywBorderhead");
		
		YwBorderdet borderdet = new YwBorderdet();
		
		borderdet.setBodsgcode(request.getParameter("bodsgcode")); // ʵ������
		borderdet.setBodbillno(request.getParameter("bodbillno")); // �������
		borderdet.setBodshmfid(request.getParameter("bodshmfid")); // �ŵ���
		
		ReturnObject resultDet = ybdetManager.SearchYwBorderdet(new Object[]{borderdet});
		List borderdetList = resultDet.getRows();     // �б�����
		List borderdetFooter = resultDet.getFooter(); // �ϼ�����
		Map borderFooterMap = (Map)borderdetFooter.get(0); // �ϼ�����
		
		// �����Ƕ���ͷ����
		YwBorderhead borderhead = new YwBorderhead();
		
		borderhead.setBohsgcode(request.getParameter("bodsgcode")); // ʵ������
		borderhead.setBohbillno(request.getParameter("bodbillno")); // �������
		borderhead.setBohmfid(request.getParameter("bodshmfid"));   // �ŵ���
		ReturnObject resultHead = ybheadManager.SearchYwBorderhead(new Object[]{borderhead});
		List borderheadList = resultHead.getRows();
		Map borderheadMap = (Map)borderheadList.get(0); // �����б�����Ϣ
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd");
		
		//��ȡʵ��������
		List insList = null;
		Map lnsMap = null;
		ReturnObject resultIns = ybheadManager.searchIns(sgcode);
		if(resultIns.getRows().size()!= 0){
		  insList = resultIns.getRows();
		  lnsMap = (Map)insList.get(0);
		}
 	%>
<body>
<table width="1000" border="0" align="center" style="font-size: 20px;">
  <tr>
    <td height="90" colspan="7">
    	<div align="center" class="STYLE5">
    		<%if(lnsMap != null){%>
    		<h2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=StringUtil.nullToBlank(lnsMap.get("OI_CN")) %>��Ʒ������</h2>
    		<%}else{%>
    		<h2>��Ʒ������</h2>
    		<%}%>
    	</div>
    </td>
  </tr>
  <tr>
    <td colspan="12">&nbsp;</td>      
  </tr>
  <tr>
  	<td colspan="6"><span class="STYLE3"></span></td>
    <td colspan="6" id="ysx" style="display: none;"><span class="STYLE3">����Ч</span></td>
  </tr>
  <tr>
    <td colspan="6"><span class="STYLE3">���ݱ��</span>��<%=borderheadMap.get("BOHBILLNO") %></td>
    <%if(!"3018".equals(scmuser.getSgcode())){ %>
    <td id="bjlshfs" style="display: none;"><span class="STYLE3">�ͻ���ʽ��</span><%=borderheadMap.get("TEMP1").equals("1")?"ֱ��":borderheadMap.get("TEMP1").equals("2")?"ֱͨ":"����"%></td>
    <%}else{%>
    <td id="bjlshfs" style="display: none;"><span class="STYLE3">�ͻ���ʽ��</span>ֱ��</td>
    <%}%>
  </tr>
  <tr>
    <td colspan="6"><span class="STYLE3">�ջ��ŵ�</span>��<%=borderheadMap.get("BOHMFID") %><%=borderheadMap.get("SHPNAME") %></td>
    <% Object dhrq = borderheadMap.get("BOHDHRQ");%>
    <td colspan="3"><span class="STYLE3">��������</span>��<%=dhrq!=null && !"".equals(dhrq) ? dhrq : "" %></td>
    <%if("3008".equals(scmuser.getSgcode())){%>
	    <% Object qxrq = borderheadMap.get("BOHQXTIME");%>
	    <td colspan="3"><span class="STYLE3">��Ч����</span>��<%=qxrq!=null ? qxrq : "" %></td>
    <%}%>
  </tr>
  <tr>
    <td colspan="6"><span class="STYLE3">��&nbsp;Ӧ&nbsp;��</span>��<%=borderheadMap.get("BOHSUPID") %><%=borderheadMap.get("SUNAME") %></td>
     <% if(!"3018".equals(scmuser.getSgcode())){%>
	    <% Object jhrq = borderheadMap.get("BOHJHRQ"); %>
	    <%if("3008".equals(scmuser.getSgcode())){%>
	    <td colspan="3"><span class="STYLE3">Ԥ�����գ�<%=jhrq!=null && !"".equals(jhrq) ? jhrq : "" %></td>
	    <%}else{%>
	    <td colspan="3"><span class="STYLE3"><%="3004".equals(scmuser.getSgcode()) ? "��" : "��" %>��<%="3016".equals(scmuser.getSgcode())||"3010".equals(scmuser.getSgcode()) ? "��ֹ" : "" %>����</span>��<%=jhrq!=null && !"".equals(jhrq) ? jhrq : "" %></td>
	    <%}%>	
    <%}else{%> 
	    <% Object qxrq = borderheadMap.get("BOHQXTIME");%>
	    <td><span class="STYLE3">��Ч����</span>��<%=qxrq!=null ? qxrq : "" %></td>
    <%}%>
  </tr>
  <tr>
    <td id="bjlshdz" colspan="6" style="display: none;">
    	<span class="STYLE3">�ͻ���ַ</span>��<%=borderheadMap.get("ADDRESS")%>
    </td>
    <td id="bjlyydh" style="display: none;"><span class="STYLE3">ԤԼ�绰</span>��<%=borderheadMap.get("LINKTELE")%></td>
  </tr>
  <tr>
  	<td id="bjlOrderDemo" style="display: none" colspan="7">
  		<%=sgcode.equals("3016")?"null".equals(borderheadMap.get("BOHMEMO"))?"":borderheadMap.get("BOHMEMO"):""%>
  	</td>
  </tr>
</table>

<table width="1000" border="1" cellpadding="1" cellspacing="0" align="center" style="font-size: 20px;">
  <tr>
    <td bgcolor="#CCCCCC"><span class="STYLE4">���</span></td>
    <td bgcolor="#CCCCCC"><span class="STYLE4">��Ʒ���</span></td>
    <%if(!("3028".equals(scmuser.getSgcode()))) {%>
    <td bgcolor="#CCCCCC"><span class="STYLE4">��Ʒ����</span></td>
    <%}%>
    <td bgcolor="#CCCCCC"><span class="STYLE4">��Ʒ����</span></td>
    <td bgcolor="#CCCCCC"><span class="STYLE4">���</span></td>
    <%if(!("3029".equals(scmuser.getSgcode()))){%>
    <td bgcolor="#CCCCCC"><span class="STYLE4">˰��</span></td>
    <%}%>
    <td bgcolor="#CCCCCC"><span class="STYLE4">��λ</span></td>
    <td bgcolor="#CCCCCC"><span class="STYLE4">������</span></td>
    <%if("3018".equals(scmuser.getSgcode())) {%>
    <td bgcolor="#CCCCCC"><span class="STYLE4">ʵ������</span></td>
    <td bgcolor="#CCCCCC"><span class="STYLE4">ʵ�ս���</span></td>
    <% }%>
     <%if(!(  "3005".equals(scmuser.getSgcode()) || "3018".equals(scmuser.getSgcode()))) {%>
        <%if("3029".equals(scmuser.getSgcode())){%>
        	<td bgcolor="#CCCCCC"><span class="STYLE4">��˰����</span></td>
	        <td bgcolor="#CCCCCC"><span class="STYLE4">�������</span></td>
        <%}else if(!("3003".equals(scmuser.getSgcode()))) {%>
	      <td bgcolor="#CCCCCC"><span class="STYLE4">��˰����</span></td>
	      <td bgcolor="#CCCCCC"><span class="STYLE4">�ɱ����</span></td>
        <% }%>
    <% }%>
 	<%if(!"3018".equals(scmuser.getSgcode())) {%>   
    <td bgcolor="#CCCCCC"><span class="STYLE4">ʵ��</span></td>
    <% }%>
    <%
    	if(!sgcode.equals("3016")){
    %>
    	<td bgcolor="#CCCCCC"><span class="STYLE4">��ע</span></td>
    <%		
    	}
    %>
    <%
    	if(sgcode.equals("3003")){
    %>
    	<td bgcolor="#CCCCCC"><span class="STYLE4">��λ��</span></td>
    <%		
    	}
    %>
    
  </tr>
  
  <!-- ѭ���б�ʼ -->
  <% 
  	if(borderdetList != null && borderdetList.size() > 0){
  		for(int i = 0;i < borderdetList.size();i++){
  			Map bdtmap = (Map)borderdetList.get(i);
  			
  			%>
  			  <tr>
			    <td><%=(i+1) %></td>
			    <td><%=bdtmap.get("BODGDID") %>&nbsp;</td>
			    <%if(!("3028".equals(scmuser.getSgcode()))) {%>
			    <td><%=bdtmap.get("GDBARCODE") %>&nbsp;</td>
			    <%} %>
			    <td><%=bdtmap.get("GDNAME") %>&nbsp;</td>
			    <td><%=bdtmap.get("GDSPEC") %>&nbsp;</td>
			    <%if(!("3029".equals(scmuser.getSgcode()))){%>
			     <td><%=bdtmap.get("BODTAX") %>&nbsp;</td>
			    <%}%>
			    <td><%=bdtmap.get("GDUNIT") %>&nbsp;</td>
			    <td><%=bdtmap.get("BODSL") %>&nbsp;</td>
			    <%if("3018".equals(scmuser.getSgcode())) {%>
			    <td>&nbsp;</td>  <!-- ���ø�ֵ���û��ֹ���д����ռλ -->
			    <td>&nbsp;</td>
			    <% }%>
			    <%if(!( "3005".equals(scmuser.getSgcode()) || "3018".equals(scmuser.getSgcode()) )) {%>
			       <%if(!("3003".equals(scmuser.getSgcode()))) {%>
				    <td><%=bdtmap.get("BODHSJJ") %>&nbsp;</td>
				    <td><%=bdtmap.get("BODHSJJJE") %>&nbsp;</td>
				   <% }%>
			    <% }%>
			    <td>&nbsp;</td>
			    <%
			    	if(!(sgcode.equals("3016") || "3018".equals(scmuser.getSgcode()) )){
			    %>
			    	<td>&nbsp;</td>
			    <% 
			    	}
			    %>
			    <%
			    	if(sgcode.equals("3003") || "3003".equals(scmuser.getSgcode() )){
			    %>
			    	<td><%=bdtmap.get("TEMP5") %></td>
			    <% 
			    	}
			    %>
			  </tr>
  			<%
  		}
  	}
  %>
  <!-- ѭ���б���� -->
  
  <tr>
    <% if(sgcode.equals("3028") || sgcode.equals("3029") ){%>
    	  <td colspan="6">�ϼƣ�</td>
    <% }else{ %>
         <td colspan="7">�ϼƣ�</td>
    <%} %>
    
    <td><%=borderFooterMap.get("BODSL") %></td>
     <%if(!( "3005".equals(scmuser.getSgcode()) || "3018".equals(scmuser.getSgcode()) )) {%>
       <%if(!("3003".equals(scmuser.getSgcode()))) {%>
	    <td>&nbsp;</td>
	    <td><%=borderFooterMap.get("BODHSJJJE") %></td>
	   <% }%>  
     <% }%>
    	  <td>&nbsp;</td>

    <%if("3018".equals(sgcode)) {%>
    	<td>&nbsp;</td>
     <% }%>
    <%
    	if(!sgcode.equals("3016")){
    %>
    	  <td>&nbsp;</td>
    <% 
    	}
    %>
    <%
    	if(sgcode.equals("3003")){
    %>
    	  <td>&nbsp;</td>
    <% 
    	}
    %>
  </tr>
  
</table>

<table width="1000" border="0" align="center" style="font-size: 20px;">
  <%if("3018".equals(scmuser.getSgcode())){%>
  <tr>
    <td>�ջ��Σ�</td>
    <td>����Σ�</td>
    <td>��Ʒ�Σ�</td>
    <td>��Ӧ�̣�</td>
  </tr>
  	<%}else{%>
  <tr>
    <td>�ɹ�Ա��</td>
    <td>�ջ��ˣ�</td>
    <td>��Ӧ�̣�</td>
    <td>�˲��ˣ�</td>
    <%
    	if(sgcode.equals("3003")){
    %>
    <td>�����ˣ�<%=borderheadMap.get("TEMP5")==null?"":borderheadMap.get("TEMP5")%></td>
    <% 
    	}
    %>
  </tr>
  <%} %>
</table>
<script language="javascript">
	if("<%=sgcode%>"=="3016" || "<%=sgcode%>"=="3018"){
		document.getElementById("ysx").style.display="";
		document.getElementById("bjlshfs").style.display="";
		document.getElementById("bjlshdz").style.display="";
		document.getElementById("bjlyydh").style.display="";
		document.getElementById("bjlOrderDemo").style.display="";
	}
</script>
</body>
</html>
