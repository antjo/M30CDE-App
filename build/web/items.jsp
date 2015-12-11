
<%-- 
    Document   : products
    Created on : Oct 25, 2015, 3:23:21 PM
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
        <h1>items</h1>
        <br>       
        <form action="OnlineShoppingServlet">
            <input type="Submit" value="Home" name="action">
            <% if(!(Boolean)session.getAttribute("adminUser")){ %>
            <input type="Submit" value="View Cart" name="action">
            <% }%>
        </form>
        <!--from course slides, simple list of users  -->
        <%if((Boolean)session.getAttribute("adminUser")){ 
          
                String[] errors = (String[])session.getAttribute("addItemErrors");
                session.removeAttribute("addItemErrors");
                if(errors == null) errors = new String[]{"","",""};                
        %>
        <font color="red">
        <br>
        <%=errors[0]%>
        <br>
        <%=errors[1]%>
        <br>
        <%=errors[2]%>
        <br>
        </font>
        <form action="OnlineShoppingServlet">        
        <% if((Boolean)session.getAttribute("adminUser")){ %>
            <table cellpadding="5">
                <tr>
                <td>Item ID<input type="text" name="itemID" size="3" required></td>
                <% } %>
                <td>Item Name<input type="text" name="itemName" size="15" required></td>
                <% if((Boolean)session.getAttribute("adminUser")){ %>
                <td>Item Qty<input type="text" name="itemQuantity" size="2" required></td>
                <% } %>
                <td>Item Price<input type="text" name="itemPrice" size="2" required></td>
                <td>Item Description<textarea name="itemDescription" rows="1" cols="15" required> </textarea></td>
                <td><input type="submit" name="action" value="Add Item"></td>
                </tr>            
            </table> 
        <% } %>
        </form>
        <br>
        <form action="OnlineShoppingServlet">
        <table cellpadding="4">
            <tr>
                <td>Item ID<input type="text" name="itemID" size="3"></td>
                <td>Item Name<input type="text" name="itemName" size="15"></td>
                <td>Lower Item Price<input type="text" name="lowerItemPrice" size="2"></td>
                <td>Upper Item Price<input type="text" name="upperItemPrice" size="2"></td>
                <td><input type="submit" name="action" value="Search Item"></td>
            </tr>
        </table>    
        </form>
        <br>
        <table border="0" cellpadding="2" width="100%"> 
            <tr>                
                <td>Item ID</td>                
                <td>Item name</td>
                <% if((Boolean)session.getAttribute("adminUser")){ %>
                <td>Quantity</td>
                <% } %>
                <td>Price</td>
                <td>Description</td> 
            </tr>       
        <%            
            ResultSet res = (ResultSet)session.getAttribute("itemList");
            session.removeAttribute("itemList");
            while(res.next()){
        %>
                <tr>
                <font size="4">
                <td><%=res.getInt("itemID") %></td>
                <td><%=res.getString("itemName")  %></td>
                <% if((Boolean)session.getAttribute("adminUser")){ %>
                <td><%=res.getInt("itemQuantity") %></td>
                <% } %>
                <td><%=res.getInt("price") %></td>
                <td><%=res.getString("description") %></td>     
                <%if(!(Boolean)session.getAttribute("adminUser")){ %>                
                <form action="OnlineShoppingServlet">
                <td>
                    <input type="hidden" name="itemID" value="<%=res.getInt("itemID") %>" />  
                    <input type="hidden" name="itemAmount" value="1">
                    <input type="submit" value="Add To Cart" name="action"/>
                </td>
                </form>
                <% }else{ %>                         
                <form action="OnlineShoppingServlet"> 
                    <td>
                    <input type="text" name="itemAmount" value="" size="3" />
                    </td>                    
                    <input type="hidden" name="itemID" value="<%=res.getInt("itemID") %>" />
                    <td>
                        <table>
                            <tr>   
                                <td>Add</td>                    
                                <td><input type="radio" name="updateChoice" value="Add" checked="checked"/></td>
                            </tr>
                            <tr>
                                <td>Remove</td>
                                <td><input type="radio" name="updateChoice" value="Remove" /></td>
                            </tr>
                        </table>
                    </td>
                    <td>
                    <input type="submit" value="Update Quantity" name="action"/>
                    </td>
                    <td>
                    <input type="submit" value="Remove Item" name="action"/>
                    </td>
                </form>
                <%}%>   
                </font>
                </tr>                
                <br>            
        <% }  %>        
        </table>       
    </body>
</html>
