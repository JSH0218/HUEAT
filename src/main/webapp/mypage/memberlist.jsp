<%@page import="java.text.SimpleDateFormat"%>
<%@page import="meminfo.model.MemInfoDto"%>
<%@page import="java.util.List"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Grandiflora+One&family=Gugi&family=Hahmlet:wght@100..900&family=Hi+Melody&family=Sunflower:wght@300&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
<style type="text/css">

   button.search{
      background-color: #618E6E;
      color: white;
      border:0px;
      height: 30px;
      width: 100px;
   }
   
     button.deletemem{
       background-color:#fb4357;
       color: #fff;
       border:none;
       border-radius:10px;
       box-shadow: 0px 0px 2px 2px #fb4357;
       width: 45px;
      height: 30px;
      font-size: 13px;
   }

   
      div.img-container{

    width: 100%; /* 이미지를 감싸는 부모 요소의 가로폭 */
    height: 250px; /* 원하는 높이로 설정 */
    overflow: hidden; /* 내용이 넘칠 경우를 대비하여 오버플로우를 숨김으로 설정 */
     border: 0px solid black;
     background-position: top;
     text-align: center;
}
   
   div.img-container img {
      top: 0;
    width: 100%; /* 이미지가 부모 요소의 가로폭을 다 차지하도록 설정 */
    height: auto; /* 세로 비율을 유지하기 위해 자동으로 조정 */
    object-fit: cover; /* 이미지를 부모 요소에 맞게 잘라내어 배치 */
    
}
   div.span-container{
      width: 100%; /* 이미지를 감싸는 부모 요소의 가로폭 */
    height: 250px; /* 원하는 높이로 설정 */
    overflow: hidden; /* 내용이 넘칠 경우를 대비하여 오버플로우를 숨김으로 설정 */
     background-position: top;
      margin-top:-14%;
     text-align: center;
     display: flex;
    justify-content: center; /* 수평 가운데 정렬 */
    align-items: center; /* 수직 가운데 정렬 */
   }

   div.span-container span{
      z-index: 9999;
      color: white;
      font-size: 3em;
      position: relative;

}
</style>
<script type="text/javascript">
$(function(){
   
   $("#result").hide();
   
   $("button.search").click(function(){
      var m_name=$("#m_name").val();
      //alert(m_name);
      
      $.ajax({
         type:"get",
         url:"mypage/membersearch.jsp",
         dataType:"json",
         data:{"m_name":m_name},
         success:function(data){
            //alert("여기까지는 성공");
            //alert(data.length);
            if(data.length){
               var s="<table class='table table-bordered-light'>";
               s+="<tr align='center'><th style='background-color: #DFE8E2;'>회원번호</th>";
               s+="<th style='background-color: #DFE8E2;'>이름</th>";
               s+="<th style='background-color: #DFE8E2;'>아이디</th>";
               s+="<th style='background-color: #DFE8E2;'>닉네임</th>";
               s+="<th style='background-color: #DFE8E2;'>연락처</th>";
               s+="<th style='background-color: #DFE8E2;'>이메일</th>";
               s+="<th style='background-color: #DFE8E2;'>생일</th>";
               s+="<th style='background-color: #DFE8E2;'>가입일</th>";
               s+="<th style='background-color: #DFE8E2;'>비고</th>";
               s+="</tr>";
               
            $.each(data,function(i,elt){
               s+="<tr align='center'><td>"+elt.m_num+"</td>";
               s+="<td>"+elt.m_name+"</td>";
               s+="<td >"+elt.m_id+"</td>";
               s+="<td>"+elt.m_nick+"</td>";
               s+="<td>"+elt.m_hp1+"-"+elt.m_hp2+"</td>";
               s+="<td>"+(elt.m_email==null?"":elt.m_email)+"</td>";
               s+="<td>"+elt.m_birth+"</td>";
               s+="<td>"+elt.m_gaipday+"</td>";
               s+="<td><button class='deletemem' type='button' onclick='delemem("+elt.m_num+")'>강퇴</button></td>"
               s+="</tr><br><br>";
               })
               s+="</table>";
               $("#list").hide();
            }else{
               $("#result").hide();
               alert("검색결과가 없습니다.");
            }
            $("#result").show();
               $("#result").html(s);
         }
         
      })
   });
   
   
})

function delemem(m_num){
   if(confirm("정말 강퇴하시겠습니까?")){
      location.href="mypage/memberdelete.jsp?m_num="+m_num;
   }
}
</script>
</head>
<body>
<%
MemInfoDao dao=new MemInfoDao();
List<MemInfoDto> list=dao.getMemDatas();
SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
%>

<div class="img-container" style="border: 0px solid green; background-image: url('image/mainbanner/memberbanner01.jpg'); background-size: cover; background-position: center center;">   
</div>
<div class="span-container" style="border:0px solid purple;">
   <span>회원 관리<br><span style="display: block;font-size: 20px;">총<%=list.size() %>명의 회원이 있습니다.</span></span>
</div>

<div style="margin: 0 auto; width: 80%;height:100%; padding: 20px 20px 20px 20px; margin-top: 50px;">

   <div style="margin: 0 auto;" align="center">
      <input name="m_name" id="m_name" style="width: 200px;" placeholder="검색할 이름을 입력하세요">
      <button type="button" class="search">검색</button>   
   </div>
   <div id="result" style="margin: 0 auto; width: 100%;height:100%; padding: 20px 20px 20px 20px;">
   </div>
   <br><br>
   <div id="list" style="margin: 0 auto; width: 100%; height:100%;padding: 20px 20px 20px 20px;">
   <table class="table table-bordered-light">
      <tr align="center">
         <th style="background-color: #DFE8E2;">회원번호</th>
         <th style="background-color: #DFE8E2;">이름</th>
         <th style="background-color: #DFE8E2;">아이디</th>
         <th style="background-color: #DFE8E2;">닉네임</th>
         <th style="background-color: #DFE8E2;">연락처</th>
         <th style="background-color: #DFE8E2;">이메일</th>
         <th style="background-color: #DFE8E2;">생일</th>
         <th style="background-color: #DFE8E2;">가입일</th>
         <th style="background-color: #DFE8E2;">비고</th>
      </tr>
      <%
      for(MemInfoDto dto:list){%>
      <tr align='center'>
         <td><%=dto.getM_num() %></td>
         <td><%=dto.getM_name() %></td>
         <td><%=dto.getM_id() %></td>
         <td><%=dto.getM_nick() %></td>
         <td><%=dto.getM_hp1() %>-<%=dto.getM_hp2() %></td>
         <td><%=dto.getM_email()==null?"":dto.getM_email() %></td>
         <td><%=dto.getM_birth() %></td>
         <td><%=sdf.format(dto.getM_gaipday())%></td>
         <td>
            <button type="button" class="deletemem" onclick="delemem('<%=dto.getM_num()%>')">강퇴</button>
         </td>
      </tr>
      <%}
      %>
   </table>
   </div>
</div>
</body>
</html>