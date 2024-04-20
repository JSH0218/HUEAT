<%@page import="java.util.TimeZone"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="event.model.EventDto"%>
<%@page import="event.model.EventDao"%>
<%@page import="notice.model.NoticeDto"%>
<%@page import="java.util.List"%>
<%@page import="notice.model.NoticeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Brush+Script&family=Nanum+Pen+Script&family=Noto+Sans+KR:wght@100..900&family=Noto+Serif+KR&family=Stylish&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
<style type="text/css">
  /*공지사항 */
    .noticeDetail {
    text-decoration: none;
    color: black;

    .n_notice {
    display: flex; /* n_notice 클래스의 자식 요소들을 플렉스 박스로 정렬합니다. */
    justify-content: space-between; /* 요소들 사이의 간격을 최대한으로 넓힙니다. */
    align-items: center; /* 자식 요소들을 수직으로 가운데 정렬합니다. */
    }

    .n_subject {
    flex: 1; /* 제목이 최대한 넓게 확장되도록 설정합니다. */
    padding: 2px;
    max-width: 200px; /* 제목의 최대 너비를 200px로 설정합니다. */
    white-space: nowrap; /* 제목이 한 줄로 유지되도록 설정합니다. */
    overflow: hidden; /* 너무 긴 제목은 자동으로 잘리도록 설정합니다. */
    text-overflow: ellipsis;
     }

   .n_writeday {
    margin-left: 10px; /* 제목과 날짜 사이의 왼쪽 여백을 추가합니다. */
    }
    
    /*이벤트 */
    .eventDetail {
    text-decoration: none;
    color: black;

    .e_notice {
    display: flex; /* n_notice 클래스의 자식 요소들을 플렉스 박스로 정렬합니다. */
    justify-content: space-between; /* 요소들 사이의 간격을 최대한으로 넓힙니다. */
    align-items: center; /* 자식 요소들을 수직으로 가운데 정렬합니다. */
    }

    .e_subject {
    flex: 1; /* 제목이 최대한 넓게 확장되도록 설정합니다. */
    padding: 2px;
    max-width: 200px; /* 제목의 최대 너비를 200px로 설정합니다. */
    white-space: nowrap; /* 제목이 한 줄로 유지되도록 설정합니다. */
    overflow: hidden; /* 너무 긴 제목은 자동으로 잘리도록 설정합니다. */
    text-overflow: ellipsis;
     }

   .e_writeday {
    margin-left: 10px; /* 제목과 날짜 사이의 왼쪽 여백을 추가합니다. */
    }
</style>

<script type="text/javascript">
  
   
    $(function () {
       
       //클릭시 공지사항 디테일 페이지로 이동
       $("a.noticeDetail").click(function () {
         var n_num = $(this).attr("n_num");
         //alert(n_num);
         
        location.href = 'index.jsp?main=noticeboard/noticeDetail.jsp?n_num='+n_num;
      });
       
      
      //클릭시 이벤트 디테일 페이지로 이동
      $("a.eventDetail").click(function () {
         var e_num = $(this).attr("e_num");
         //alert(e_num);
         
         location.href = 'index.jsp?main=eventboard/eventDetail.jsp?e_num='+e_num;
      });

    });
</script>

</head>
  <%
   //프로젝트 경로
   String root = request.getContextPath();  
   
  
   //notice
   NoticeDao ndao = new NoticeDao();
   List<NoticeDto> list = ndao.getAllNotice();
   
   //event
   EventDao edao = new EventDao();
   List<EventDto> elist = edao.getAllEvent();
   
   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
   %>
<body>
  
    <!-- 공지사항 레이아웃-->
  <div class="mt-3"  style="width: 673px; margin-left: 10.7%; padding: 1%;
    background-color: #F0F0F0; height: 250px;">
 
    <!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist">
      <li class="nav-item">
        <a class="nav-link active" data-bs-toggle="tab" href="#tabs-notice">공지사항</a>
      </li>
    
      <li class="nav-item">
        <a class="nav-link" data-bs-toggle="tab" href="#tabs-event">이벤트</a>
      </li>    
    </ul>
    
    
      <!-- 공지사항 list불러오기 -->
    <div class="tab-content">
      <div id="tabs-notice" class=" tab-pane active"><br>
        <table class="noticetable table">
          <tr>
            <% 
              
               
              List<NoticeDto> recentNotices = ndao.getAllNotice().subList(0, Math.min(list.size(), 5));
              int n = recentNotices.size();
              if( n != 0 ) {
              for(NoticeDto dto:recentNotices) {%>
               
                
                  <a n_num="<%=dto.getN_num() %>" style="cursor: pointer;" class="noticeDetail">
                    <div class="n_notice">
                      <span class="n_subject">- <%=dto.getN_subject() %></span> 
                      <span class="n_writeday">
                        <%=sdf.format(dto.getN_writeday()) %>
                      </span> 
                    </div>   
                  </a>
              <%} } else {
              %>

                    <div class="n_notice" style="height: 200px">
                      <div class="n_no" >등록된 게시물이 없습니다.</div>
                      </div>  
                
              <% }%>
          </tr>
        </table>
      </div> 
      
      
         <!-- 이벤트 list불러오기 -->
   
      <div id="tabs-event" class="tab-pane fade"><br>
        <table class="eventtable table">
          <tr>
            <% 

              List<EventDto> recentEvent = edao.getAllEvent().subList(0, Math.min(elist.size(), 3));
              int e = recentEvent.size();
              if( e != 0 ) {
              for(EventDto dto:recentEvent) {%>
               
              
                  <a e_num="<%=dto.getE_num() %>" style="cursor: pointer;" class="eventDetail">
                    <div class="e_event" style="height: 200px">
                      <span class="e_subject">- <%=dto.getE_subject() %></span>
                      <span class="e_writeday">
                        <%=sdf.format(dto.getE_writeday()) %>
                      </span> 
                    </div>   
                  </a>
                   
              <%} } else {
              %>

                   <div class="e_event" style="height: 200px">
                      <div class="e_no" >등록된 게시물이 없습니다.</div>
                      </div>  

              <% }%>
          </tr>
        </table>
      </div> 
    </div>
  </div>  

</body>
</html>