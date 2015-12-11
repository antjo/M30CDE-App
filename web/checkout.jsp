<%-- 
    Document   : checkout
    Created on : Dec 1, 2015, 2:45:52 AM
    Author     : anthon
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Online Smartphone Store</title>
    </head>
    <body>
        <h1>Checkout</h1>
        <br>           
        <form action="OnlineShoppingServlet">
            <input type="Submit" value="Home" name="action">
            <% if(!(Boolean)session.getAttribute("adminUser")){ %>
            <input type="Submit" value="View Cart" name="action">
            <% }%>
        </form>      
        <br>        
        <br>
        Amount to pay: 
        <%=(String)session.getAttribute("totalPrice") %>
        <br>
        <br>
        <%
            String error = (String)session.getAttribute("cardError");
            session.removeAttribute("cardError");
            if(error == null) error = "";
        %>
        <font color="red">
        <%=error  %>
        </font>
        <br>
        Card Number:
        <form action="OnlineShoppingServlet">
            <input type="text" name="cardNumber" size="20" required> 
            <input type="submit" value="Pay" name="action">
        </form>
    </body>
</html>
