<%-- 
    Document   : editprofile
    Created on : Nov 29, 2015, 4:04:52 PM
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
        <h1>Edit profile</h1>
        <br>
        <form action="OnlineShoppingServlet">
            <input type="submit" value="Home" name="action">
        </form>
        <br>
        
        <%  
                String[] errors = (String[])session.getAttribute("updateErrors");
                session.removeAttribute("updateErrors");
                if(errors == null) errors = new String[]{"","","","","",""};                
        %>
        <form action="OnlineShoppingServlet">
        <table>
            <tr>
                <td>Old password: </td>
                <td><input type="password" name="oldpassword"></td>
                <td>
                    <font size="3" color="red">
                    <%=errors[0]%>
                    </font>
                </td>
            </tr>
            <tr>
                <td>New password: </td>
                <td><input type="password" name="newpassword"></td>
                <td>
                <font size="3" color="red">
                <%=errors[1]%>
                </font>
                </td>
            </tr>
            <tr>
                <td>Confirm password: </td>
                <td><input type="password" name="confirmpassword"></td>
                <td>
                <font size="3" color="red">
                <%=errors[2]%>
                </font>
                </td>
            </tr>
            <tr>
                <td>New name: </td>
                <td><input type="text" name="fullname"></td>
                <td>
                <font size="3" color="red">
                <%=errors[3]%>
                </font>
                </td>
            </tr>
            <tr>
                <td>New address: </td>
                <td><input type="text" name="address"></td>
                <td>
                <font size="3" color="red">
                <%=errors[4]%>
                </font>
                </td>
            </tr>
            <tr>
                <td>New phone number: </td>
                <td><input type="text" name="phonenumber"></td>
                <td>
                <font size="3" color="red">
                <%=errors[5]%>
                </font>
                </td>
            </tr>
            <tr>
                <td><input type="submit" value="Update Profile" name="action"></td>
            </tr>
            
        </table>    
        </form>
        
    </body>
</html>
