<%-- 
    Document   : viewcustomers
    Created on : Nov 6, 2015, 7:55:20 AM
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
        <h1>view customers</h1>
        <br>
        <br>
        <form action="OnlineShoppingServlet">
            <input type="Submit" value="Home" name="action">           
        </form>
        <br>       
        <br>
        <form action="OnlineShoppingServlet">
        <table cellpadding="4">
            <tr>
                <td>Email <input type="text" name="email" size="20"></td>
                <td>Name<input type="text" name="fullname" size="20"></td>
                <td>Address <input type="text" name="address" size="25"></td>
                <td>Phone Number<input type="text" name="phonenumber" size="20"></td>
                <td><input type="submit" name="action" value="Search Customer"></td>
            </tr>
        </table>    
        </form>
        <br>
        <!--from course slides, simple list of users  -->
        <table border="0" cellpadding="0" width="100%"> 
            <tr>
            <font size="7">
                <td>email</td>
                <td>full name</td>
                <td>adress</td>
                <td>phone number</td>
                <td>admin</td>
                <td><input type="hidden"></td>
            </font>
            </tr>           
        <%
            ResultSet res = (ResultSet)session.getAttribute("customerList");
            session.removeAttribute("customerList");            
            while(res.next()){
        %>
                <tr>
                <font size="4">
                <td><%=res.getString("email") %></td>
                <td><%=res.getString("fullname")  %></td>
                <td><%=res.getString("adress") %></td>
                <td><%=res.getString("phoneNumber") %></td>
                <td>
                <%
                    String str;
                    if(res.getBoolean("admin"))str="yes";
                    else str = "no";
                %>
                <%=str%>
                </td>
                <form action="OnlineShoppingServlet">
                <input type="hidden" name="userID" value="<%=res.getString("email") %>" /> 
                <%--<td><input type="submit" value="Delete User" name="action"/></td> --%>
                <td><input type="submit" value="Make Admin" name="action"></td>
                <%if(!res.getBoolean("admin")){ %>                    
                    <td><input type="submit" value="View Orders" name="action"></td>
                <% } %>
                </form>
                </font>
                </tr>
            <br>
        <%  }   %>
        </table>
    </body>
</html>
