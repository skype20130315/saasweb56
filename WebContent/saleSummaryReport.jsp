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
		//获得经营方式
		String jyfs = currUser.getSuflag() + "";
		System.out.print("---------"+jyfs);
	%>

<title>销售汇总查询</title>
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
				loadMsg:'加载数据...',				
				columns:[[				
					{field:'SHPCODE',title:'门店编码',width:120,align:'center',
						formatter:function(value,rec){
								if(value == '合计'){
									return "<span style='color:#4574a0; font-weight:bold;'>"+value+"</span>";
								}
								var shopCode = "'" + value + "'";
								var supid = "'" + rec.GSSUPID + "'";
								return '<a href="#" style=" color:#4574a0; font-weight:bold;" onClick="reloadShopSalegrid(' +  shopCode + ','+ supid +');">' + value + '</a>';											
						}
					},
					{field:'SHPNAME',title:'门店名称',width:200,align:'center',sortable:true},
					<%if("3025".equals(currUser.getSgcode().toString())){%>
					{field:'GSXSSL',title:'销售数量',width:70,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}else if("3031".equals(currUser.getSgcode().toString())){%>
						{field:'GSXSSL',title:'数量小计',width:70,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}else{%>
					{field:'GSXSSL',title:'销售数量',width:70,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}					
					<%}%>
					<%if(!"3026".equals(currUser.getSgcode().toString())){
						if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						,{field:'GSHSJJJE',title:'含税成本',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						,{field:'GSXSJE',title:'含税销售收入',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}if(!"3027".equals(currUser.getSgcode())){%>
						,{field:'GSHSJJJE',title:<%if("3007".equals(currUser.getSgcode().toString())){%>'预估销售成本',<%}else if("3031".equals(currUser.getSgcode().toString())){%>'进价金额',<%}else{%>'进价成本',<%}%>
						width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else if("3027".equals(currUser.getSgcode())){%>
							,{field:'GSVENDREBATE',title:'供应商承担折扣',width:100,align:'center',sortable:true}	
						<%}
					}%>
						<%if("3009".equals(currUser.getSgcode().toString())&&"S".equalsIgnoreCase( currUser.getSutype().toString())){%>
						,{field:'GSXSJE',title:'销售金额',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'MLL',title:'毛利率',width:80,align:'center',sortable:true}
						<%}%>
						<%if("3007".equals(currUser.getSgcode().toString())&&"S".equalsIgnoreCase( currUser.getSutype().toString())){%>
						,{field:'XSSR',title:'销售金额',width:100,align:'center',sortable:true,formatter:function(value,rec){
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
						,{field:'XSSR',title:'销售金额',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else{
						if("3027".equals(currUser.getSgcode().toString())){%>
						,{field:'GSXSJE',title:'含税销售收入',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'GSHSJJJE',title:'含税成本',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else if("3031".equals(currUser.getSgcode().toString())){%>
							,{field:'GSXSJE',title:'金额小计',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});}}
						<%}else{%>
							,{field:'GSXSJE',title:'销售金额',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});}}
						<%}%>
						<%}%>
						<%if(("3009".equals(currUser.getSgcode().toString()))){%>
						,{field:'MLL',title:'毛利率',width:70,align:'center',sortable:true}
						<%}%>
						,{field:'GSSUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'供应商名称',width:200,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true	
			});
			
			//如果是零售商，就显示供应商输入框
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
				loadMsg:'加载数据...',				
				columns:[[
			        {field:'GSRQ',title:'销售日期',width:100,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if(value == '合计'){
									return "<span style='color:#4574a0; font-weight:bold;'>"+value+"</span>";
								}	
			        		var gsrq = "'" + value + "'";
			        		var supid = "'" + rec.GSSUPID + "'";
			        		return '<a href="#" style=" color:#4574a0; font-weight:bold;" onClick="reloadGsrqSalegrid(' +  gsrq + ','+supid+');">' + value + '</a>';	       		        	 	        		
						
						}
			        },
					<%if("3025".equals(currUser.getSgcode().toString())){%>
					{field:'GSXSSL',title:'销售数量',width:120,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					<%}else if("3031".equals(currUser.getSgcode().toString())){%>
						{field:'GSXSSL',title:'数量小计',width:120,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}},
					<%}else{%>
					{field:'GSXSSL',title:'销售数量',width:120,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}},
					<%}%>
					<%if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
					{field:'GSHSJJJE',title:'进价成本',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}} 
					<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
					{field:'GSXSJE',title:'销售金额',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}} 
					<%}else{%>
					{field:'GSHSJJJE',title:<%if("3007".equals(currUser.getSgcode().toString())){%>'预估销售成本',<%}else if("3031".equals(currUser.getSgcode().toString())){%>'进价金额',<%}else{%>'进价成本',<%}%>width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}} 
					<%}%>
						<%if(("3009".equals(currUser.getSgcode().toString()))&&"S".equalsIgnoreCase( currUser.getSutype().toString())){%>
						,{field:'GSXSJE',title:'销售金额',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'MLL',title:'毛利率',width:100,align:'center',sortable:true}
						<%}%>
						<%if(("3007".equals(currUser.getSgcode().toString()))&&"S".equalsIgnoreCase( currUser.getSutype().toString())){%>
						,{field:'XSSR2',title:'销售金额',width:100,align:'center',sortable:true,formatter:function(value,rec){
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
						,{field:'XSSR2',title:'销售金额',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else if(("3031".equals(currUser.getSgcode().toString()))){%>
							,{field:'GSXSJE',title:'金额小计',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else{%>
						,{field:'GSXSJE',title:'销售金额',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}%>
						<%if(("3009".equals(currUser.getSgcode().toString()))){%>
						,{field:'MLL',title:'毛利率',width:90,align:'center',sortable:true}
						<%}%>
						,{field:'GSSUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'供应商名称',width:200,align:'center',sortable:true}
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
				loadMsg:'加载数据...',				
				columns:[[	
				     <%if("3009".equals(currUser.getSgcode().toString())){%>
				     {field:'GSRQ',title:'销售日期',width:80,align:'center',sortable:true},
				     <%}%>
					<%if("3006".equals(currUser.getSgcode().toString())){%>
						{field:'GDID',title:'商品编码',width:60,align:'center',sortable:true},
						
					<%}else{%>
						{field:'GDID',title:'商品编码',width:80,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if (value == null || value == 'null')
			        		{
			        			return '';
			        		}			  
			        		else
			        		{
			        			if(value == '合计'){
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
			        {field:'BARCODE',title:'商品条码',width:100,align:'center',sortable:true},<%}%>
			        <%if("3029".equals(currUser.getSgcode())){%>
			        {field:'GSRQ',title:'销售日期',width:100,align:'center',sortable:true},
			        <%}%>
				    {field:'GDNAME',title:'商品名称',width:300,align:'left',sortable:true},	
				    {field:'GDSPEC',title:'规格',width:70,align:'center',sortable:true},
				    {field:'GDUNIT',title:'单位',width:70,align:'center',sortable:true},
					<%if("3025".equals(currUser.getSgcode().toString())){%>
					{field:'GSXSSL',title:'销售数量',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					<%}else if("3031".equals(currUser.getSgcode().toString())){%>
					{field:'GSXSSL',title:'数量小计',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}	
					<%}else{%>
					{field:'GSXSSL',title:'销售数量',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}			
					<%}%>	
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						,{field:'TEMP5',title:'售价',width:70,align:'center',sortable:true}
					<%}%>
					<%if((!"3026".equals(currUser.getSgcode().toString()))&&"S".equalsIgnoreCase( currUser.getSutype().toString())){
						if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						,{field:'GSXSSR',title:'进价成本',width:100,align:'center',sortable:true,formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{   
							decimalPlaces: 2,thousandsSeparator :','
							});
						}}
						<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						,{field:'GSXSJE',title:'销售金额',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else if("3031".equals(currUser.getSgcode())){%>
						,{field:'GSXSSR',title:'进价金额',width:100,align:'center',sortable:true,formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{   
							decimalPlaces: 2,thousandsSeparator :','
							});
						}}
						<%}else{%>
						,{field:'GSXSSR',title:'进价成本',width:100,align:'center',sortable:true,formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{   
							decimalPlaces: 2,thousandsSeparator :','
							});
						}}
						<%}
					}%>
						<%if(("3009".equals(currUser.getSgcode().toString()))&&"S".equalsIgnoreCase( currUser.getSutype().toString())){%>
						,{field:'GSXSJE',title:'销售金额',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'MLL',title:'毛利率',width:70,align:'center',sortable:true}
						<%}%>
							<%if("3007".equals(currUser.getSgcode().toString())&&"S".equalsIgnoreCase( currUser.getSutype().toString())){%>
						,{field:'XSSR',title:'销售金额',width:100,align:'center',sortable:true,formatter:function(value,rec){
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
						,{field:'XSSR',title:'销售金额',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else if("3031".equals(currUser.getSgcode().toString())){%>
						,{field:'GSXSJE',title:'金额小计',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else{%>
						,{field:'GSXSJE',title:'销售金额',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}%>
						<%if(("3009".equals(currUser.getSgcode().toString()))){%>
						,{field:'MLL',title:'毛利率',width:70,align:'center',sortable:true}
						<%}%>
						,{field:'GSSUPID',title:'供应商编码',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( User.sgcode=='3009'&&value != null && value != undefined ){
							return (value+'').substring(0,3);
							}else if(User.sgcode=='3009'){
							return '';
							}else{
							return value;}
						}},	
						{field:'SUPNAME',title:'供应商名称',width:200,align:'center',sortable:true}
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
				loadMsg:'加载数据...',				
				columns:[[
					<%if("3029".equals(currUser.getSgcode())){%>
			        {field:'KCRQ',title:'库存日期',width:100,align:'center',sortable:true},<%}%>
					{field:'SHPCODE',title:'门店编码',width:100,align:'center',sortable:true},
				    {field:'SHPNAME',title:'门店名称',width:300,align:'center',sortable:true},	
				     <%if("3029".equals(currUser.getSgcode().toString()) && "S".equals(currUser.getSutype()+"")){%>
						{field:'ZSKCSL',title:'库存数量',width:55,align:'center',sortable:true,formatter:function(value,rec){
							if(parseFloat(value)>0){
								return value;
							}else{
								return 0;
							}
						}},
						{field:'ZSKCJE',title:'库存进价金额',width:150,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined && parseFloat(value)>0){
								return formatNumber(value,{decimalPlaces: 2,thousandsSeparator :','});
							}else{
								return 0;
							}
						}}
					<%}else{%>
						{field:'ZSKCSL',title:'库存数量',width:55,align:'center',sortable:true},
						{field:'ZSKCJE',title:'库存进价金额',width:150,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}%>
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'SSUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'供应商名称',width:200,align:'center',sortable:true}
					<%
					}
					%>
				]],
				pagination:true,
				rownumbers:true	
			});
		});			
		
		//导出excel
		function exportExcel(){
			//根据用户是供应商还是零售商，获取供应商编码
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
										cnTitle: ['门店编码','门店名称','销售数量','销售金额','供应商编码','供应商名称'],	
									<%}else if("L".equalsIgnoreCase( currUser.getSutype().toString())&&("3009".equals(currUser.getSgcode().toString()))){
									%>								
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSHSJJJE','GSXSJE','MLL','GSSUPID','SUPNAME' ],
										cnTitle: ['门店编码','门店名称','销售数量','进价成本','销售金额','毛利率','供应商编码','供应商名称'],										
									<%}else if("L".equalsIgnoreCase( currUser.getSutype().toString())&&("3027".equals(currUser.getSgcode().toString()))){%>
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSXSJE','GSHSJJJE','GSSUPID','SUPNAME','GSVENDREBATE' ],
										cnTitle: ['门店编码','门店名称','销售数量','含税销售收入','含税成本','供应商编码','供应商名称','供应商承担折扣'],
									<%}else if("L".equalsIgnoreCase( currUser.getSutype().toString())&&("3031".equals(currUser.getSgcode().toString()))){%>
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSXSJE','GSHSJJJE','GSSUPID','SUPNAME' ],
										cnTitle: ['门店编码','门店名称','数量小计','金额小计','进价金额','供应商编码','供应商名称'],
									<%}else if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){%>
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSXSJE','GSHSJJJE','GSSUPID','SUPNAME' ],
										cnTitle: ['门店编码','门店名称','销售数量','销售金额',<%if("3007".equals(currUser.getSgcode().toString())){%>'预估销售成本'<%}else{%>'进价金额'<%}%>,'供应商编码','供应商名称'],
									<%}else{
										if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSHSJJJE','GSVENDREBATE'],
											cnTitle: ['门店编码','门店名称','销售数量','含税成本','供应商承担折扣'],
										<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSXSJE','GSVENDREBATE'],
											cnTitle: ['门店编码','门店名称','销售数量','含税销售收入','供应商承担折扣'],
									<%}else if("S".equalsIgnoreCase( currUser.getSutype().toString())&&("3009".equals(currUser.getSgcode().toString()))){
									%>								
									    enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSHSJJJE','GSXSJE','MLL' ],
										cnTitle: ['门店编码','门店名称','销售数量','进价成本','销售金额','毛利率'],										
									<%}else if("S".equalsIgnoreCase( currUser.getSutype().toString())&&("3031".equals(currUser.getSgcode().toString()))){%>
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSHSJJJE' ],
										cnTitle: ['门店编码','门店名称','数量小计','进价金额'],
									<%}else{%>
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSHSJJJE' ],
										cnTitle: ['门店编码','门店名称','销售数量',<%if("3007".equals(currUser.getSgcode().toString())){%>'预估销售成本'<%}else{%>'进价金额'<%}%>],
									<%}
									}%>
									sheetTitle: '销售汇总查询',
									gssgcode : User.sgcode,
									userType : User.sutype,
									supcode : supcode,       
									gsmfid : $('#gsmfids').attr('value'),                   // 供应商编码
									startDate : $('#startDate').attr('value'),	// 起始时间
									endDate : $('#endDate').attr('value') 		// 结束时间
								}]
							}
						)						
					}, 
					function(data){ 
	                    if(data.returnCode == '1' ){
	                    	location.href = data.returnInfo;	                    	 
	                    }else{ 
	                        $.messager.alert('提示','导出Excel失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
		}
		
		function reloadgrid (value)  {  
			//根据用户是供应商还是零售商，获取供应商编码
			var supcode = '';
			if(User.sutype == 'L' && User.sgcode=='3018'){
				supcode = $('#supcode').combobox('getValue');
				
			}else if(User.sutype == 'L' && User.sgcode!=='3018'){
			supcode = $('#supcode').val();
				
			}else {
			supcode = User.supcode;
			}  
			
	        //查询参数直接添加在queryParams中
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
							gsmfid : $('#gsmfids').attr('value'),	// 门店
							startDate : $('#startDate').attr('value'),	// 起始时间
							endDate : $('#endDate').attr('value') 		// 结束时间
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
    		//根据用户是供应商还是零售商，获取供应商编码
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
	        //查询参数直接添加在queryParams中
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
							startDate : $('#startDate').attr('value'),	// 起始时间
							endDate : $('#endDate').attr('value'),      // 结束时间
							gsmfid : $('#gsmfid').attr('value')  	    // 门店编码	
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
    		//根据用户是供应商还是零售商，获取供应商编码    	    	
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
	        //查询参数直接添加在queryParams中
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
							startDate : $('#startDate').attr('value'),	// 起始时间
							endDate : $('#endDate').attr('value'), 		// 结束时间
							gsmfid : $('#gsmfid').attr('value'),		// 门店编码
							gsrq : $('#gsrq').attr('value')             // 销售日期
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
    		//根据用户是供应商还是零售商，获取供应商编码
    		//var supcode = '';
			//if(User.sutype == 'L'){
			//	supcode = $("#supcode").val();
			//}else{
			//	supcode = User.supcode;
			//}   
        	$('#zsgdid').attr('value',value);   
	        //查询参数直接添加在queryParams中
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
							startDate : $('#startDate').attr('value'),	// 起始时间
							endDate : $('#endDate').attr('value'), 		// 结束时间
							zsmfid : $('#gsmfid').attr('value'),		// 门店编码
							gsrq : $('#gsrq').attr('value'), 			// 销售日期
							zsgdid : $('#zsgdid').attr('value')         // 商品编码
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
                       $.messager.alert('提示','获取接收人失败!<br>原因：' + data.returnInfo,'error');
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
<!-- ---------- 查询条件输入区开始 ---------- -->
<table width="850"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">销售汇总查询<%if(currUser.getSgcode().equals("3007")){%>( 说明：预估销售成本是以商品的最新进价进行核算,和月结后的成本可能不一样)<%}%></td>
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
			起始日期：<input type="text" id="startDate" name="startDate" type="text" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});"size="20" />
		</td>
		<td width="300" style="border: none;">
			结束日期：<input type="text" id="endDate" name="endDate" type="text" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" />
		</td>
		<td width="250" style="border: none;">
			
			<%if("3018".equals(currUser.getSgcode())){%>
			<div id="supcodeDiv" style="">供应商编码：&nbsp;&nbsp;<input class="easyui-combobox" id="supcode" name="supcode" value="" size="20" panelHeight="auto"/></div>
			<%}else if("3006".equals(currUser.getSgcode())){%>
			<%}else{%>
			<div id="supcodeDiv" style="">供应商编码：&nbsp;&nbsp;<input type="text" id="supcode" name="supcode" value="" size="20" /></div>
			<%} %>
		</td>
	</tr>
	<tr>
		<td id="mainTabTd" colspan="3" width="300" align="left" style="border: none;">门&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;店： 
			<select style="width: 154px;" name='gsmfids' id="gsmfids" size='1'>
				<option value=''>所有门店</option>
			</select>
		</td>
	</tr>
	<tr>
		<td align="left" colspan="3" style="border: none;"><img
			src="images/sure.jpg" border="0" onClick="reloadgrid();" /></td>
	</tr>
	<tr>
		<td colspan="3">
			<!-- table 中显示列表的信息 -->
			<div id="saledatagrid" style="display: none;">
				<div id="saleExportExcel" align="right" style="color: #336699; width: 486px">
					<a href="javascript:exportExcel();">>>导出Excel表格</a>
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
					<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-back" onClick="backSalegrid();">返回</a>-->
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
					<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-back" onClick="backSaleShopgrid();">返回</a> -->
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
					<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-back" onClick="backSaleGsrqgrid();">返回</a> -->
					<img src="images/goback.jpg" border="0" onClick="backSaleGsrqgrid();" />
				</div>
			</div>
		</td>
	</tr>
</table>
</center>
</body>
<script type="text/javascript">
// 加载门店
var obj = document.getElementById("gsmfids");
loadAllShop(obj);

//获取所有门店信息
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
                   	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
				            var html = "<option value='" + n.SHPCODE + "'>" + n.SHPNAME + "</option>";  
				            $(list).append(html);  
				        });						        
                   	 }	                    	 
                   	 $(list).attr('isLoad' , true );
                   }else{ 
                       $.messager.alert('提示','获取门店信息失败!<br>原因：' + data.returnInfo,'error');
                   } 
           	},
           	'json'
           );				
	}
}
</script>
</html>