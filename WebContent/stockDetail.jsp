<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8">
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>��Ʒ�����ϸ��ѯ</title>
<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}		
		SysScmuser currUser = (SysScmuser)obj;
		String suType = currUser.getSutype() + " " ;
	%>
	
	
<style>
a:hover {
	text-decoration: underline;
	color: red
}
</style>
<script type="text/javascript">

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
	                    	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ���������ӵ�Ŀ���б���  
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
			$('#stockDetail').datagrid({
				width: User.sutype == 'L' ? 1022:817,
				iconCls:'icon-save',
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',
				sortOrder: 'desc',
				remoteSort: true,	
				singleSelect : true,
				fitColumns:false,
				showFooter:true,	
				loadMsg:'��������...',				
				columns:[[
					{field:'ZSGXTIME',title:'���ͳ������',width:80,align:'center',sortable:true,
						   formatter:function(value,rec){
							if( value != null && value != undefined && value != '�ϼƣ�' )
								return new Date(value.time).format('yyyy-MM-dd');
								else 
								return value;
						}
					},
					{field:'SHPCODE',title:'�ŵ����',width:60,align:'center',sortable:true}, 
					{field:'SHPNAME',title:'�ŵ�����',width:188,align:'center',sortable:true},
					{field:'GDID',title:'��Ʒ����',width:60,align:'center',sortable:true},
					{field:'GDBARCODE',title:'��Ʒ����',width:100,align:'center',sortable:true},
					{field:'GDNAME',title:'��Ʒ����',width:200,align:'left',sortable:true},
					{field:'GDSPEC',title:'���',width:45,align:'center',sortable:true},
					{field:'GDUNIT',title:'��λ',width:45,align:'center',sortable:true},
					{field:'ZSKCSL',title:'�������',width:55,align:'center',sortable:true},
					{field:'ZSKCJE',title:'�����۽��',width:150,align:'center',sortable:true}
					<%if("L".equals(suType)){%>
					,{field:'SUPID',title:'��Ӧ�̱���',width:70,align:'center',sortable:true},	
					{field:'SUPNAME',title:'��Ӧ������',width:160,align:'center',sortable:true}
					<%}%>
				]],
				toolbar:[{
					text:'����Excel',
					iconCls:'icon-redo',
					handler:function(){
						exportExcel();
					}
				}],
				pagination:true,
				rownumbers:true
			});
			if(User.sutype == 'L'){
				$("#zssupidDiv").show();
			}else{
				$("#zssupidDiv").hide();
			}
		});		
		
		function reloadgrid ()  {
		//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���
    		var supcode = '';
			if(User.sutype == 'L'){
				supcode = $('#supcode').val();
			}else {
				supcode = User.supcode;
			}
	        $('#stockDetail').datagrid('options').url = 'JsonServlet';        
			$('#stockDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.Stock',
						ACTION_MANAGER : 'ywZrstockDetails',		 
						optType : 'query',
						optContent : '���տ����Ʒ��ϸ��ѯ',		 
						list:[{
						 sgcode : User.sgcode,
						 supcode : supcode,
						 zsmfid : $('#zsmfid').attr('value'),
						 zsgdid : $('#zsgdid').attr('value'),
						 zsgdname : $('#zsgdname').attr('value'),
						 gdbarcode :$('#gdbarcode').attr('value')
						}]
					}
				)
			};		
			
			document.getElementById("saledatagrid").style.display="";
			$("#stockDetail").datagrid('reload'); 
			$("#stockDetail").datagrid('resize'); 
			$('#supcode').combobox('setValue','');
		
    	}
    	function exportExcel(){
			//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���
			var supcode = '';
			if(User.sutype == 'L'){
				supcode = $('#supcode').val();
			}else {
				supcode = User.supcode;
			}  
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'datagrid',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.Stock',
								ACTION_MANAGER : 'ywZrstockDetails',											 
								list:[{
									exportExcel : true,
									<%if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){%>
									enTitle: ['SHPCODE','ZSGXTIME','SHPNAME','GDID','GDBARCODE','GDNAME','GDSPEC','GDUNIT','SUPID','SUPNAME','ZSKCSL','ZSKCJE' ],
									cnTitle: ['�ŵ���','���ͳ������','�ŵ�����','��Ʒ����','��Ʒ����','��Ʒ����','���','��λ','��Ӧ�̱���','��Ӧ������','�������','�����(����˰)'],
									<%}else{%>
									enTitle: ['SHPCODE','ZSGXTIME','SHPNAME','GDID','GDBARCODE','GDNAME','GDSPEC','GDUNIT','ZSKCSL','ZSKCJE' ],
									cnTitle: ['�ŵ���','���ͳ������','�ŵ�����','��Ʒ����','��Ʒ����','��Ʒ����','���','��λ','�������','�����(����˰)'],
									<%}%>
									sheetTitle: '���տ����Ʒ��ϸ��ѯ',
									sgcode : User.sgcode,
									supcode : supcode,
									zsmfid : $('#zsmfid').attr('value'),
									zsgdid : $('#zsgdid').attr('value'),
									zsgdname : $('#zsgdname').attr('value')
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
    	function reset(){
    	    $("#zsmfid").val('');
			$("#zsgdname").val('');
			$("#zsgdid").val('');
			$("#supcode").val('');
			
    	}   
 	</script>
</head>
<body>
<center>
<!-- ---------- ��ѯ������������ʼ ---------- -->
<table width="900"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">���տ����Ʒ��ϸ��ѯ</td>
	</tr>
	<tr>
		<td width="300" style="border: none;">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺<select
			style="width: 155px;" name='zsmfid' id="zsmfid" size='1'>
			<option value=''>�����ŵ�</option>
		</select></td>
		<td width="300" style="border: none;">��Ʒ���ƣ�<input
			type="text" id="zsgdname" name="zsgdname" value="" size="20"
			/></td>
		<td width="300" style="border: none;">��Ʒ���룺<input type="text"
			id="zsgdid" name="zsgdid" value="" size="20"
			/></td>
	</tr>

	<tr>
	
	<td width="300" style="border: none;">
		<div id="zssupidDiv" style="">��Ӧ�̱��룺<input type="text" id="supcode" name="supcode" value="" size="20" /></div>
	</td>
	<td width="300" style="border: none;">��Ʒ���룺<input type="text" id="gdbarcode" name="gdbarcode" value="" size="20" /></td>
	<td style="border: none;">&nbsp;</td>	
	</tr>
	<tr>
	<td style="border: none;">
		<img src="images/sure.jpg" border="0" onclick="reloadgrid();" />     
		<img src="images/back.jpg" border="0" onclick="reset();" /></td>
	</tr>
	<tr>
		<td colspan="3">
			<div id="saledatagrid" style="display: none;">
				<table id="stockDetail" ></table>
			</div>
		</td>
		</tr>
	
</table>

</center>
</body>
<script type="text/javascript">
// �����ŵ�
var obj = document.getElementById("zsmfid");
loadAllShop(obj);
</script>
</html>