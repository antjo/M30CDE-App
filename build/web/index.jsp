<%-- 
    Document   : index
    Created on : Oct 25, 2015, 11:21:05 PM
    Author     : anthon
--%>

<%@page import="java.util.*" %>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.lang.Class.*" %>
<%@page import="library.CartItem" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Online Smartphone Store</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <h1>Online Smartphone Store</h1>
        <div>
             <%
                //Initiate a few of the important session attributes
                boolean sessionInitiated = session.getAttributeNames().hasMoreElements();
                if(!sessionInitiated){                    
                    session.setAttribute("adminUser", false);                    
                    session.setAttribute("loggedInAs", "");
                    session.setAttribute("cart", new ArrayList<CartItem>());
                    session.setAttribute("totalPrice", "0");
                    System.out.println("SESSION ATTRIBUTES INITIATED");
                }
            %>
                
            <%if(!((String)session.getAttribute("loggedInAs")).equals("")){  %>    
                <form action="OnlineShoppingServlet">
                Logged in as: 
                <%=session.getAttribute("loggedInAs")%>
                <br>
                <input type="submit" value="Log Out" name="action"/>
                <br>                
                <input type="submit" value="View Profile" name="action">
                <br>               
                <br>
                </form>
            <% }else { %>
                <form action="login.jsp">
                    <input type="submit" value="Login" name="LoginButton" />               
                </form>
            <br/>
            
            <% } %>
            
            <% if(!(Boolean)session.getAttribute("adminUser")){ %>
            
            <br/>                    
            <form action="OnlineShoppingServlet">
                <input type="submit" value="View Cart" name="action" />   
            </form>
            <br/>
            <br>            
            <% }else{ %>
            <br>    
            <form action="OnlineShoppingServlet">
                <input type="submit" value="Customers" name="action" />
                <br>
                <br>
                <input type="hidden" value="" name="userID" >
                <input type="submit" value="View Orders" name="action">
            </form>
           
            <br>
            <% } %>
            <form action="OnlineShoppingServlet">
                <input type="submit" value="Items" name="action" />
            </form>   
            <br>    
            <br>               
        </div>        
    </body>
</html>