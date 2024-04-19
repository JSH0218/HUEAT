<%@page import="hugesoinfo.model.HugesoInfoDto"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@page import="food.model.FoodDto"%>
<%@page import="food.model.FoodDao"%>
<%@page import="java.io.File"%>
<%@page import="java.util.List"%>
<%@page import="brand.model.BrandDto"%>
<%@page import="brand.model.BrandDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String h_num=request.getParameter("h_num");
	String uploadPath = getServletContext().getRealPath("/hugesosave");
	
	BrandDao bdao=new BrandDao();
	BrandDto bdto=new BrandDto();
	List<BrandDto> blist=bdao.selectBrand(h_num);
	
	//브랜드 파일삭제
	for(int i=0;i<blist.size();i++){
		bdto=blist.get(i);
		
		String filePath=uploadPath+"/"+bdao.getBrandData(bdto.getB_num()).getB_photo();
		File file=new File(filePath);
		if(file.exists()){
			file.delete();
		}
	}
	
	bdao.deleteHugesoBrand(h_num);
	
	FoodDao fdao=new FoodDao();
	FoodDto fdto=new FoodDto();
	List<FoodDto> flist=fdao.selectFood(h_num);
	
	//음식 파일삭제
	for(int i=0;i<flist.size();i++){
		fdto=flist.get(i);
		
		String filePath=uploadPath+"/"+fdao.getFoodData(fdto.getF_num()).getF_photo();
		File file=new File(filePath);
		if(file.exists()){
			file.delete();
		}
	}
	
	fdao.deleteHugesoFood(h_num);
	
	HugesoInfoDao hdao=new HugesoInfoDao();
	HugesoInfoDto hdto=new HugesoInfoDto();
	
	//휴게소 파일삭제
	String filePath=uploadPath+"/"+hdao.getData(h_num).getH_photo();
	File file=new File(filePath);
	if(file.exists()){
		file.delete();
	}
	
	//휴게소 데이터삭제
	hdao.deleteHugesoinfo(h_num);
	
	//휴게소 목록으로 이동
	response.sendRedirect("../index.jsp?main=hugesoinfo/hugesolist.jsp");
%>