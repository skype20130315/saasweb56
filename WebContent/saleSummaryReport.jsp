<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=GBK">

<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
		SysScmuser currUser = (SysScmuser)obj;
		//��þ�Ӫ��ʽ
		String jyfs = currUser.getSuflag() + "";
		System.out.print("---------"+jyfs);
	%>

<title>���ۻ��ܲ�ѯ</title>
<style>  
a:hover { 
	text-decoration: underline;
	color: red
}
</style>
<script type="text/javascript">	 
		var now = new Date(); 
		now.setDate( now.getDate() - 7 );
		$("#startDate").val( now.format('yyyy-MM-dd') );
		$("#endDate").attr("value",new Date().format('yyyy-MM-dd'));
	    
		$(function(){
			$('#saleShopSummary').datagrid({	
			    title: '',	
				width: User.sutype == 'L' ? 836 :(User.sgcode=='3009'?626:486) ,
				nowrap: false,
				striped: true,
				url:'',		
				fitColumns:false,
				remoteSort: true,
				singleSelect: true,
				showFooter:true,				
				loadMsg:'��������...',				
				columns:[[				
					{field:'SHPCODE',title:'�ŵ����',width:120,align:'center',
						formatter:function(value,rec){
								if(value == '�ϼ�'){
									return "<span style='color:#4574a0; font-weight:bold;'>"+value+"</span>";
								}
								var shopCode = "'" + value + "'";
								var supid = "'" + rec.GSSUPID + "'";
								return '<a href="#" style=" color:#4574a0; font-weight:bold;" onClick="reloadShopSalegrid(' +  shopCode + ','+ supid +');">' + value + '</a>';											
						}
					},
					{field:'SHPNAME',title:'�ŵ�����',width:200,align:'center',sortable:true},
					<%if("3025".equals(currUser.getSgcode().toString())){%>
					{field:'GSXSSL',title:'��������',width:70,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}else if("3031".equals(currUser.getSgcode().toString())){%>
						{field:'GSXSSL',title:'����С��',width:70,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}else{%>
					{field:'GSXSSL',title:'��������',width:70,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}					
					<%}%>
					<%if(!"3026".equals(currUser.getSgcode().toString())){
						if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						,{field:'GSHSJJJE',title:'��˰�ɱ�',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						,{field:'GSXSJE',title:'��˰��������',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}if(!"3027".equals(currUser.getSgcode())){%>
						,{field:'GSHSJJJE',title:<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�',<%}else if("3031".equals(currUser.getSgcode().toString())){%>'���۽��',<%}else{%>'���۳ɱ�',<%}%>
						width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else if("3027".equals(currUser.getSgcode())){%>
							,{field:'GSVENDREBATE',title:'��Ӧ�̳е��ۿ�',width:100,align:'center',sortable:true}	
						<%}
					}%>
						<%if("3009".equals(currUser.getSgcode().toString())&&"S".equalsIgnoreCase( currUser.getSutype().toString())){%>
						,{field:'GSXSJE',title:'���۽��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'MLL',title:'ë����',width:80,align:'center',sortable:true}
						<%}%>
						<%if("3007".equals(currUser.getSgcode().toString())&&"S".equalsIgnoreCase( currUser.getSutype().toString())){%>
						,{field:'XSSR',title:'���۽��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}%>
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					   <%if("3007".equals(currUser.getSgcode().toString())){%>
						,{field:'XSSR',title:'���۽��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else{
						if("3027".equals(currUser.getSgcode().toString())){%>
						,{field:'GSXSJE',title:'��˰��������',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'GSHSJJJE',title:'��˰�ɱ�',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else if("3031".equals(currUser.getSgcode().toString())){%>
							,{field:'GSXSJE',title:'���С��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});}}
						<%}else{%>
							,{field:'GSXSJE',title:'���۽��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});}}
						<%}%>
						<%}%>
						<%if(("3009".equals(currUser.getSgcode().toString()))){%>
						,{field:'MLL',title:'ë����',width:70,align:'center',sortable:true}
						<%}%>
						,{field:'GSSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'��Ӧ������',width:200,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true	
			});
			
			//����������̣�����ʾ��Ӧ�������
			if(User.sutype == 'L'){
				$("#supcodeDiv").show();
				$("#saleExportExcel").width(836);
			}else{
				$("#supcodeDiv").hide();
			}
			
			if(User.sgcode=='3018'){
			 $('#supcode').combobox({
				width: 154,
				valueField:'SUPCODE',
				textField:'SUNAME'
			});	 
			}  
			//
			$('#saleShopDetail').datagrid({		
				title: '',	
				width: User.sutype == 'L' ? 765 : (User.sgcode=='3009'?553:500),
				nowrap: false,
				striped: true,
				url:'',		
				fitColumns:false,
				remoteSort: true,
				singleSelect: true,
				showFooter:true,				
				loadMsg:'��������...',				
				columns:[[
			        {field:'GSRQ',title:'��������',width:100,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if(value == '�ϼ�'){
									return "<span style='color:#4574a0; font-weight:bold;'>"+value+"</span>";
								}	
			        		var gsrq = "'" + value + "'";
			        		var supid = "'" + rec.GSSUPID + "'";
			        		return '<a href="#" style=" color:#4574a0; font-weight:bold;" onClick="reloadGsrqSalegrid(' +  gsrq + ','+supid+');">' + value + '</a>';	       		        	 	        		
						
						}
			        },
					<%if("3025".equals(currUser.getSgcode().toString())){%>
					{field:'GSXSSL',title:'��������',width:120,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					<%}else if("3031".equals(currUser.getSgcode().toString())){%>
						{field:'GSXSSL',title:'����С��',width:120,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}},
					<%}else{%>
					{field:'GSXSSL',title:'��������',width:120,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}},
					<%}%>
					<%if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
					{field:'GSHSJJJE',title:'���۳ɱ�',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}} 
					<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
					{field:'GSXSJE',title:'���۽��',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}} 
					<%}else{%>
					{field:'GSHSJJJE',title:<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�',<%}else if("3031".equals(currUser.getSgcode().toString())){%>'���۽��',<%}else{%>'���۳ɱ�',<%}%>width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}} 
					<%}%>
						<%if(("3009".equals(currUser.getSgcode().toString()))&&"S".equalsIgnoreCase( currUser.getSutype().toString())){%>
						,{field:'GSXSJE',title:'���۽��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'MLL',title:'ë����',width:100,align:'center',sortable:true}
						<%}%>
						<%if(("3007".equals(currUser.getSgcode().toString()))&&"S".equalsIgnoreCase( currUser.getSutype().toString())){%>
						,{field:'XSSR2',title:'���۽��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}%>
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					<%if(("3007".equals(currUser.getSgcode().toString()))){%>
						,{field:'XSSR2',title:'���۽��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else if(("3031".equals(currUser.getSgcode().toString()))){%>
							,{field:'GSXSJE',title:'���С��',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else{%>
						,{field:'GSXSJE',title:'���۽��',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}%>
						<%if(("3009".equals(currUser.getSgcode().toString()))){%>
						,{field:'MLL',title:'ë����',width:90,align:'center',sortable:true}
						<%}%>
						,{field:'GSSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'��Ӧ������',width:200,align:'center',sortable:true}
					<%
					}
					%>
				]],
				pagination:true,
				rownumbers:true			
			});
			//
			$('#saleGsrqDetail').datagrid({
				width: User.sutype == 'L' ? 1048 :698,
				iconCls:'icon-save',
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				fitColumns:false,			
				remoteSort: true,	
				singleSelect: true,	
				showFooter:true,
				loadMsg:'��������...',				
				columns:[[	
				     <%if("3009".equals(currUser.getSgcode().toString())){%>
				     {field:'GSRQ',title:'��������',width:80,align:'center',sortable:true},
				     <%}%>
					<%if("3006".equals(currUser.getSgcode().toString())){%>
						{field:'GDID',title:'��Ʒ����',width:60,align:'center',sortable:true},
						
					<%}else{%>
						{field:'GDID',title:'��Ʒ����',width:80,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if (value == null || value == 'null')
			        		{
			        			return '';
			        		}			  
			        		else
			        		{
			        			if(value == '�ϼ�'){
									return "<span style='color:#4574a0; font-weight:bold;'>"+value+"</span>";
								}
			        			var gdid = "'" + value + "'";
			        			var supid = "'" + rec.GSSUPID + "'";
			        			if("S"=="<%=currUser.getSutype()+""%>" && "3008"=="<%=currUser.getSgcode()%>"){
			        				return value;
			        			}else{
			        				return '<a href="#" style=" color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' +  gdid + ','+supid+');">' + value + '</a>';	
			        			}
			        			 
			        		} 							
						}
			        },
					<%}%>
					
			        <%if("3010".equals(currUser.getSgcode()) || "3018".equals(currUser.getSgcode()) || "3027".equals(currUser.getSgcode()) || "3028".equals(currUser.getSgcode())){%>
			        {field:'BARCODE',title:'��Ʒ����',width:100,align:'center',sortable:true},<%}%>
			        <%if("3029".equals(currUser.getSgcode())){%>
			        {field:'GSRQ',title:'��������',width:100,align:'center',sortable:true},
			        <%}%>
				    {field:'GDNAME',title:'��Ʒ����',width:300,align:'left',sortable:true},	
				    {field:'GDSPEC',title:'���',width:70,align:'center',sortable:true},
				    {field:'GDUNIT',title:'��λ',width:70,align:'center',sortable:true},
					<%if("3025".equals(currUser.getSgcode().toString())){%>
					{field:'GSXSSL',title:'��������',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					<%}else if("3031".equals(currUser.getSgcode().toString())){%>
					{field:'GSXSSL',title:'����С��',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}	
					<%}else{%>
					{field:'GSXSSL',title:'��������',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}			
					<%}%>	
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						,{field:'TEMP5',title:'�ۼ�',width:70,align:'center',sortable:true}
					<%}%>
					<%if((!"3026".equals(currUser.getSgcode().toString()))&&"S".equalsIgnoreCase( currUser.getSutype().toString())){
						if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						,{field:'GSXSSR',title:'���۳ɱ�',width:100,align:'center',sortable:true,formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{   
							decimalPlaces: 2,thousandsSeparator :','
							});
						}}
						<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						,{field:'GSXSJE',title:'���۽��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else if("3031".equals(currUser.getSgcode())){%>
						,{field:'GSXSSR',title:'���۽��',width:100,align:'center',sortable:true,formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{   
							decimalPlaces: 2,thousandsSeparator :','
							});
						}}
						<%}else{%>
						,{field:'GSXSSR',title:'���۳ɱ�',width:100,align:'center',sortable:true,formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{   
							decimalPlaces: 2,thousandsSeparator :','
							});
						}}
						<%}
					}%>
						<%if(("3009".equals(currUser.getSgcode().toString()))&&"S".equalsIgnoreCase( currUser.getSutype().toString())){%>
						,{field:'GSXSJE',title:'���۽��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'MLL',title:'ë����',width:70,align:'center',sortable:true}
						<%}%>
							<%if("3007".equals(currUser.getSgcode().toString())&&"S".equalsIgnoreCase( currUser.getSutype().toString())){%>
						,{field:'XSSR',title:'���۽��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}%>
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						<%if("3007".equals(currUser.getSgcode().toString())){%>
						,{field:'XSSR',title:'���۽��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else if("3031".equals(currUser.getSgcode().toString())){%>
						,{field:'GSXSJE',title:'���С��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else{%>
						,{field:'GSXSJE',title:'���۽��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}%>
						<%if(("3009".equals(currUser.getSgcode().toString()))){%>
						,{field:'MLL',title:'ë����',width:70,align:'center',sortable:true}
						<%}%>
						,{field:'GSSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( User.sgcode=='3009'&&value != null && value != undefined ){
							return (value+'').substring(0,3);
							}else if(User.sgcode=='3009'){
							return '';
							}else{
							return value;}
						}},	
						{field:'SUPNAME',title:'��Ӧ������',width:200,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			//
			$('#ItemStock').datagrid({
				width: User.sutype == 'L' ? 935 : 685,
				iconCls:'icon-save',
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',	
				showFooter:true,
				fitColumns:false,				
				remoteSort: true,	
				singleSelect: true,	
				loadMsg:'��������...',				
				columns:[[
					<%if("3029".equals(currUser.getSgcode())){%>
			        {field:'KCRQ',title:'�������',width:100,align:'center',sortable:true},<%}%>
					{field:'SHPCODE',title:'�ŵ����',width:100,align:'center',sortable:true},
				    {field:'SHPNAME',title:'�ŵ�����',width:300,align:'center',sortable:true},	
				     <%if("3029".equals(currUser.getSgcode().toString()) && "S".equals(currUser.getSutype()+"")){%>
						{field:'ZSKCSL',title:'�������',width:55,align:'center',sortable:true,formatter:function(value,rec){
							if(parseFloat(value)>0){
								return value;
							}else{
								return 0;
							}
						}},
						{field:'ZSKCJE',title:'�����۽��',width:150,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined && parseFloat(value)>0){
								return formatNumber(value,{decimalPlaces: 2,thousandsSeparator :','});
							}else{
								return 0;
							}
						}}
					<%}else{%>
						{field:'ZSKCSL',title:'�������',width:55,align:'center',sortable:true},
						{field:'ZSKCJE',title:'�����۽��',width:150,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}%>
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'SSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'��Ӧ������',width:200,align:'center',sortable:true}
					<%
					}
					%>
				]],
				pagination:true,
				rownumbers:true	
			});
		});			
		
		//����excel
		function exportExcel(){
			//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���
			var supcode = '';
			if(User.sutype == 'L' && User.sgcode=='3018'){
				supcode = $('#supcode').combobox('getValue');
				
			}else if(User.sutype == 'L' && User.sgcode!=='3018'){
			supcode = $('#supcode').val();
				
			}else {
			supcode = User.supcode;
			}  
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : <%if(currUser.getSgcode().equals("3009")){%>'getShopSale_JM'<%}else{%>'datagrid'<%}%>,
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,
									<%if("L".equalsIgnoreCase( currUser.getSutype().toString())&&("3026".equals(currUser.getSgcode().toString()))){
									%>								
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSXSJE','GSSUPID','SUPNAME' ],
										cnTitle: ['�ŵ����','�ŵ�����','��������','���۽��','��Ӧ�̱���','��Ӧ������'],	
									<%}else if("L".equalsIgnoreCase( currUser.getSutype().toString())&&("3009".equals(currUser.getSgcode().toString()))){
									%>								
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSHSJJJE','GSXSJE','MLL','GSSUPID','SUPNAME' ],
										cnTitle: ['�ŵ����','�ŵ�����','��������','���۳ɱ�','���۽��','ë����','��Ӧ�̱���','��Ӧ������'],										
									<%}else if("L".equalsIgnoreCase( currUser.getSutype().toString())&&("3027".equals(currUser.getSgcode().toString()))){%>
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSXSJE','GSHSJJJE','GSSUPID','SUPNAME','GSVENDREBATE' ],
										cnTitle: ['�ŵ����','�ŵ�����','��������','��˰��������','��˰�ɱ�','��Ӧ�̱���','��Ӧ������','��Ӧ�̳е��ۿ�'],
									<%}else if("L".equalsIgnoreCase( currUser.getSutype().toString())&&("3031".equals(currUser.getSgcode().toString()))){%>
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSXSJE','GSHSJJJE','GSSUPID','SUPNAME' ],
										cnTitle: ['�ŵ����','�ŵ�����','����С��','���С��','���۽��','��Ӧ�̱���','��Ӧ������'],
									<%}else if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){%>
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSXSJE','GSHSJJJE','GSSUPID','SUPNAME' ],
										cnTitle: ['�ŵ����','�ŵ�����','��������','���۽��',<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�'<%}else{%>'���۽��'<%}%>,'��Ӧ�̱���','��Ӧ������'],
									<%}else{
										if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSHSJJJE','GSVENDREBATE'],
											cnTitle: ['�ŵ����','�ŵ�����','��������','��˰�ɱ�','��Ӧ�̳е��ۿ�'],
										<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSXSJE','GSVENDREBATE'],
											cnTitle: ['�ŵ����','�ŵ�����','��������','��˰��������','��Ӧ�̳е��ۿ�'],
									<%}else if("S".equalsIgnoreCase( currUser.getSutype().toString())&&("3009".equals(currUser.getSgcode().toString()))){
									%>								
									    enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSHSJJJE','GSXSJE','MLL' ],
										cnTitle: ['�ŵ����','�ŵ�����','��������','���۳ɱ�','���۽��','ë����'],										
									<%}else if("S".equalsIgnoreCase( currUser.getSutype().toString())&&("3031".equals(currUser.getSgcode().toString()))){%>
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSHSJJJE' ],
										cnTitle: ['�ŵ����','�ŵ�����','����С��','���۽��'],
									<%}else{%>
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSHSJJJE' ],
										cnTitle: ['�ŵ����','�ŵ�����','��������',<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�'<%}else{%>'���۽��'<%}%>],
									<%}
									}%>
									sheetTitle: '���ۻ��ܲ�ѯ',
									gssgcode : User.sgcode,
									userType : User.sutype,
									supcode : supcode,       
									gsmfid : $('#gsmfids').attr('value'),                   // ��Ӧ�̱���
									startDate : $('#startDate').attr('value'),	// ��ʼʱ��
									endDate : $('#endDate').attr('value') 		// ����ʱ��
								}]
							}
						)						
					}, 
					function(data){ 
	                    if(data.returnCode == '1' ){
	                    	location.href = data.returnInfo;	                    	 
	                    }else{ 
	                        $.messager.alert('��ʾ','����Excelʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
		}
		
		function reloadgrid (value)  {  
			//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���
			var supcode = '';
			if(User.sutype == 'L' && User.sgcode=='3018'){
				supcode = $('#supcode').combobox('getValue');
				
			}else if(User.sutype == 'L' && User.sgcode!=='3018'){
			supcode = $('#supcode').val();
				
			}else {
			supcode = User.supcode;
			}  
			
	        //��ѯ����ֱ�������queryParams��
	        $('#saleShopSummary').datagrid('options').url = 'JsonServlet';        
			$('#saleShopSummary').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : <%if(currUser.getSgcode().equals("3009")){%>'getShopSale_JM'<%}else{%>'datagrid'<%}%>,
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							gssgcode : User.sgcode,
							supcode : supcode,
							userType : User.sutype,
							gsmfid : $('#gsmfids').attr('value'),	// �ŵ�
							startDate : $('#startDate').attr('value'),	// ��ʼʱ��
							endDate : $('#endDate').attr('value') 		// ����ʱ��
						}]
					}
				)
			};	
			$("#saleShopdatagrid").hide();
			$("#saleGsrqdatagrid").hide();
			$("#stockdatagrid").hide();		
			$("#saledatagrid").show();		
			$("#saleShopSummary").datagrid('reload');  
			$("#saleShopSummary").datagrid('resize');  
			$("#LssSaleSummary").datagrid('reload'); 
			$("#LssSaleSummary").datagrid('resize'); 
			$('#supcode').combobox('setValue','');
    	}
    	    	
    	function reloadShopSalegrid (value,SUPID)  {
    		//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���
    		//var supcode = '';
			//if(User.sutype == 'L'){
			//	supcode = $("#supcode").val();
			//}else{
			//	supcode = User.supcode;
			//}
			if(User.sgcode=='3006' && User.sutype == 'S'){
				SUPID=User.supcode;
			}      
        	$('#gsmfid').attr('value',value);	  
	        //��ѯ����ֱ�������queryParams��
	        $('#saleShopDetail').datagrid('options').url = 'JsonServlet';        
			$('#saleShopDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : <%if(currUser.getSgcode().equals("3009")){%>'getGSRQSale'<%}else{%>'getShopSaleDetail'<%}%>,
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							gssgcode : User.sgcode,
							supcode : SUPID,
							userType : User.sutype,
							startDate : $('#startDate').attr('value'),	// ��ʼʱ��
							endDate : $('#endDate').attr('value'),      // ����ʱ��
							gsmfid : $('#gsmfid').attr('value')  	    // �ŵ����	
						}]
					}
				)
			};     
			$("#saledatagrid").hide();
			$("#saleGsrqdatagrid").hide();
			$("#stockdatagrid").hide();					
			$("#saleShopdatagrid").show();   
			$("#saleShopDetail").datagrid('reload');	
			$("#saleShopDetail").datagrid('resize');		 
    	}    	
    	
    	function reloadGsrqSalegrid (value,SUPID)  {
    		//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���    	    	
    		//var supcode = '';
			//if(User.sutype == 'L'){
			//	supcode = $("#supcode").val();
			//}else{
			//	supcode = User.supcode;
			//}
			if(User.sgcode=='3006' && User.sutype == 'S'){
				SUPID=User.supcode;
			} 
    		$('#gsrq').attr('value',value);        
	        //��ѯ����ֱ�������queryParams��
	        $('#saleGsrqDetail').datagrid('options').url = 'JsonServlet';        
			$('#saleGsrqDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getGsrqShopSale',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							gssgcode : User.sgcode,
							supcode : SUPID,
							userType : User.sutype,
							startDate : $('#startDate').attr('value'),	// ��ʼʱ��
							endDate : $('#endDate').attr('value'), 		// ����ʱ��
							gsmfid : $('#gsmfid').attr('value'),		// �ŵ����
							gsrq : $('#gsrq').attr('value')             // ��������
						}]
					}
				)
			};   
			$("#saledatagrid").hide();	   
			$("#saleShopdatagrid").hide();			
			$("#stockdatagrid").hide();				
			$("#saleGsrqdatagrid").show(); 
			$("#saleGsrqDetail").datagrid('reload');
			$("#saleGsrqDetail").datagrid('resize');      
    	}
    	
    	function reloadItemStockgrid (value,SUPID)  {
    		//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���
    		//var supcode = '';
			//if(User.sutype == 'L'){
			//	supcode = $("#supcode").val();
			//}else{
			//	supcode = User.supcode;
			//}   
        	$('#zsgdid').attr('value',value);   
	        //��ѯ����ֱ�������queryParams��
	        $('#ItemStock').datagrid('options').url = 'JsonServlet';        
			$('#ItemStock').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getGoodsStock',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.Stock',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							sgcode : User.sgcode,
							supcode : SUPID,
							startDate : $('#startDate').attr('value'),	// ��ʼʱ��
							endDate : $('#endDate').attr('value'), 		// ����ʱ��
							zsmfid : $('#gsmfid').attr('value'),		// �ŵ����
							gsrq : $('#gsrq').attr('value'), 			// ��������
							zsgdid : $('#zsgdid').attr('value')         // ��Ʒ����
						}]
					}
				)
			};      
			
			$("#saledatagrid").hide();			
			$("#saleShopdatagrid").hide();
			$("#saleGsrqdatagrid").hide();			  
			$("#stockdatagrid").show(); 
			$("#ItemStock").datagrid('reload');      
			$("#ItemStock").datagrid('resize');
    }
    	
   	function backSalegrid ()  {     		
   		$("#saleShopdatagrid").hide(); 
		$("#saledatagrid").show();    	 
   	}
   	
   	function backSaleShopgrid ()  {
   		$("#saleGsrqdatagrid").hide(); 
		$("#saleShopdatagrid").show();   
   	}
   	
   	function backSaleGsrqgrid ()  {
   		$("#stockdatagrid").hide(); 
		$("#saleGsrqdatagrid").show();   
   	}   
    	
