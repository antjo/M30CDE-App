<%-- 
    Document   : viewprofile
    Created on : Nov 29, 2015, 9:32:44 PM
    Author     : anthon
--%>

<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Online Smartphone Store</title>
    </head>
    <body>
        <h1>Profile Info</h1>
        <br>
        <br>
        <form action="OnlineShoppingServlet">
            <input type="submit" value="Home" name="action"/>
            <input type="submit" value="Edit Profile" name="action">
            <%if(!(Boolean)session.getAttribute("adminUser")){ %>
                <input type="hidden" value="<%=(String)session.getAttribute("loggedInAs")%>" name="userID" >
                <input type="submit" value="View Orders" name="action">
            <% } %>
        </form>
        <br>
        <br>
        <br>
        <%
            ResultSet res = (ResultSet)session.getAttribute("userInfo");
            res.next();
            session.removeAttribute("userInfo");
        %>
        Email: 
        <%=res.getString("email")%>
        <br>
        Name: 
        <%=res.getString("fullname")%>
        <br>
        Address: 
        <%=res.getString("adress")%>
        <br>
        Phone number: 
        <%=res.getString("phoneNumber")%>
        <br>
        <br>
        <% res = null;  %>
        
    </body>
</html>
