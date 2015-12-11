<%-- 
    Document   : register
    Created on : Oct 25, 2015, 5:23:40 PM
    Author     : anthon
--%>

<%@page import="java.awt.Choice"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Online Smartphone Store</title>
    </head>
    <body>       
        <h1>Register</h1>
         <form action="OnlineShoppingServlet">
            <input type="Submit" value="Home" name="action"> 
            <input type="submit" value="View Cart" name="action" >
        </form>
        <br>
        <br>
        <div>
            <%  
                String[] errors = (String[])session.getAttribute("regErrors");
                session.removeAttribute("regErrors");
                if(errors == null) errors = new String[]{"","","","","",""};                
            %>
            <form name="RegisterValidationForm" action="OnlineShoppingServlet">
                <table>
                    <tr>
                        <td>Full name: </td> 
                        <td><input type="text" name="Name" /></td>
                        <td><font color="red"><%=errors[0] %></font></td>
                    </tr>
                    <tr>
                        <td>Email: </td>
                        <td><input type="text" name="Email"/></td>
                        <td><font color="red"><%=errors[1] %></font></td>
                    </tr>
                    <tr>
                        <td>Phone number: </td>
                        <td><input type="text" name="Phone"/></td>
                        <td><font color="red"><%=errors[2] %></font></td>
                    </tr>
                    <tr>
                        <td>Adress:</td> 
                        <td><input type="text" name="Adress" /></td>
                        <td><font color="red"><%=errors[3] %></font></td>
                    </tr>
                    <tr>
                        <td>Password:</td> 
                        <td><input type="password" name="Password" /></td>
                        <td><font color="red"><%=errors[4] %></font></td>
                    </tr>
                    <tr>
                        <td>Confirm Password: </td>
                        <td><input type="password" name="ConfirmPassword" /></td>
                        <td><font color="red"><%=errors[5] %></font></td>
                    </tr>
                </table>
            </br>
            
            <% errors = null; %>
            <input type="submit" value="Register" name="action" />
            
            </form>
        </div>
        
        
        
        
    </body>
</html>
