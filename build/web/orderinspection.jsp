<%-- 
    Document   : orderinspection
    Created on : Dec 1, 2015, 11:37:32 PM
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
        <h1>Order Inspection</h1>
        <br>
        <form action="OnlineShoppingServlet">
            <input type="Submit" value="Home" name="action">            
        </form>
        <br>
        <% String orderID = session.getAttribute("orderID").toString(); %>
        <h3>Order ID: <%=orderID %> </h3>
        <br>        
        <table border="0" cellpadding="0" width="100%"> 
            <tr><td>Item ID</td>
                <td>Item Name</td>
                <td>Quantity</td>
                <td>Price</td>
                <td>Description</td>
            </tr>
            <%
                ResultSet res = (ResultSet)session.getAttribute("orderItemList");
                session.removeAttribute("orderItemList");
                
                while(res.next()){
            %>    
            <tr>
                <td><%=res.getInt("itemID") %></td>
                <td><%=res.getString("itemName") %></td>
                <td><%=res.getInt("itemQuantity") %></td>
                <td><%=res.getInt("price") %></td>
                <td><%=res.getString("description") %></td>                
            </tr>            
            <% } %>
            <tr></tr>
            <tr></tr>
            <tr></tr>
            <tr></tr>
            <tr>
                <td>Total Price: <%=(String)session.getAttribute("orderPrice") %></td>
                <%if((Boolean)session.getAttribute("adminUser")){ %>
                <td>
                    <form action="OnlineShoppingServlet">
                        <input type="hidden" value="<%=session.getAttribute("orderID").toString() %>" name="orderID">
                        <input type="submit" value="Confirm Order" name="action">
                    </form>
                </td>
                <% } %>
            </tr>            
            <% session.removeAttribute("orderPrice"); %>
        </table>
        
    </body>
</html>
