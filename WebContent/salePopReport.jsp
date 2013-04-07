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
	%>

<title>������Ʒ�����ջ���</title>
<style>  
a:hover { 
	text-decoration: underline;
	color: red
}
</style>
<script>	 
		var now = new Date();
		$("#startDate").val( now.format('yyyy-MM-dd') );
		$("#endDate").attr("value",new Date().format('yyyy-MM-dd'))
	    
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
		
		$(function(){
			$('#saleShopSummary').datagrid({	
			    title: '',	
				width:836,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',			
				showFooter:true,	
				remoteSort: true,	
				singleSelect: true,	
				loadMsg:'��������...',			
				columns:[[
					{field:'SGLMARKET',title:'�ŵ����',width:80,align:'center',sortable:true},
					{field:'SHPNAME',title:'�ŵ�����',width:80,align:'center',sortable:true},
					{field:'SGLBARCODE',title:'��Ʒ����',width:100,align:'center',sortable:true},
				    {field:'SGLGDID',title:'��Ʒ����',width:100,align:'center',sortable:true},	
				    {field:'GBCNAME',title:'��Ʒ����',width:200,align:'left',sortable:true},
				    <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					{field:'SGLSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},
					{field:'SUPNAME',title:'��Ӧ������',width:200,align:'center',sortable:true},
				    <%
					}
					%>
					{field:'SGLSL',title:'��������',width:80,align:'center',sortable:true},
					{field:'SGLXSSR',title:'��������',width:80,align:'center',sortable:true},
					{field:'SGLTOTZK',title:'���ۿ�',width:80,align:'center',sortable:true},
					{field:'SGLSUPZK',title:'��Ӧ�����ۿ�',width:80,align:'center',sortable:true},
					{field:'SGLPOPZK',title:'�����ۿ�',width:80,align:'center',sortable:true},
					{field:'SGLN1',title:'��ë��',width:80,align:'center',sortable:true}
						
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
		});		
		
		
		//��ѯ
		function reloadgrid ()  {  
			//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���
			var supcode = '';
			if(User.sutype == 'L'){
				supcode = $("#supcode").val();
			}else{
				supcode = User.supcode;
			}  
	        //��ѯ����ֱ�������queryParams��
	        $('#saleShopSummary').datagrid('options').url = 'JsonServlet';        
			$('#saleShopSummary').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getGoodsalepop',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							gssgcode : User.sgcode,
							supcode : supcode,
							gsmfid : $('#gsmfid').attr('value'),        //�ŵ�
							gsgdid : $('#gdgdid').attr('value'),        //��Ʒ����
							startDate : $('#startDate').attr('value'),	// ��ʼʱ��
							endDate : $('#endDate').attr('value') 		// ����ʱ��
						}]
					}
				)
			};	
			$("#saledatagrid").show();
			$("#saleShopSummary").datagrid('reload');  
			$("#saleShopSummary").datagrid('resize');  
    	}
    	
    	function exportExcel(){
    		//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���
			var supcode = '';
			if(User.sutype == 'L'){
				supcode = $("#supcode").val();
				$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'getGoodsalepop',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,									
									enTitle: ['SGLMARKET','SHPNAME','SGLBARCODE','SGLGDID','GBCNAME','SGLSUPID','SUPNAME','SGLSL','SGLXSSR','SGLTOTZK','SGLSUPZK','SGLPOPZK','SGLN1'],
									cnTitle: ['�ŵ���','�ŵ�����','��Ʒ����','��Ʒ����','��Ʒ����','��Ӧ�̱���','��Ӧ������','��������','��������','���ۿ�','��Ӧ�����ۿ�','�����ۿ�','��ë��'],
									sheetTitle: '��Ʒ������ϸ��ѯ',
									gssgcode : User.sgcode,
									supcode : supcode,
									gsmfid : $('#gsmfid').attr('value'),        //�ŵ�
									gsgdid : $('#gdgdid').attr('value'),        //��Ʒ����
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
			}else{
				supcode = User.supcode;
				$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'getGoodsalepop',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,									
									enTitle: ['SGLMARKET','SHPNAME','SGLBARCODE','SGLGDID','GBCNAME','SGLSUPID','SUPNAME','SGLSL','SGLXSSR','SGLTOTZK','SGLSUPZK','SGLPOPZK','SGLN1'],
									cnTitle: ['�ŵ���','�ŵ�����','��Ʒ����','��Ʒ����','��Ʒ����','��Ӧ�̱���','��Ӧ������','��������','��������','���ۿ�','��Ӧ�����ۿ�','�����ۿ�','��ë��'],
									sheetTitle: '��Ʒ������ϸ��ѯ',
									gssgcode : User.sgcode,
									supcode : supcode,
									gsmfid : $('#gsmfid').attr('value'),        //�ŵ�
									gsgdid : $('#gdgdid').attr('value'),        //��Ʒ����
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
			
    	}  	     	
	</script>
</head>
<body>
<center>
<!-- ---------- ��ѯ������������ʼ ---------- -->
<table width="860" id="mainTab"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">������Ʒ�����ջ���</td>
	</tr>
	<tr>
		<td id="mainTabStartDateTd" width="280" style="border: none;">��ʼ���ڣ�<input
			type="text" id="startDate" required="true" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});" /></td>
		<td width="280" style="border: none;">&nbsp;&nbsp;�������ڣ�<input type="text"
			id="endDate" name="endDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" /></td>
		<td id="mainTabTd" width="300" align="right" style="border: none;">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺ <select
			style="width: 154px;" name='gsmfid' id="gsmfid" size='1'>
			<option value=''>�����ŵ�</option>
		</select></td>
	</tr>
	<tr>
		<td width="250" style="border: none;">��Ʒ���룺<input type="text" id="gdgdid" name="gdgdid" width="110" value="" /></td>
		<td style="border: none;" align="left" >
			<div id="supcodeDiv" style="">��Ӧ�̱��룺<input type="text" id="supcode" name="supcode" value="" size="20" /></div>
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td style="border: none;" align="left">
			<img src="images/sure.jpg" border="0" onclick="reloadgrid();" />
		</td>
		<td style="border: none;" ></td>
		<td style="border: none;"></td>
	</tr>
	<tr>
		<td colspan="3">
			<!-- table ����ʾ�б����Ϣ -->
			<div id="saledatagrid" style="display: none;">
				<div id="saleExportExcel" align="right" style="color: #336699; width: 850px">
					<a href="javascript:exportExcel();">>>����Excel���</a>
				</div>
				<table id="saleShopSummary" width="786" ></table>
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





