<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>��Ʒ������ϸ��ѯ</title>
	<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}		
		SysScmuser currUser = (SysScmuser)obj;
		String sucode= currUser.getSucode();
		//��þ�Ӫ��ʽ
		String jyfs = currUser.getSuflag() + "";
		System.out.print("---------"+jyfs);
	%>
<style>
a:hover {
	text-decoration: underline;
	color: red
}
</style>
<script><!--
	    var now = new Date();
		now.setDate( now.getDate() - 7 );
		$("#startDate").val(now.format('yyyy-MM-dd'));	
        $("#endDate").val(new Date().format('yyyy-MM-dd'));
        
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
		//��ȡ����Ʒ����Ϣ
		function loadAllBrand( list ){
			if( $(list).attr('isLoad') == undefined ){
				
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'getAllBrand',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',	
								list:[{									
									sgcode : User.sgcode
								}]
						})
					}, 
					function(data){ 
	                    if(data.returnCode == '1' ){
	                    	 if( data.rows != undefined && data.rows.length > 0 ){	                    	 	
	                    	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
						            var html = "<option value='" + n.GDPPNAME + "'>" + n.GDPPNAME + "</option>";  
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('��ʾ','��ȡƷ����Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );				
			}
		}
		
		$(function(){
			if("<%=sucode%>".substring(0,4) == "3005" || "<%=sucode%>".substring(0,4) == "3004"){
				$('#saleDetail').datagrid({
				width:  User.sutype == 'L' ? 1110 : 660,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'��������...',				
				columns:[[
				    {field:'GDBARCODE',title:'��Ʒ����',width:120,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if (value == null || value == 'null')
			        		{
			        			return '';
			        		}else if(value == '�ϼ�'){
			        			return value;
			        		}			  
			        		else
			        		{
			        			var gdid = "'" + rec.GDID + "'";
			        			var supid = "'" + rec.GSSUPID + "'";
			        			return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' + gdid + ','+supid+');">' + value + '</a>';
			        		}						
						}
				    },
				    {field:'GDID',title:'��Ʒ����',width:60,align:'center',sortable:true},	
				    {field:'GDNAME',title:'��Ʒ����',width:200,align:'left',sortable:true},				    
				    {field:'GDSPEC',title:'���',width:60,align:'center',sortable:true},
				    {field:'GDUNIT',title:'��λ',width:60,align:'center',sortable:true},
				    <%if(currUser.getSgcode().equals("3025")){%>			    
					{field:'GSXSSL',title:'��������',width:70,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					<%}else if(currUser.getSgcode().equals("3031")){%>
					{field:'GSXSSL',title:'����С��',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}, // ,sortable:true ������
					<%}else{%>
					{field:'GSXSSL',title:'��������',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}, // ,sortable:true ������					
					<%}%>	
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						{field:'TEMP5',title:'�ۼ�',width:70,align:'center',sortable:true},
					<%}%>
					<%if("3031".equals(currUser.getSgcode().toString())){%>
					{field:'GSXSJE',title:'���۽��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
					}}
					<%}else{%>
					{field:'GSXSJE',title:'���۳ɱ�',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}%>		
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
						if("3031".equals(currUser.getSgcode().toString())){%>
						,{field:'GSXSSR',title:'���С��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else{%>
						,{field:'GSXSSR',title:'��������',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}%>
						,{field:'GSSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'��Ӧ������',width:150,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			}else if("<%=sucode%>".substring(0,4) == "3009"){
			$('#saleDetail').datagrid({
				width:  User.sutype == 'L' ? 1010 : 888,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'��������...',				
				columns:[[
				    {field:'GSRQ',title:'��������',width:80,align:'center',sortable:true},
				    {field:'GDBARCODE',title:'��Ʒ����',width:60,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if (value == null || value == 'null')
			        		{
			        			return '';
			        		}else if(value == '�ϼ�'){
			        			return value;
			        		}			  
			        		else
			        		{
			        			var gdid = "'" + rec.GDID + "'";
			        			var supid = "'" + rec.GSSUPID + "'";
			        			return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' + gdid + ','+supid+');">' + value + '</a>';
			        		}						
						}
			        },
			        {field:'GDID',title:'��Ʒ����',width:60,align:'center',sortable:true},
				    {field:'GDNAME',title:'��Ʒ����',width:200,align:'left',sortable:true},				    
				    {field:'GDSPEC',title:'���',width:60,align:'center',sortable:true},
				    {field:'GDUNIT',title:'��λ',width:60,align:'center',sortable:true},	
				    <%if("3031".equals(currUser.getSgcode().toString())){%>
				    {field:'GSXSSL',title:'����С��',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}, // ,sortable:true ������
				    <%}else{%>
				    {field:'GSXSSL',title:'��������',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}, // ,sortable:true ������
				    <%}%>			    					
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						{field:'TEMP5',title:'�ۼ�',width:70,align:'center',sortable:true},
					<%}%>				
					{field:'GSXSJE',title:'���۳ɱ�',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'GSXSSR',title:'��������',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'MLL',title:'ë����',width:70,align:'center',sortable:true}
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'GSSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if(value != null && value != undefined) 
							return (value+'').substring(0,3);
							return '';
						}},	
						{field:'SUPNAME',title:'��Ӧ������',width:150,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			}else if("<%=sucode%>".substring(0,4) == "3006") {
				$('#saleDetail').datagrid({
				width:  User.sutype == 'L' ? 1110 : 660,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'��������...',				
				columns:[[
				    {field:'GSRQ',title:'��������',width:80,align:'center',sortable:true},
				    
			        {field:'GDID',title:'��Ʒ����',width:100,align:'center',sortable:true//,
//			        	formatter:function(value,rec){
//			        		if (value == null || value == 'null')
//			        		{
//			        			return '';
//			        		}else
//			        		{
//			        			var gdid = "'" + rec.GDID + "'";
//			        			var supid = "'" + rec.GSSUPID + "'";
//			        			return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' + gdid + ','+supid+');">' + value + '</a>';
//			        		}						
//						}
			        },
				    {field:'GDNAME',title:'��Ʒ����',width:200,align:'left',sortable:true},				    
				    {field:'GDSPEC',title:'���',width:60,align:'center',sortable:true},
				    {field:'GDUNIT',title:'��λ',width:60,align:'center',sortable:true},				    
					{field:'GSXSSL',title:'��������',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}, // ,sortable:true ������	
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						{field:'TEMP5',title:'�ۼ�',width:70,align:'center',sortable:true},
					<%}%>				
					{field:'GSXSJE',title:'���۳ɱ�',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'GSXSSR',title:'��������',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'GSSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'��Ӧ������',width:150,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			}else if("<%=sucode%>".substring(0,4) == "3022" || "<%=sucode%>".substring(0,4) == "3024") {
				$('#saleDetail').datagrid({
				width:  User.sutype == 'L' ? 1110 : 660,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'��������...',				
				columns:[[
				    {field:'GSRQ',title:'��������',width:80,align:'center',sortable:true},
				    {field:'GDBARCODE',title:'��Ʒ����',width:60,align:'center',sortable:true},
			        {field:'GDID',title:'��Ʒ����',width:100,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if (value == null || value == 'null')
			        		{
			        			return '';
			        		}else
			        		{
			        			var gdid = "'" + rec.GDID + "'";
			        			var supid = "'" + rec.GSSUPID + "'";
			        			return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' + gdid + ','+supid+');">' + value + '</a>';
			        		}						
						}
			        },
				    {field:'GDNAME',title:'��Ʒ����',width:200,align:'left',sortable:true},				    
				    {field:'GDSPEC',title:'���',width:60,align:'center',sortable:true},
				    {field:'GDUNIT',title:'��λ',width:60,align:'center',sortable:true},				    
					{field:'GSXSSL',title:'��������',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}, // ,sortable:true ������	
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						{field:'TEMP5',title:'�ۼ�',width:70,align:'center',sortable:true},
					<%}%>				
					{field:'GSXSJE',title:'���۳ɱ�',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'GSXSSR',title:'��������',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'GSSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'��Ӧ������',width:150,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			}else if("<%=sucode%>".substring(0,4) == "3026") {///3026
				$('#saleDetail').datagrid({
				width:  User.sutype == 'L' ? 1110 : 660,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'��������...',				
				columns:[[
				    {field:'GSRQ',title:'��������',width:90,align:'center',sortable:true}, 
			        {field:'GDID',title:'��Ʒ����',width:100,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if (value == null || value == 'null')
			        		{
			        			return '';
			        		}else
			        		{
			        			var gdid = "'" + rec.GDID + "'";
			        			var supid = "'" + rec.GSSUPID + "'";
			        			return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' + gdid + ','+supid+');">' + value + '</a>';
			        		}						
						}
			        },
				    {field:'GDNAME',title:'��Ʒ����',width:200,align:'center',sortable:true}, 
				    {field:'GDUNIT',title:'��λ',width:80,align:'center',sortable:true},				    
					{field:'GSXSSL',title:'��������',width:90,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}, // ,sortable:true ������	
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						{field:'TEMP5',title:'�ۼ�',width:70,align:'center',sortable:true},
					<%}%>				
					{field:'GSXSJE',title:'���۳ɱ�',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'GSXSSR',title:'��������',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'GSSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'��Ӧ������',width:250,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			}////3026
			else{
				$('#saleDetail').datagrid({
				width:  User.sutype == 'L' ? 1110 : 850,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'��������...',				
				columns:[[
				   <%if(!currUser.getSgcode().equals("3018")){%>
				    {field:'GSRQ',title:'��������',width:80,align:'center',sortable:true},
				    <%}%>
				    {field:'GDBARCODE',title:'��Ʒ����',width:<%if(currUser.getSgcode().equals("3018")){%>190<%}else{%>110<%}%>,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if (value == null || value == 'null')
			        		{
			        			return '';
			        		}else if(value == '�ϼ�'){
			        			return value;
			        		}			  
			        		else
			        		{
			        			var gdid = "'" + rec.GDID + "'";
			        			var supid = "'" + rec.GSSUPID + "'";
			        			if("<%=sucode%>".substring(0,4) == "3034"){
                                 return value;
                                }
			        			return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' + gdid + ','+supid+');">' + value + '</a>';
			        		}						
						}
			        },
			        {field:'GDID',title:'��Ʒ����',width:60,align:'center',sortable:true},
				    {field:'GDNAME',title:'��Ʒ����',width:200,align:'left',sortable:true},				    
				    {field:'GDSPEC',title:'���',width:60,align:'center',sortable:true},
				    {field:'GDUNIT',title:'��λ',width:60,align:'center',sortable:true},	
				    <%if("3031".equals(currUser.getSgcode().toString())){%>
				    {field:'GSXSSL',title:'����С��',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}},
				    <%}else{%>
				    {field:'GSXSSL',title:'��������',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}, // ,sortable:true ������
				    <%}%>			    	
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						{field:'TEMP5',title:'�ۼ�',width:70,align:'center',sortable:true},
					<%}%>				
					<%if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						{field:'GSXSJE',title:'��˰�ɱ�',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						{field:'GSXSSR',title:'��˰��������',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					<%}if("3027".equals(currUser.getSgcode())){%>
						{field:'GSVENDREBATE',title:'��Ӧ�̳е��ۿ�',width:100,align:'center',sortable:true}
					<%}else if(!"3027".equals(currUser.getSgcode())){%>
					{field:'GSXSJE',title:<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�'<%}else if("3031".equals(currUser.getSgcode().toString())){%>'���۽��'<%}else{%>'���۳ɱ�'<%}%>,width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}%>
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					<%if(currUser.getSgcode().equals("3007")){%>
					,{field:'XSSR2',title:'��������',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}else{if(currUser.getSgcode().equals("3027")){%>
						,{field:'GSXSJE',title:'��˰�ɱ�',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'GSXSSR',title:'��˰��������',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}else if(currUser.getSgcode().equals("3031")){%>
					,{field:'GSXSSR',title:'���С��',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}else{%>
					,{field:'GSXSSR',title:'��������',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}%>
					<%}%>
						,{field:'GSSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'��Ӧ������',width:150,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			
			if(User.sgcode=='3018'){
			 $('#supcode').combobox({
				width: 154,
				valueField:'SUPCODE',
				textField:'SUNAME'
			});	 
			}  
			}
			
			
			//
			$('#itemStock').datagrid({
				width:  User.sutype == 'L' ? 935 : 685,
				iconCls:'icon-save',
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',			
				showFooter:true,	
				remoteSort: true,	
				singleSelect: true,	
				loadMsg:'��������...',				
				columns:[[
					{field:'KCRQ',title:'�������',width:100,align:'center',sortable:true},
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
						{field:'SUPNAME',title:'��Ӧ������',width:150,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			//����ǹ�Ӧ���û������ع�Ӧ�̱�������򣬷�����ʾ
			if(User.sutype == 'L'){
				$("#supcodeDiv").show();
				$("#saleExportExcel").width(1110);
				$("#mainTab").width(1110);
				$("#mainTabTd").width(380);
				$("#mainTabStartDateTd").width(450);
			}else{
				$("#supcodeDiv").hide();
			}
		});		
		
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
								ACTION_TYPE : 'getSaleDetail',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,
									<%
									if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
										if("3006".equals(currUser.getSgcode())){
									%>
										enTitle: ['GSRQ','GDID','GDNAME','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','GSXSSR','GSXSJE' ],
										cnTitle: ['��������','��Ʒ����','��Ʒ����','��Ӧ�̱���','��Ӧ������','���','��λ','��������','��������','���۳ɱ�'],
									<%}else if("3018".equals(currUser.getSgcode())){%>
										enTitle: ['GDID','GDNAME','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','GSXSSR','GSXSJE' ],
										cnTitle: ['��Ʒ����','��Ʒ����','��Ӧ�̱���','��Ӧ������','���','��λ','��������','��������','���۳ɱ�'],
									<%}else if("3026".equals(currUser.getSgcode())){%>
									enTitle: ['GDID','GDNAME','GSSUPID','SUPNAME','GDUNIT','GSXSSL','GSXSSR','GSXSJE' ],
									cnTitle: ['��Ʒ����','��Ʒ����','��Ӧ�̱���','��Ӧ������','��λ','��������','��������','���۳ɱ�'],
									<%}else if("3027".equals(currUser.getSgcode())){%>
									enTitle: ['GSRQ','GDID','GDNAME','GDBARCODE','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','XSSR','GSXSJE','GSVENDREBATE' ],
									cnTitle: ['��������','��Ʒ����','��Ʒ����','��Ʒ����','��Ӧ�̱���','��Ӧ������','���','��λ','��������','��˰��������','��˰�ɱ�','��Ӧ�̳е��ۿ�'],
									<%
									}else if("3011".equals(currUser.getSgcode())){%>
										enTitle: ['GSRQ','GDID','GDNAME','GDBARCODE','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','TEMP5','XSSR' ],
										cnTitle: ['��������','��Ʒ����','��Ʒ����','��Ʒ����','��Ӧ�̱���','��Ӧ������','���','��λ','��������','�ۼ�','��������'],
									<%
									}else if("3031".equals(currUser.getSgcode())){%>
										enTitle: ['GSRQ','GDID','GDNAME','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','XSSR' ],
										cnTitle: ['��������','��Ʒ����','��Ʒ����','��Ӧ�̱���','��Ӧ������','���','��λ','����С��','���С��'],
									<%}else{%>
										enTitle: ['GSRQ','GDID','GDNAME','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','XSSR' ],
										cnTitle: ['��������','��Ʒ����','��Ʒ����','��Ӧ�̱���','��Ӧ������','���','��λ','��������','��������'],
									<%
									}
									}else{
										if("3018".equals(currUser.getSgcode())){%>
										enTitle: ['GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSXSJE' ],
										cnTitle: ['��Ʒ����','��Ʒ����','���','��λ','��������','���۳ɱ�'],
									<%}else{
										if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GSRQ','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSXSJE','GSVENDREBATE'],
											cnTitle: ['��������','��Ʒ����','��Ʒ����','���','��λ','��������','��˰�ɱ�','��Ӧ�̳е��ۿ�'],
										<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GSRQ','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','XSSR','GSVENDREBATE'],
											cnTitle: ['��������','��Ʒ����','��Ʒ����','���','��λ','��������','��˰��������','��Ӧ�̳е��ۿ�'],
										<%}else if("3011".equals(currUser.getSgcode())){%>
										enTitle: ['GSRQ','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','TEMP5','XSSR' ],
										cnTitle: ['��������','��Ʒ����','��Ʒ����','���','��λ','��������','�ۼ�','��������'],
									<%}else if("3031".equals(currUser.getSgcode())){%>
										enTitle: ['GSRQ','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSXSJE' ],
										cnTitle: ['��������','��Ʒ����','��Ʒ����','���','��λ','����С��','���С��'],
									<%}else{%>
											enTitle: ['GSRQ','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSXSJE' ],
											cnTitle: ['��������','��Ʒ����','��Ʒ����','���','��λ','��������',<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�'<%}else{%>'���۳ɱ�'<%}%>],
										<%}
									}
									}%>
									sheetTitle: '��Ʒ������ϸ��ѯ',
									gssgcode : User.sgcode,
									gsmfid : $('#gsmfid').attr('value'),// �ŵ����
									supcode : supcode,					// ��Ӧ�̱���						
									gsgdid : $('#gsgdid').attr('value'), // ��Ʒ����
									gsgdname : $('#gsgdname').attr('value'), // ��Ʒ����
									gdbarcode : $('#gdbarcode').attr('value'), // ��Ʒ����
									startDate : $('#startDate').attr('value'),//��ʼ����
									endDate : $('#endDate').attr('value')     //��������
									//,
									//category : $("#category").val() //Ʒ������
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
		
		function reloadgrid ()  {
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
	        $('#saleDetail').datagrid('options').url = 'JsonServlet';        
			$('#saleDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getSaleDetail',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							gssgcode : User.sgcode,
							supcode : supcode,
							gsmfid : $('#gsmfid').attr('value'),// �ŵ����
							gsgdid : $('#gsgdid').attr('value'), // ��Ʒ����
							gdbarcode : $('#gdbarcode').attr('value'), // ��Ʒ����
							gsgdname : $('#gsgdname').attr('value'), // ��Ʒ����
							startDate : $('#startDate').attr('value'),
							endDate : $('#endDate').attr('value')
						}]
					}
				)
			};		
			$("#itemStockdatagrid").hide();
			$("#saledatagrid").show();
			$("#saleDetail").datagrid('reload'); 
			$("#saleDetail").datagrid('resize'); 
			$('#supcode').combobox('setValue','');
			
    	}
    	
    	function reloadItemStockgrid (value,SUPID)  { 
    		//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱��� 
    		//var supcode = '';
			//if(User.sutype == 'L'){
			//	supcode = $("#supcode").val();
			//}else{
			//	supcode = User.supcode;
			//}
	        //��ѯ����ֱ�������queryParams��
	        $('#itemStock').datagrid('options').url = 'JsonServlet';        
			$('#itemStock').datagrid('options').queryParams = {
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
							zsmfid : $('#gsmfid').attr('value'),	
							zsgdid : value					
						}]
					}
				)
			};
			$("#saledatagrid").hide();
			$("#itemStockdatagrid").show();
			$("#itemStock").datagrid('reload');
			$("#itemStock").datagrid('resize');  
    	}
    	
    	function backgrid ()  {     		
    		$("#itemStockdatagrid").hide(); 
			$("#saledatagrid").show();    	 
    	}   
    	
    	
    		$(function() {
		
			$('#supcode').combobox('setValue','');
			
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
		
		}	);	
    	   
 	--></script>
</head>
<body>
<center>
<!-- ---------- ��ѯ������������ʼ ---------- -->
<table width="860" id="mainTab"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">������Ʒ��ϸ��ѯ<%if(currUser.getSgcode().equals("3007")){%>( ˵����Ԥ�����۳ɱ�������Ʒ�����½��۽��к���,���½��ĳɱ����ܲ�һ��)<%}%></td>
	</tr>
	<tr>
		<td id="mainTabStartDateTd" width="280" style="border: none;">&nbsp;&nbsp;&nbsp;&nbsp;��ʼ���ڣ�<input
			type="text" id="startDate" required="true" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});" /></td>
		<td width="280" style="border: none;">�������ڣ�<input type="text"
			id="endDate" name="endDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" /></td>
		<td id="mainTabTd" width="300" style="border: none;">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺<select
			style="width: 154px;" name='gsmfid' id="gsmfid" size='1'>
			<option value=''>�����ŵ�</option>
		</select></td>
	</tr>
	<tr>
		<td style="border: none;">&nbsp;&nbsp;&nbsp;&nbsp;��Ʒ���룺<input type="text" id="gsgdid" name="gsgdid"/></td>
		<td style="border: none;">��Ʒ���ƣ�<input type="text" id="gsgdname" name="gsgdname"/></td>
		<td style="border: none;">��Ʒ���룺<input type="text" id="gdbarcode" name="gdbarcode"/></td>
	</tr>
	<tr>
		<td style="border: none;">
			<%if("3018".equals(currUser.getSgcode())){%>
			<div id="supcodeDiv" style="">��Ӧ�̱��룺<input class="easyui-combobox" id="supcode" name="supcode" value="" size="20" panelHeight="auto"/></div>
			<%}else{%>
			<div id="supcodeDiv" style="">��Ӧ�̱��룺<input type="text" id="supcode" name="supcode" value="" size="20" /></div>
			<%} %>
		</td>
		<td style="border: none;" ></td>
		<td style="border: none;"></td>
	</tr>
	<tr>
		<td style="border: none;" align="left">
			<img src="images/sure.jpg" border="0" onClick="reloadgrid();" />
		</td>
		<td style="border: none;" ></td>
		<td style="border: none;"></td>
	</tr>
	
	<tr>
		<td colspan="3">
			<!-- table ����ʾ�б����Ϣ -->
			<div id="saledatagrid" style="display: none;">
			<%if(!currUser.getSgcode().equals("3009")){%>
				<div id="saleExportExcel" align="right" style="color: #336699; width: 850px">
					<a href="javascript:exportExcel();">>>����Excel���</a></div>
					<%}%>
				<table id="saleDetail"></table>
			</div>
		</td>
	</tr>
	
	<tr>
		<td colspan="3">
			<div id="itemStockdatagrid" style="display: none;margin-left: 90px;">
				<table id="itemStock"></table>
				<div style="text-align: left; margin-top: 10px;">
					<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-back" onClick="backgrid();">����</a>-->
					<img src="images/goback.jpg" border="0" onClick="backgrid();" />
				</div>
			</div>
		</td>
	</tr>
</table>
</center>
</body>
<script type="text/javascript">
// �����ŵ�
var obj = document.getElementById("gsmfid");
loadAllShop(obj);
</script>
</html>