$(function(){
	if( !$('#supcode').data('isLoad') ){
		$.post( 'JsonServlet',				
			{
				data : obj2str({		
						ACTION_TYPE : 'getReceivers',
						ACTION_CLASS : 'com.bfuture.app.saas.model.MsgMessage',
						ACTION_MANAGER : 'msgManager',
						list:[{
							id : ''
						}]
				})
				
			}, 
			function(data){ 
                   if(data.returnCode == '1' ){ 
                   	 if( data.rows ){
                   	 	$('#supcode').combobox('loadData', data.rows );
                   	 }
                   }else{ 
                       $.messager.alert('��ʾ','��ȡ������ʧ��!<br>ԭ��' + data.returnInfo,'error');
                   } 
           	},
           	'json'
           );
	}

});	
</script>
</head>
<body>
<center>
<!-- ---------- ��ѯ������������ʼ ---------- -->
<table width="850"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">���ۻ��ܲ�ѯ<%if(currUser.getSgcode().equals("3007")){%>( ˵����Ԥ�����۳ɱ�������Ʒ�����½��۽��к���,���½��ĳɱ����ܲ�һ��)<%}%></td>
	</tr>
	<tr>
		<td colspan="3">
			<input type="hidden" id="gsmfid" name="gsmfid" value="" />
			<input type="hidden" id="gsrq" name="gsrq" value="" />
			<input type="hidden" id="zsgdid" name="zsgdid" value="" />
		</td>
	</tr>
	<tr>
		<td width="300" style="border: none;">
			��ʼ���ڣ�<input type="text" id="startDate" name="startDate" type="text" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});"size="20" />
		</td>
		<td width="300" style="border: none;">
			�������ڣ�<input type="text" id="endDate" name="endDate" type="text" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" />
		</td>
		<td width="250" style="border: none;">
			
			<%if("3018".equals(currUser.getSgcode())){%>
			<div id="supcodeDiv" style="">��Ӧ�̱��룺&nbsp;&nbsp;<input class="easyui-combobox" id="supcode" name="supcode" value="" size="20" panelHeight="auto"/></div>
			<%}else if("3006".equals(currUser.getSgcode())){%>
			<%}else{%>
			<div id="supcodeDiv" style="">��Ӧ�̱��룺&nbsp;&nbsp;<input type="text" id="supcode" name="supcode" value="" size="20" /></div>
			<%} %>
		</td>
	</tr>
	<tr>
		<td id="mainTabTd" colspan="3" width="300" align="left" style="border: none;">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺ 
			<select style="width: 154px;" name='gsmfids' id="gsmfids" size='1'>
				<option value=''>�����ŵ�</option>
			</select>
		</td>
	</tr>
	<tr>
		<td align="left" colspan="3" style="border: none;"><img
			src="images/sure.jpg" border="0" onClick="reloadgrid();" /></td>
	</tr>
	<tr>
		<td colspan="3">
			<!-- table ����ʾ�б����Ϣ -->
			<div id="saledatagrid" style="display: none;">
				<div id="saleExportExcel" align="right" style="color: #336699; width: 486px">
					<a href="javascript:exportExcel();">>>����Excel���</a>
				</div>
				<table id="saleShopSummary" width="586"></table>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<div id="saleShopdatagrid" style="display: none;">
				<table id="saleShopDetail" ></table>
				<div style="text-align: left; float: left;  margin-top: 10px">
					<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-back" onClick="backSalegrid();">����</a>-->
					<img src="images/goback.jpg" border="0" onClick="backSalegrid();" />
				</div>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<div id="saleGsrqdatagrid" style="display: none;">
				<table id="saleGsrqDetail"></table>
				<div style="text-align: left; float: left;  margin-top: 10px">
					<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-back" onClick="backSaleShopgrid();">����</a> -->
					<img src="images/goback.jpg" border="0" onClick="backSaleShopgrid();" />
				</div>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<div id="stockdatagrid" style="display: none;">
				<table id="ItemStock"></table>
				<div style="text-align: left; float: left;  margin-top: 10px">
					<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-back" onClick="backSaleGsrqgrid();">����</a> -->
					<img src="images/goback.jpg" border="0" onClick="backSaleGsrqgrid();" />
				</div>
			</div>
		</td>
	</tr>
</table>
</center>
</body>
<script type="text/javascript">
// �����ŵ�
var obj = document.getElementById("gsmfids");
loadAllShop(obj);

//��ȡ�����ŵ���Ϣ
function loadAllShop( list ){
	if( $(list).attr('isLoad') == undefined ){
		$.post( 'JsonServlet',				
			{
				data : obj2str({		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.Shop',
						ACTION_MANAGER : 'shopManager',	
						list:[{									
							sgcode : User.sgcode
						}]
				})
				
			}, 
			function(data){ 
                   if(data.returnCode == '1' ){
                   	 if( data.rows != undefined && data.rows.length > 0 ){	                    	 	
                   	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
				            var html = "<option value='" + n.SHPCODE + "'>" + n.SHPNAME + "</option>";  
				            $(list).append(html);  
				        });						        
                   	 }	                    	 
                   	 $(list).attr('isLoad' , true );
                   }else{ 
                       $.messager.alert('��ʾ','��ȡ�ŵ���Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
                   } 
           	},
           	'json'
           );				
	}
}
</script>
</html>