<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>�Żݵ���ѯ</title>

<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		out.println("��ǰ�û��ѳ�ʱ,�����µ�½!");
		out.println("<a href='login.jsp' >��˵�¼</a>");
		return;
	}
	SysScmuser currUser = (SysScmuser)obj;
	String sucode= currUser.getSucode();
%>
<script type="text/javascript">
		var now = new Date();
		now.setDate( now.getDate() - 7 );
		$("#startDate").val( now.format('yyyy-MM-dd') );
		$("#endDate").attr("value",new Date().format('yyyy-MM-dd'));
		$("#POPdatagrid").hide();
		
		$(function(){
			$('#POP').datagrid({
				//width:930,
				width: User.sutype == 'S' ? 830 : 930,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'��������...',				
				columns:[[
				    {field:'POPSEQUECE',title:'�Żݵ���',width:110,align:'center',sortable:true},
				     <%
					if("3015".equalsIgnoreCase( currUser.getSgcode())){
					%>
						{field:'PPLB',title:'��������',width:70,align:'center',sortable:true},
					<%}%>
				    <%
					if("3004".equalsIgnoreCase( currUser.getSgcode()) || "3023".equalsIgnoreCase( currUser.getSgcode())){
					%>
						{field:'DZLX',title:'��������',width:70,align:'center',sortable:true},
					<%}else if("3006".equalsIgnoreCase( currUser.getSgcode())){
					%>	
						{field:'PPMARKET',title:'�ŵ���',width:100,align:'center',sortable:true},
					<%	
					}else{%>
						{field:'PPMARKET',title:'�ŵ���',width:60,align:'center',sortable:true},
				    	{field:'SHOPNAME',title:'�ŵ�����',width:100,align:'center',sortable:true},
					<%}%>
				    
				    {field:'PPGDID',title:'��Ʒ����',width:100,sortable:true},				
				
				    <%if("3010".equalsIgnoreCase( currUser.getSgcode())){%>
				     {field:'BARCODE',title:'��Ʒ����',width:80,sortable:true},<%}%>
				    {field:'GDNAME',title:'��Ʒ����',width:100,sortable:true},
				    {field:'PPKSRQ',title:'��ʼ����',width:65,align:'center',sortable:true},
				    {field:'PPJSRQ',title:'��������',width:65,align:'center',sortable:true},
				    {field:'PPCXSJ',title:'�����ۼ�',width:80,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
				    
				     {field:'PPYSSJ',title:'ԭ���۵���',width:80,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'PPSUPID',title:'��Ӧ�̱���',width:80,align:'center',sortable:true},	
						{field:'SUPNAME',title:'��Ӧ������',width:100,align:'center',sortable:true}
					<%}%>
				]],
				pagination:true,
				rownumbers:true
			});
			
			//����ǹ�Ӧ���û������ع�Ӧ�̱�������򣬷�����ʾ
			if(User.sutype == 'L'){
				$("#sup").show();
			}else{
				$("#sup").hide();
			}
			
			if(User.sgcode=='3018'){
			 $('#supcodequery').combobox({
				width: 154,
				valueField:'SUPCODE',
				textField:'SUNAME'
			});	 
			}  
		}
		);
        
		function reloadgrid ()  {
        	//��֤�û����������Ƿ�Ϸ���
			var startDate = $("#startDate").attr("value");   
			var endDate = $("#endDate").attr("value");
			if(startDate == '' || endDate == ''){
				$.messager.alert('��ʾ','�����뿪ʼ��������ڣ�����','info');
				return;
			} 
			//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���  
			//alert(User.sgcode);
			
			
			
			var supcode = '';
			if(User.sutype == 'L' && User.sgcode=='3018'){
				supcode = $('#supcodequery').combobox('getValue');
				
			}else if(User.sutype == 'L' && User.sgcode!=='3018'){
			supcode = $('#supcodequery').val();
				
			}else {
			supcode = User.supcode;
			}  
	        //��ѯ����ֱ�������queryParams��
	        $('#POP').datagrid('options').url = 'JsonServlet';        
			$('#POP').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getPOP',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.POPQuery',
						ACTION_MANAGER : 'popQueryManager',	
						list:[{
							sgcode : User.sgcode,
							popsupcode : supcode,
							popgdid : $('#gdid').attr('value'),//��Ʒ����
							popgdname : $('#gdname').attr('value'),//��Ʒ����
							popmarket : $('#shopcode').attr('value'),// �ŵ����
							startDate : $('#startDate').attr('value'),
							endDate : $('#endDate').attr('value')
						}]
					}
				)
			};		
			$("#POPdatagrid").show();
			$("#POP").css("display","");
			$("#POP").datagrid('reload'); 
			$("#POP").datagrid('resize'); 
				$('#supcodequery').combobox('setValue','');
    	}
    	
	    function padLeft(str, lenght) {
            if (str.length >= lenght)
                return str;
            else
                return padLeft("0" + str, lenght);
        }   
  
    	function exportExcel(){
			//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���
			var supcode = '';
			if(User.sutype == 'L' && User.sgcode=='3018'){
				supcode = $('#supcodequery').combobox('getValue');
				
			}else if(User.sutype == 'L' && User.sgcode!=='3018'){
			supcode = $('#supcodequery').val();
				
			}else {
			supcode = User.supcode;
			}  
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'getPOP',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.POPQuery',
								ACTION_MANAGER : 'popQueryManager',										 
								list:[{
									exportExcel : true,
									<%
									if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
									%>
									enTitle: ['POPSEQUECE'<%="3015".equalsIgnoreCase(currUser.getSgcode()) ? ",'PPLB'" : ""%><%="3004".equalsIgnoreCase(currUser.getSgcode()) || "3023".equalsIgnoreCase(currUser.getSgcode()) ? ",'DZLX'" : ",'PPMARKET'"%>,'PPGDID','GDNAME','PPKSRQ','PPJSRQ','PPCXSJ','PPYSSJ','PPSUPID','SUPNAME'],
									cnTitle: ['�Żݵ���'<%="3015".equalsIgnoreCase(currUser.getSgcode()) ? ",'��������'" : ""%><%="3004".equalsIgnoreCase(currUser.getSgcode()) || "3023".equalsIgnoreCase(currUser.getSgcode()) ? ",'��������'" : ",'�ŵ����'"%>,'��Ʒ����','��Ʒ����','��ʼ����','���������','�����ۼ�','ԭ���۵���','��Ӧ�̱���','��Ӧ������'],
									<%}else{%>
									enTitle: ['POPSEQUECE'<%="3015".equalsIgnoreCase(currUser.getSgcode()) ? ",'PPLB'" : ""%><%="3004".equalsIgnoreCase(currUser.getSgcode()) || "3023".equalsIgnoreCase(currUser.getSgcode()) ? ",'DZLX'" : ",'PPMARKET'"%>,'PPGDID','GDNAME','PPKSRQ','PPJSRQ','PPCXSJ','PPYSSJ' ],
									cnTitle: ['�Żݵ���'<%="3015".equalsIgnoreCase(currUser.getSgcode()) ? ",'��������'" : ""%><%="3004".equalsIgnoreCase(currUser.getSgcode()) || "3023".equalsIgnoreCase(currUser.getSgcode()) ? ",'��������'" : ",'�ŵ����'"%>,'��Ʒ����','��Ʒ����','��ʼ����','���������','�����ۼ�','ԭ���۵���'],
									<%}%>
									sheetTitle: '��Ʒ�Żݵ���ѯ',
									sgcode : User.sgcode,
									popsupcode : supcode,
									popgdid : $('#gdid').attr('value'),//��Ʒ����
									popgdname : $('#gdname').attr('value'),//��Ʒ����
									popmarket : $('#shopcode').attr('value'),// �ŵ���� 
									startDate : $('#startDate').attr('value'),
									endDate : $('#endDate').attr('value')
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
		$().ready(function(){
			if("<%=sucode%>".substring(0,4) == "3006"){
				$("#MD").css("display","none");
			}
		});
		
		
		$(function(){
		
		
			
			if( !$('#supcodequery').data('isLoad') ){
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
	                    	 	$('#supcodequery').combobox('loadData', data.rows );
	                    	 }
	                    }else{ 
	                        $.messager.alert('��ʾ','��ȡ������ʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
			}
		
		}	);	
 	</script>
</head>
<body>
<center>

<table id="QueryTable" width="960" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">��Ʒ�Żݵ���ѯ</td>
	</tr>
	<tr>
		<td id="MD" style="border: none;width:250"><font style="text-align:center;letter-spacing:25px">�ŵ�</font>�� <select
			style="width: 154px;" name='shopcode' id="shopcode" size='1'>
			<option value=''>�����ŵ�</option>
		</select></td>

		<td  style="border: none;width:250">��ʼ���ڣ� <input
			type="text" id="startDate" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});"size="20" /></td>
		<td  style="border: none;width:280"><font style="text-align:center;letter-spacing:3px">�������ڣ�</font> <input type="text"
			id="endDate" name="endDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" /></td>
	</tr>
	<tr>
			<td  style="border:none;width: 250px;">��Ʒ���룺
			<input type="text" id="gdid" name="gdid" size="20"/>
        	</td>
	        <td  style="border:none;width: 250px;">��Ʒ���ƣ�
	        <input type="text" id="gdname" name="gdname" size="20"/>
	        </td>
	        <%if("3018".equals(currUser.getSgcode())){%>
		    <td id="sup"  style="border:none;width:250px;">��Ӧ�̱��룺
			<input class="easyui-combobox"  id="supcodequery" name="supcodequery" size="20" panelHeight="auto"/>
			
			</td>
			<%}else{%>
			 <td id="sup"  style="border:none;width:250px;">��Ӧ�̱��룺
			<input type="text" id="supcodequery" name="supcodequery" size="20"/></td>
			<%} %>
			
	
			<td style="border: none;"></td>
	</tr>
	<tr>
		<td style="border: none;"><img src="images/sure.jpg" border="0"
			onclick="reloadgrid();" /></td>
		<td style="border: none;"></td>
		<td style="border: none;"></td>
	</tr>
	<tr>
		<td colspan="3">
			<!-- table ����ʾ�б����Ϣ -->
			<div id="POPdatagrid" >
				<div  align="right" style="color: #336699; width: <%="S".equalsIgnoreCase(currUser.getSutype().toString()) ? "750" : "930" %>px">
					<a href="javascript:exportExcel();">>>����Excel���</a></div>
				<table id="POP"></table>
			</div>
		</td>
	</tr>

</table>
</center>
</body>
<script type="text/javascript">
// �����ŵ�
var obj = document.getElementById("shopcode");
loadAllShop(obj);
</script>
</html>