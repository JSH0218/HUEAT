<%@page import="org.apache.tomcat.util.http.fileupload.FileUploadException"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Date"%>
<%@page import="org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext"%>
<%@page import="org.apache.tomcat.util.http.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");
	response.setCharacterEncoding("utf-8");

	//파일 업로드 처리
	DiskFileItemFactory factory = new DiskFileItemFactory();
	ServletFileUpload upload = new ServletFileUpload(factory);
	upload.setHeaderEncoding("utf-8");
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddHHmmSS");
	
	ArrayList<String> b_photo = new ArrayList<>();
    ArrayList<String> f_photo = new ArrayList<>();
    ArrayList<String> b_name = new ArrayList<>();
    ArrayList<String> f_name = new ArrayList<>();
    ArrayList<String> b_addr = new ArrayList<>();
    ArrayList<String> f_price = new ArrayList<>();
    
    String h_photo="없음";
    
	
	try {
	    List<FileItem> items = upload.parseRequest(new ServletRequestContext(request));
	    
	    // 각 파일에 대한 처리
	    for (FileItem item : items) {
	        if (!item.isFormField()) { // 파일 필드인 경우
	            // 파일 업로드 처리
	            String fieldName = item.getFieldName(); // 필드 이름
	            String fileName = item.getName(); // 파일 이름
	         	// 중복 파일명 방지를 위해 유니크한 파일명 생성
	         	String currentTime = sdf.format(new Date());
	            String uniqueFileName = currentTime + "_" + fileName;
	            
	            // 파일 저장 디렉토리 설정
	            String uploadPath = getServletContext().getRealPath("/hugesosave");
	            
	            // 파일 저장 경로와 파일명을 결합하여 파일 객체 생성
	            File uploadedFile = new File(uploadPath + File.separator + uniqueFileName);
	            
	            // 파일 저장
	            item.write(uploadedFile);
	            
	            if(fieldName.equals("b_photo")){
	            	b_photo.add(uniqueFileName);
	            } else if(fieldName.equals("f_photo")){
	            	f_photo.add(uniqueFileName);
	            } else if(fieldName.equals("h_photo")){
	            	h_photo=uniqueFileName;
	            }
	            
	        } else {
	            // 텍스트 필드인 경우
	            String fieldName = item.getFieldName(); // 필드 이름
	            String value = item.getString(); // 필드 값
	            
	            // 필요한 작업을 수행합니다.
	            if(fieldName.equals("h_name")) {
	                String h_name = value;
	                System.out.println("h_name: " + h_name);
	            } else if(fieldName.equals("h_hp")) {
	                String h_hp = value;
	                System.out.println("h_hp: " + h_hp);
	            } else if(fieldName.equals("h_addr")) {
	                String h_addr = value;
	                System.out.println("h_addr: " + h_addr);
	            } else if(fieldName.equals("h_xvalue")) {
	                String h_xvalue = value;
	                System.out.println("h_xvalue: " + h_xvalue);
	            } else if(fieldName.equals("h_yvalue")) {
	                String h_yvalue = value;
	                System.out.println("h_yvalue: " + h_yvalue);
	            } else if(fieldName.equals("h_pyeon")) {
	                String[] h_pyeon = request.getParameterValues("h_pyeon");
	                if(h_pyeon != null) {
	                    System.out.println("h_pyeon: " + Arrays.toString(h_pyeon));
	                }
	            } else if(fieldName.equals("h_gasolin")) {
	                String h_gasolin = value;
	                System.out.println("h_gasolin: " + h_gasolin);
	            } else if(fieldName.equals("h_disel")) {
	                String h_disel = value;
	                System.out.println("h_disel: " + h_disel);
	            } else if(fieldName.equals("h_lpg")) {
	                String h_lpg = value;
	                System.out.println("h_lpg: " + h_lpg);
	            } else if(fieldName.equals("b_name")){
	            	b_name.add(value);
	            } else if(fieldName.equals("f_name")){
	            	f_name.add(value);
	            } else if(fieldName.equals("b_addr")){
	            	b_addr.add(value);
	            } else if(fieldName.equals("f_price")){
	            	f_price.add(value);
	            }
	        }
	    }
	    
	    System.out.println("h_photo: " + h_photo);
	    System.out.println("b_photo: " + b_photo.toString());
	    System.out.println("f_photo: " + f_photo.toString());
	    System.out.println("b_name: " + b_name.toString());
	    System.out.println("b_addr: " + b_addr.toString());
	    System.out.println("f_name: " + f_name.toString());
	    System.out.println("f_price: " + f_price.toString());
	    System.out.println("다잘되나? ");
	} catch (FileUploadException e) {
	    e.printStackTrace();
	} catch (Exception e) {
	    e.printStackTrace();
	}
%>

<h1>b_addr: <%=b_addr.toString() %></h1>
</body>
</html>