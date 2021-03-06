$(document).ready(function(){      
    //A文件上传   
        $("#uploadFile").uploadify({   
        'uploader'       : 'images/uploadify.swf',//指定上传控件的主体文件，默认‘uploader.swf’   
        'script'         : 'UploadServlet', //指定服务器端上传处理文件   
        'scriptData'     : {'uploadFile':$('#uploadFile').val()},   
        'cancelImg'      : 'images/cancel.png',   
        'fileDataName'   : 'uploadFile',   
        'fileDesc'       : 'jpg文件或jpeg文件或gif文件',  //出现在上传对话框中的文件类型描述   
        'fileExt'        : '*.jpg;*.jpeg;*.gif',      //控制可上传文件的扩展名，启用本项时需同时声明fileDesc   
        'sizeLimit'      : 512000,           //控制上传文件的大小，单位byte                
        'folder'         : '/uploadImages',   
        'queueID'        : 'fileQueueA',   
        'auto'           : false,   
        'multi'          : true  
    });   
});