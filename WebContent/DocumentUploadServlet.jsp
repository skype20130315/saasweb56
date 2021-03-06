<%@page import="com.bfuture.app.saas.util.Constants"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="org.apache.commons.fileupload.FileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.io.File"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%		
// 获取当前登录用户信息
Object obj = session.getAttribute( "LoginUser" );
if( obj == null ){
	response.sendRedirect( "login.jsp" );
	return;
}
SysScmuser currUser = (SysScmuser)obj;
// 执行文档上传操作
FileItemFactory  factory = new DiskFileItemFactory();
ServletFileUpload upload = new ServletFileUpload(factory);
PrintWriter pw = response.getWriter(); 
JSONObject ro = new JSONObject();
try {
	request.setCharacterEncoding("UTF-8");
	List<FileItem> list = upload.parseRequest(request);
		FileItem fileItem = list.get(0);
	
	Long filesize = fileItem.getSize()/1024; // 单位kb

	if(filesize > 5120){ // 如果大于5M
		ro.put("err","附件不能大于5M");
		return;
	}else{
		String name = fileItem.getName().substring(fileItem.getName().lastIndexOf("\\") + 1);
		name=currUser.getSgcode()+"_"+name;
		//name =  name; 	// 文件名
		String uploadAbsolutePath = getServletContext().getInitParameter( "uploadAbsolutePath" ); // 项目外
		String uploadRelativePath = getServletContext().getInitParameter( "uploadRelativePath" ); // 项目内
		
		File uploadedDir = new File(request.getSession().getServletContext().getRealPath("/" + getServletContext().getInitParameter("uploadRelativePath")));
		File uploadedFile = new File(uploadedDir.getPath() + File.separator + name);
		System.out.println(uploadedFile.exists());
		if(uploadedFile.exists()){
			ro.put("err","同名附件已经存在，请重新命名上传附件");
			return;
		}
		System.out.println("上传项目外：" + uploadAbsolutePath + File.separator + name);
		try{
			fileItem.write(new File( uploadAbsolutePath + File.separator + name ));		// 用于linux下，项目外
		}catch(Exception ee)
		{
			System.out.println("路径不存在");
		}
		String webuploadpath = request.getSession().getServletContext().getRealPath( "/" + uploadRelativePath );
		System.out.println("上传项目内: " + webuploadpath + File.separator + name);
		fileItem.write(new File( webuploadpath + File.separator + name)); // 项目内
	}
	
 }catch (FileUploadException e) {
	e.printStackTrace();
} catch (Exception e) {
	e.printStackTrace();
}finally {
	pw.println(JSONObject.fromObject(ro).toString());
	pw.close();
}
 %>