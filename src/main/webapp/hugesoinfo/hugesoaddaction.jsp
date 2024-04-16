<%@page import="food.model.FoodDao"%>
<%@page import="food.model.FoodDto"%>
<%@page import="brand.model.BrandDao"%>
<%@page import="brand.model.BrandDto"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@page import="hugesoinfo.model.HugesoInfoDto"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//이미지 업로드 경로
	String uploadPath = getServletContext().getRealPath("/hugesosave");
	System.out.println(uploadPath);
	
	//업로드할 사이즈
	int uploadSize = 1024*1024*5;
	
	MultipartRequest multi = null;
	
	try {
		
		multi = new MultipartRequest(request, uploadPath, uploadSize, "utf-8", new DefaultFileRenamePolicy());
		
		HugesoInfoDto hdto=new HugesoInfoDto();
		HugesoInfoDao hdao=new HugesoInfoDao();
		
		String h_name = multi.getParameter("h_name");
		hdto.setH_name(h_name);
		String h_photo = multi.getFilesystemName("h_photo");
		hdto.setH_photo(h_photo);
		String h_hp = multi.getParameter("h_hp");
		hdto.setH_hp(h_hp);
		String h_addr = multi.getParameter("h_addr");
		hdto.setH_addr(h_addr);
		String h_xvalue = multi.getParameter("h_xvalue");
		hdto.setH_xvalue(h_xvalue);
		String h_yvalue = multi.getParameter("h_yvalue");
		hdto.setH_yvalue(h_yvalue);
		String [] h_pyeon=multi.getParameterValues("h_pyeon");
		String h_pyeon2=Arrays.toString(h_pyeon);
		String h_pyeon3=h_pyeon2.substring(1, h_pyeon2.length()-1);
		String h_pyeon4=h_pyeon3.replaceAll("\\s+", "");
		hdto.setH_pyeon(h_pyeon4);
		String h_gasolin = multi.getParameter("h_gasolin");
		hdto.setH_gasolin(h_gasolin.equals("")?"없음":h_gasolin);
		String h_disel = multi.getParameter("h_disel");
		hdto.setH_disel(h_disel.equals("")?"없음":h_disel);
		String h_lpg = multi.getParameter("h_lpg");
		hdto.setH_lpg(h_lpg.equals("")?"없음":h_lpg);
		
		hdao.insertHugesoinfo(hdto);
		
		String h_num=hdao.selectHugesoNum(h_xvalue, h_yvalue);
		
		BrandDto bdto=new BrandDto();
		BrandDao bdao=new BrandDao();
		
		bdto.setH_num(h_num);
		
		int brandcount=Integer.parseInt(multi.getParameter("brandcount"));
		if(brandcount>0){
			for(int i=1;i<=brandcount;i++){
				String b_name = multi.getParameter("b_name"+i);
				bdto.setB_name(b_name);
				String b_photo = multi.getFilesystemName("b_photo"+i);
				bdto.setB_photo(b_photo);
				String b_addr = multi.getParameter("b_addr"+i);
				bdto.setB_addr(b_addr);
				
				bdao.insertBrand(bdto);
			}
		}
		
		FoodDto fdto=new FoodDto();
		FoodDao fdao=new FoodDao();
		
		fdto.setH_num(h_num);
		
		int foodcount=Integer.parseInt(multi.getParameter("foodcount"));
		if(foodcount>0){
			for(int i=1;i<=foodcount;i++){
				String f_name = multi.getParameter("f_name"+i);
				fdto.setF_name(f_name);
				String f_photo = multi.getFilesystemName("f_photo"+i);
				fdto.setF_photo(f_photo);
				String f_price = multi.getParameter("f_price"+i);
				fdto.setF_price(f_price);
				
				fdao.insertFood(fdto);
			}
		}
		
		//공지사항 목록으로 이동
		response.sendRedirect("../index.jsp?main=hugesoinfo/hugesolist.jsp");
		
	 } catch(Exception e) {
		
	}
%>