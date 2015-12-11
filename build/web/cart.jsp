<%-- 
    Document   : cart
    Created on : Oct 25, 2015, 3:33:04 PM
    Author     : anthon
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="library.CartItem" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Online Smartphone Store</title>
    </head>
    <body>
        
        <h1>Cart</h1>
        <br>
        <form action="OnlineShoppingServlet">
            <input type="Submit" value="Home" name="action">
            <input type="Submit" value="Items" name="action">
        </form>
        <br>
        
        <table border="0" cellpadding="0" width="100%">    
            <tr>
            <% ArrayList<CartItem> arr = (ArrayList<CartItem>)session.getAttribute("cart");  %>
            <td>Item Name</td>
            <td>Price</td>       
            <td>Description</td>    
            <td>Quantity</td>
            </tr>
    
        <c:forEach items="<%=arr%>" var="obj">
            <tr>
            <td><c:out value="${obj.getItemName()}"/> </td>            
            <td><c:out value="${obj.getItemPrice()}"/> </td>
            <td><c:out value="${obj.getItemDescription()}"/> </td>            
            <td><input type="text" size="3" value="<c:out value="${obj.getItemQuantity()}"/>" readonly="true"> </td>
            <form action="OnlineShoppingServlet">
                <input type="Hidden" name="itemID" value="${obj.getItemID()}" >            
                <td><input type="Submit" name="action" value="Remove From Cart"></td>
            </form>
            </tr>
        </c:forEach>   
            
        </table> 
        <br>
        <br>
                
        <form action="OnlineShoppingServlet">
        Total Price: 
        <%=(String)session.getAttribute("totalPrice") %>
        <input type="submit" value="Checkout" name="action">
        </form>
    </body>
</html>
