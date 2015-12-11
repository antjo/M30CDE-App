<%-- 
    Document   : Log in
    Created on : Oct 25, 2015, 3:36:20 PM
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
        <h1>log in</h1>
        <br>
        <form action="OnlineShoppingServlet">
            <input type="Submit" value="Home" name="action">
            <input type="Submit" value="View Cart" name="action">
        </form>
        <br>
        <br>
        <form name="LogInForm" action="OnlineShoppingServlet">
            Email: 
            <input type="text" name="email" />
            </br>
            Password:
            <input type="password" name="password" />
            </br>
            <input type="submit" value="Login" name="action" />
            Or <a href="register.jsp"> register here</a>
        </form>
        
       
    </body>
</html>
