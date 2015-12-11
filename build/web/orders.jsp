<%-- 
    Document   : orders
    Created on : Dec 1, 2015, 7:37:27 PM
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
        <h1>Orders</h1>
        <br>        
        <form action="OnlineShoppingServlet">
            <input type="Submit" value="Home" name="action">
            <% if(!(Boolean)session.getAttribute("adminUser")){ %>
            <input type="Submit" value="View Cart" name="action">
            <% }%>
        </form>
        <br>
        <br>        
        
        <table border="0" cellpadding="0" width="100%">
            <tr>
                <td>Order ID</td>
                <td>Email</td>
                <td>Price</td>
                <td>Status</td>                
            </tr>
                        
                <%
                ResultSet res = (ResultSet)session.getAttribute("ordersList");                
                while(res.next()){
                %>
                
                <tr>
                    <td><%=res.getInt("orderID") %></td>
                    <td><%=res.getString("email")%></td>
                    <td><%=res.getInt("orderPrice")%></td>
                    <%if(res.getBoolean("confirmed")){  %>
                    <td><%="Delivered"%></td>
                    <%}else{ %>
                    <td><%="Received"%></td>
                    <% } %>
                    <td> 
                    <form action="OnlineShoppingServlet">
                        <input type="hidden" value="<%=res.getInt("orderID") %>" name="orderID">
                        <input type="submit" value="Inspect Order" name="action">
                        <%if((Boolean)session.getAttribute("adminUser")){ %>     
                            <input type="submit" value="Confirm Order" name="action">                        
                        <% } %>
                    </form>
                    </td> 
                </tr>
                
                <% } %>
            
        </table>        
    </body>
</html>
