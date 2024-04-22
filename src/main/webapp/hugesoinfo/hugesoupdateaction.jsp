<%@page import="java.io.File"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
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
		
		String h_num=multi.getParameter("h_num");
		hdto.setH_num(h_num);
		String h_name = multi.getParameter("h_name");
		hdto.setH_name(h_name);
		String h_photo = multi.getFilesystemName("h_photo");
		if(h_photo==null){
	    	String oldPhoto=hdao.getData(h_num).getH_photo();
	    	hdto.setH_photo(oldPhoto);
	    }else{
	    	String filePath=uploadPath+"/"+hdao.getData(h_num).getH_photo();
	    	File file=new File(filePath);
			if(file.exists()){
				file.delete();
			}
	    	hdto.setH_photo(h_photo);
	    }
		String h_hp1 = multi.getParameter("h_hp1");
		String h_hp2 = multi.getParameter("h_hp2");
		String h_hp3 = multi.getParameter("h_hp3");
		String h_hp = h_hp1+"-"+h_hp2+"-"+h_hp3;
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
		if(h_pyeon4.equals("ul")){
			h_pyeon4="없음";
		}
		hdto.setH_pyeon(h_pyeon4);
		String h_gasolin = multi.getParameter("h_gasolin");
		hdto.setH_gasolin(h_gasolin.equals("")?"없음":h_gasolin);
		String h_disel = multi.getParameter("h_disel");
		hdto.setH_disel(h_disel.equals("")?"없음":h_disel);
		String h_lpg = multi.getParameter("h_lpg");
		hdto.setH_lpg(h_lpg.equals("")?"없음":h_lpg);
		
		hdao.updateHugesoinfo(hdto);
		
		BrandDto bdto=new BrandDto();
		BrandDao bdao=new BrandDao();
		
		bdto.setH_num(h_num);
		
		int brandcount=Integer.parseInt(multi.getParameter("brandcount"));
		if(brandcount>0){
			List<String> numList=new ArrayList<String>();
			for(int i=1;i<=brandcount;i++){
				String b_num=multi.getParameter("b_num"+i);
				if(b_num.equals("")){
					String b_name = multi.getParameter("b_name"+i);
					bdto.setB_name(b_name);
					String b_photo = multi.getFilesystemName("b_photo"+i);
					bdto.setB_photo(b_photo);
					String b_addr = multi.getParameter("b_addr"+i);
					bdto.setB_addr(b_addr);
					
					bdao.insertBrand(bdto);
					
					numList.add(bdao.getBrandNum(bdto));
				} else{
					bdto.setB_num(b_num);
					String b_name = multi.getParameter("b_name"+i);
					bdto.setB_name(b_name);
					String b_photo = multi.getFilesystemName("b_photo"+i);
					String oldPhoto=bdao.getBrandData(b_num).getB_photo();
					if(b_photo==null){
				    	bdto.setB_photo(oldPhoto);
				    }else{
				    	bdto.setB_photo(b_photo);
				    	
				    	String filePath=uploadPath+"/"+oldPhoto;
						File file=new File(filePath);
						if(file.exists()){
							file.delete();
						}
				    }
					String b_addr = multi.getParameter("b_addr"+i);
					bdto.setB_addr(b_addr);
					
					bdao.updateBrand(bdto);
					
					numList.add(b_num);
				}
			}
			List<String> hugesoBrandList=bdao.getHugesoBrandNum(h_num);
			for(int i=0;i<hugesoBrandList.size();i++){
				String b_num=hugesoBrandList.get(i);
				boolean flag=true;
				for(int j=0;j<numList.size();j++){
					if(b_num.equals(numList.get(j))){
						flag=false;
					}
				}
				if(flag){
					//파일삭제
					String filePath=uploadPath+"/"+bdao.getBrandData(b_num).getB_photo();
					File file=new File(filePath);
					if(file.exists()){
						file.delete();
					}
					
					bdao.deleteBrand(b_num);
				}
			}
		} else{
			List<BrandDto> blist=bdao.selectBrand(h_num);
			
			//파일삭제
			for(int i=0;i<blist.size();i++){
				bdto=blist.get(i);
				
				String filePath=uploadPath+"/"+bdao.getBrandData(bdto.getB_num()).getB_photo();
				File file=new File(filePath);
				if(file.exists()){
					file.delete();
				}
			}
			
			bdao.deleteHugesoBrand(h_num);
		}
		
		FoodDto fdto=new FoodDto();
		FoodDao fdao=new FoodDao();
		
		fdto.setH_num(h_num);
		
		int foodcount=Integer.parseInt(multi.getParameter("foodcount"));
		if(foodcount>0){
			List<String> numList=new ArrayList<String>();
			for(int i=1;i<=foodcount;i++){
				String f_num=multi.getParameter("f_num"+i);
				if(f_num.equals("")){
					String f_name = multi.getParameter("f_name"+i);
					fdto.setF_name(f_name);
					String f_photo = multi.getFilesystemName("f_photo"+i);
					fdto.setF_photo(f_photo);
					String f_price = multi.getParameter("f_price"+i);
					fdto.setF_price(f_price);
					
					fdao.insertFood(fdto);
					
					numList.add(fdao.getFoodNum(fdto));
				} else{
					fdto.setF_num(f_num);
					String f_name = multi.getParameter("f_name"+i);
					fdto.setF_name(f_name);
					String f_photo = multi.getFilesystemName("f_photo"+i);
					String oldPhoto=fdao.getFoodData(f_num).getF_photo();
					if(f_photo==null){
				    	fdto.setF_photo(oldPhoto);
				    }else{
				    	fdto.setF_photo(f_photo);
				    	
				    	String filePath=uploadPath+"/"+oldPhoto;
						File file=new File(filePath);
						if(file.exists()){
							file.delete();
						}
				    }
					String f_price = multi.getParameter("f_price"+i);
					fdto.setF_price(f_price);
					
					fdao.updateFood(fdto);
					
					numList.add(f_num);
				}
			}
			List<String> hugesoFoodList=fdao.getHugesoFoodNum(h_num);
			for(int i=0;i<hugesoFoodList.size();i++){
				String f_num=hugesoFoodList.get(i);
				boolean flag=true;
				for(int j=0;j<numList.size();j++){
					if(f_num.equals(numList.get(j))){
						flag=false;
					}
				}
				if(flag){
					//파일삭제
					String filePath=uploadPath+"/"+fdao.getFoodData(f_num).getF_photo();
					File file=new File(filePath);
					if(file.exists()){
						file.delete();
					}
					
					fdao.deleteFood(f_num);
				}
			}
		} else{
			List<FoodDto> flist=fdao.selectFood(h_num);
			
			//파일삭제
			for(int i=0;i<flist.size();i++){
				fdto=flist.get(i);
				
				String filePath=uploadPath+"/"+fdao.getFoodData(fdto.getF_num()).getF_photo();
				File file=new File(filePath);
				if(file.exists()){
					file.delete();
				}
			}
			
			fdao.deleteHugesoFood(h_num);
		}
		
		//휴게소 목록으로 이동
		response.sendRedirect("../index.jsp?main=hugesoinfo/hugesolist.jsp");
		
	 } catch(Exception e) {
		
	}
%>