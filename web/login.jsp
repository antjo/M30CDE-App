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
        <h1>login</h1>
        <br>
        <form action="OnlineShoppingServlet">
            <input type="Submit" value="Home" name="action">
            <input type="Submit" value="View Cart" name="action">
        </form>
        <br>
        <br>
        <form name="LogInForm" action="OnlineShoppingServlet">
        <table>            
            <tr>
                <td>Email:</td> 
                <td><input type="text" name="email" /></td>
            </tr>
            <tr>
                <td>Password:</td>
                <td><input type="password" name="password" /></td>
            </tr>
            <tr>
                <td><input type="submit" value="Login" name="action" /></td>
                <td>Or <a href="register.jsp"> register here</a></td>
            </tr>            
        </table>
        </form>
    </body>
</html>
