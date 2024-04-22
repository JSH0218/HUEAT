<%@page import="shop.ShopDto"%>
<%@page import="java.util.List"%>
<%@page import="shop.ShopDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Brush+Script&family=Nanum+Pen+Script&family=Noto+Sans+KR:wght@100..900&family=Noto+Serif+KR&family=Stylish&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
<style type="text/css">
  .s_list {
  width: 100%;
  padding: 70px 100px;
  margin: 0 auto;
  
  }
  
  .s_title {
  padding-left: 23%;
  }
  
  .s_image {
  width: 200px;
  height: 200px;
  margin-top: 6%;
  }
  
    .shoptable {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between; /* 이미지 사이에 간격을 벌리기 위해 사용 */
  }
  
  .br_name {
  text-decoration: none; /* 밑줄 제거 */
  color: black; /* 기본 텍스트 컬러 */
  transition: color 0.3s; /* 컬러 변경 시 부드럽게 전환 */
  }

  .br_name:hover {
  color: green; /* 마우스를 올렸을 때 컬러 변경 */
  cursor: pointer; /* 마우스 커서 모양 변경 (옵션) */
  }

 
</style>

<script type="text/javascript">
$(function(){
    // 탭 클릭 시 체크박스 초기화
    $(".nav_").click(function(){
        $(".alldel1, .alldel2, .alldel3").prop("checked", false);
        $(".alldelcheck1, .alldelcheck2, .alldelcheck3").prop("checked", false);
    });

    // 전체 체크박스 클릭 시 해당 탭의 체크박스 모두 선택
    $(".alldelcheck1, .alldelcheck2, .alldelcheck3").click(function(){
        var tabNumber = $(this).attr("class").replace("alldelcheck", "").trim();
        $(".alldel" + tabNumber).prop("checked", $(this).is(":checked"));
    });

    // 삭제 버튼 클릭 시
    $("#btndel").click(function(){
        var totalChecked = 0;

        // 각 탭의 체크된 항목 수 확인
        for (var i = 1; i <= 3; i++) {
            totalChecked += $(".alldel" + i + ":checked").length;
        }

        if(totalChecked === 0) {
            alert("최소 1개 이상의 글을 선택해 주세요.");
        } else {
            var confirmMessage = totalChecked + "개의 글을 삭제하려면 [확인]을 눌러주세요";
            var a = confirm(confirmMessage);

            if (a) {
                var sNums = [];

                // 각 탭의 체크된 값(num) 얻기
                for (var j = 1; j <= 3; j++) {
                    $(".alldel" + j + ":checked").each(function(){
                        sNums.push($(this).val());
                    });
                }

                // 삭제할 s_nums 파라미터 생성
                var sNumsParam = sNums.join(",");
                console.log(sNumsParam);

                // 삭제파일로 전송
                location.href = "shop/shopAllDelete.jsp?s_nums=" + sNumsParam;
            }
        }
    });
});

</script>
 

</head>

<%
 //로그인상태확인
 String loginok=(String)session.getAttribute("loginok");
 String myid=(String)session.getAttribute("myid");
 
 ShopDao dao = new ShopDao();
 List<ShopDto> list = dao.allShop();
 
 %>
