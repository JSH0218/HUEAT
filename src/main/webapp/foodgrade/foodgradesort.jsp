<%@page import="food.model.FoodDto"%>
<%@page import="food.model.FoodDao"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.util.List"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String h_num = request.getParameter("h_num");
    String sortType = request.getParameter("sortType");

    FoodDao dao = new FoodDao();
    List<FoodDto> list;

    // 정렬 유형에 따라 적절한 메서드를 호출하여 평점 목록을 가져옴
    if (sortType.equals("latest")) {
        list = dao.selectFoodLatest(h_num);
    } else if (sortType.equals("high")) {
        list = dao.selectFoodHigh(h_num);
    } else if (sortType.equals("low")) {
        list = dao.selectFoodLow(h_num);
    } else {
        // 기본적으로 최신순으로 정렬
        list = dao.selectFoodLatest(h_num);
    }

    // HTML 생성을 위한 문자열
    StringBuilder htmlBuilder = new StringBuilder();

    for (FoodDto dto : list) {
        // 각 음식에 대한 HTML 생성
        htmlBuilder.append("<div class=\"food-item\" style=\"text-align: center; font-weight: bold; margin-bottom: 20px; margin-right: 20px; cursor: pointer;\" data-fnum=\"")
                   .append(dto.getF_num())
                   .append("\">")
                   .append("<img alt=\"").append(util.SecurityUtil.escapeHtml(dto.getF_name())).append("\" src=\"image/food/").append(util.SecurityUtil.escapeHtml(dto.getF_photo()))
                   .append("\" style=\"width: 220px; height: 200px; margin-bottom: 15px;\" data-fnum=\"").append(dto.getF_num()).append("\"><br>")
                   .append("<div style=\"display: inline-block;\" class=\"starrating\">")
                   .append("<label style=\"-webkit-text-fill-color: gold; font-size: 15px;\">★</label>")
                   .append("<p class=\"avggrade2\" style=\"font-weight: bold; font-size: 15px; display: inline-block;\">").append(dto.getF_grade()).append("</p>")
                   .append("</div>")
                   .append(util.SecurityUtil.escapeHtml(dto.getF_name()))
                   .append("</div>");
    }
%>
<%= htmlBuilder.toString() %>