<body>
  <div id="s_list" class="s_list">
    <div class="s_title">
      <div class="main_title">
        <h3>쇼핑몰</h3>
        <p>아웃도어, 스포츠, 골프, 캐주얼 등 다양한 브랜드가 입점한 아울렛 쇼핑몰에서<br>
        편안한 휴식과 함께 즐거운 쇼핑도 즐기세요</p>
      </div>
    </div>
    
    
     <!-- 공지사항 레이아웃-->
  <div class="mt-3" style="width: 1260px; padding-left: 23%">
 
    <!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist">
      <li class="nav-item">
      <a class="nav-link active nav_" data-bs-toggle="tab" href="#tabs-hugeso1">서울만남(부산)휴게소</a>
    </li>
    
      <li class="nav-item">
        <a class="nav-link" data-bs-toggle="tab" href="#tabs-hugeso2">언양(서울)휴게소</a>
      </li> 
      
      <li class="nav-item">
        <a class="nav-link" data-bs-toggle="tab" href="#tabs-hugeso3">문산(순천)휴게소</a>
      </li>    
    </ul>   

    
    
    
     <!-- 각 휴게소 list불러오기 -->
       <div class="tab-content">
       <!-- 휴게소1 -->
         <div id="tabs-hugeso1" class="tab-pane active"><br>
          <table class="shoptable table">
           

               <% int count = 0; %>
               <% for (ShopDto dto : list) { %>
               
               <% if (dto.getS_category().equals("서울만남(부산)휴게소")) { 
                  
                  if( count == 0 ) {
                //관리자만 체크 보이게 
                if (loginok != null && myid.equals("admin")) { %>
                <input type="checkbox" class="alldelcheck2"> 전체선택
              <% } %>
               
                
               <%}  if (count % 4 == 0) { %>
                 <% if (count != 0) { %>
                  </tr> <!-- 이전 행을 닫아줍니다. -->
                <% } %>
                <tr> <!-- 새로운 행 시작 -->
              <% } %>
              <td >
              <% //관리자만 체크 보이게 
                if (loginok != null && myid.equals("admin")) { %>
                <input type="checkbox" value="<%=dto.getS_num()%>" class="alldel1">
                <% } %>
              <div class="br_total"> 
                <a href="<%= dto.getS_site() %>" target="_blank">
                  <img src="shopsave/<%= dto.getS_image() %>" alt="" class="s_image"><br>
                  <span class="br_name">공식 홈페이지</span>
                </a>
              </div>   
              </td>
              <% count++; %>
            <% } %>
          <% } %>
          </tr> <!-- 마지막 행을 닫아줍니다. -->
          <% if( count == 0 ) { %>
          <tr>
                <td colspan="2">등록된 게시물이 없습니다</td>
              </tr>
              <% }%>
          </table>
        </div> 
        
        
         <!-- 휴게소2 -->
         <div id="tabs-hugeso2" class="tab-pane fade"><br>
          <table class="shoptable table">
   
                
                
               <%  count = 0; %>
               <% for (ShopDto dto : list) { %>
               
               <% if (dto.getS_category().equals("언양(서울)휴게소")) { 
               
               if( count == 0 ) {
                //관리자만 체크 보이게 
                if (loginok != null && myid.equals("admin")) { %>
                <input type="checkbox" class="alldelcheck2"> 전체선택
                <% } %>
               
                
               <%} if (count % 4 == 0) { %>
                 <% if (count != 0) { %>
                  </tr> <!-- 이전 행을 닫아줍니다. -->
                <% } %>
                <tr> <!-- 새로운 행 시작 -->
              <% } %>
              <td >
               <% //관리자만 체크 보이게 
                if (loginok != null && myid.equals("admin")) { %>
                <input type="checkbox" value="<%=dto.getS_num()%>" class="alldel2">
                <% } %>
              <div class="br_total">  
                <a href="<%= dto.getS_site() %>" target="_blank">
                  <img src="shopsave/<%= dto.getS_image() %>" alt="" class="s_image"><br>
                  <span class="br_name">공식 홈페이지</span>
                </a>
              </div>  
              </td>
              <% count++; %>
            <% } %>
          <% } %>
          </tr> <!-- 마지막 행을 닫아줍니다. -->
          <% if( count == 0 ) { %>
          <tr>
                <td colspan="2">등록된 게시물이 없습니다</td>
              </tr>
              <% }%>
          </table>
        </div> 
        
        
        <div id="tabs-hugeso3" class="tab-pane fade"><br>
          <table class="shoptable table">
                
          
               <%  count = 0; %>
               <% for (ShopDto dto : list) { %>
               
               <% if (dto.getS_category().equals("문산(순천)휴게소")) { 
               if( count == 0 ) {
            	   //관리자만 체크 보이게 
                   if (loginok != null && myid.equals("admin")) { %>
                   <input type="checkbox" class="alldelcheck3"> 전체선택
                   <% }%>
              
                
               <%} if (count % 4 == 0) { %>
                 <% if (count != 0) { %>
                  </tr> <!-- 이전 행을 닫아줍니다. -->
                <% } %>
                <tr> <!-- 새로운 행 시작 -->
              <% } %>
              <td >
              <% //관리자만 체크 보이게 
                if (loginok != null && myid.equals("admin")) { %>
                <input type="checkbox" value="<%=dto.getS_num()%>" class="alldel3">
                <% }%>
                
               <div class="br_total"> 
                <a href="<%= dto.getS_site() %>" target="_blank">
                  <img src="shopsave/<%= dto.getS_image() %>" alt="" class="s_image"><br>
                  <span class="br_name">공식 홈페이지</span>
                </a>
                </div>
              </td>
              <% count++; %>
            <% } %>
          <% } %>
          </tr> <!-- 마지막 행을 닫아줍니다. -->
          
          <% if( count == 0 ) { %>
          <tr>
                <td colspan="2">등록된 게시물이 없습니다</td>
              </tr>
              <% }%>
          
        
          </table>
        </div> 
        
        
        
      </div>
    </div>

  </div>

  
  <!-- 버튼 위치 -->
  <div style="padding: 5px 490px; ">
  <% if (loginok != null && myid.equals("admin")) { %>
    <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;" onclick="location.href='index.jsp?main=shop/shopForm.jsp'">추가</button>
    <button type="button" class="btn btn-success col" id=btndel style="width: 80px; height: 40px;" onclick="location.href='#'">삭제</button>
  <% } %>
  </div>

</body>
</html>