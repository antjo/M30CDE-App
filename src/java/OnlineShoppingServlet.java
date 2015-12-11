import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import library.CartItem;
//database imports
import java.sql.Statement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;


@WebServlet(urlPatterns = {"/OnlineShoppingServlet"})
public class OnlineShoppingServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    //database variables
    private String host;                
    private String databaseUsername;
    private String pass;              
    private Connection conn;       
    
    
    private HttpSession session;
        
    //might not be needed after all...
    //private boolean adminUser;
    //private boolean loginSuccessful;

    public OnlineShoppingServlet() throws SQLException, InstantiationException, IllegalAccessException {
        
        
        //from http://www.homeandlearn.co.uk/java/connecting_to_a_database_table.html
        //initiate parts of the database connection;
        this.host = "jdbc:mysql://localhost:3306/OnlineShopDB";
        this.databaseUsername = "root";
        this.pass = "password";
        
        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            this.conn = DriverManager.getConnection(this.host, this.databaseUsername, this.pass); 
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(OnlineShoppingServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
   
    
    
    
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {              

            //if the global session variable is null
            if(this.session == null) this.session = request.getSession();
            
            //the action, or button, that has been activated
            //will activate a specific case below depending on the action
            String action = request.getParameter("action");
            
            //if the servlet redirected to itself during the previous redirect
            //will use the attribute action instead of the parameter action which will have the wrong action value
            String newAction = (String)request.getAttribute("newAction");
            if(newAction != null && !newAction.equals("")){
                action = newAction;
                newAction = "";
            }
            
            
            //url of next page.
            String url = "";
            switch(action){
                case "Home":
                    url = "/index.jsp";
                    break;
                case "View Cart":
                    url = "/cart.jsp";
                    break;
                case "Items":                    
                    this.session.setAttribute("itemList", getItems(!(Boolean)session.getAttribute("adminUser")));
                    url = "/items.jsp";
                    break;                       
                case "Login":                 
                    if(loginValidation(request)) url="/index.jsp";
                    else url="/login.jsp";                    
                    break;
                case "Log Out":
                    this.session.setAttribute("loggedInAs", "");                    
                    this.session.setAttribute("adminUser", false);                    
                    url="/index.jsp";                    
                    break;
                case "Register":  
                    //if no register errors, return true
                    if(registerValidation(request)) url="/index.jsp";                    
                    else url="/register.jsp";
                    break;
                case "Edit Profile":                    
                    url = "/editprofile.jsp";
                    break;
                case "Update Profile":
                    if(updateProfileValidation(request))url = "/index.jsp";
                    else url = "/editprofile.jsp";
                    break;
                case "View Profile":
                    this.session.setAttribute("userInfo", getProfileInfo());
                    url= "/viewprofile.jsp";
                    break;
                case "View Orders":
                    getOrders(request);
                    url = "/orders.jsp";                    
                    break;
                case "Make Admin":                    
                    makeUserAdmin((String)request.getParameter("userID"));                    
                    url = "/OnlineShoppingServlet";
                    request.setAttribute("newAction", "Customers");                   
                    break;
                case "Customers":
                    this.session.setAttribute("customerList", getCustomers());
                    url="/viewcustomers.jsp";                    
                    break;               
                case "Add To Cart":      
                    addItemToCart(request);   
                    url = "/OnlineShoppingServlet";
                    request.setAttribute("newAction", "Items");                   
                    break;
                case "Update Quantity":                                        
                    String updateChoice = request.getParameter("updateChoice");
                    if(updateChoice.equals("Add")) updateItemQuantity(false,request);
                    else if(updateChoice.equals("Remove")) updateItemQuantity(true, request);
                                        
                    url = "/OnlineShoppingServlet";
                    request.setAttribute("newAction", "Items");
                    break;
                case "Remove From Cart":
                    removeFromCart(Integer.parseInt(request.getParameter("itemID")));
                    url = "/cart.jsp";                   
                    break;
                case "Remove Item":
                    int itemID = Integer.parseInt(request.getParameter("itemID"));
                    removeItemFromDB(itemID);
                    url = "/OnlineShoppingServlet";
                    request.setAttribute("newAction", "Items");
                    break;
                case "Add Item":                    
                    addItemToDB(request);
                    url = "/OnlineShoppingServlet";
                    request.setAttribute("newAction", "Items");
                    break;                    
                case "Search Item":
                    this.session.setAttribute("itemList", searchItem(!(Boolean)session.getAttribute("adminUser"), request));
                    url = "/items.jsp";
                    break;
                case "Checkout":
                    if(!((ArrayList<CartItem>)this.session.getAttribute("cart")).isEmpty()){
                        if(this.session.getAttribute("loggedInAs").equals("") ) url = "/login.jsp";
                        else url = "/checkout.jsp";
                    }
                    else url = "/cart.jsp";
                    break;
                case "Pay":
                    if(payItems(request)) url="/index.jsp";
                    else url = "/checkout.jsp";
                    break;
                case "Inspect Order":
                    this.session.setAttribute("orderItemList", getOrderItems(request));
                    this.session.setAttribute("orderPrice", getOrderPrice(request));
                    this.session.setAttribute("orderID", request.getParameter("orderID"));
                    url = "/orderinspection.jsp";
                    break;
                case "Confirm Order":
                    setOrderConfirmed(request);
                    url = "/OnlineShoppingServlet";
                    request.setAttribute("newAction", "View Orders");
                    break;
                case "Search Customer":
                    this.session.setAttribute("customerList", searchCustomer(request));
                    url = "/viewcustomers.jsp";
                    break;
                default:
                    url = "/index.jsp";
                    break;
            }

            
            //from slides, forward to correct page! 
            ServletContext sc = request.getServletContext();  
            RequestDispatcher rd = sc.getRequestDispatcher(url); 
            rd.forward(request, response); 
           
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(OnlineShoppingServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
            //response.sendRedirect((String)this.session.getAttribute("url"));
        } catch (SQLException ex) {
            Logger.getLogger(OnlineShoppingServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    //will collect email and password from the request parameters and check wheter or not this account exists
    //different redirections depending on if the login succeds or not
    private boolean loginValidation(HttpServletRequest request) throws SQLException {
        String username = request.getParameter("email");
        String password = request.getParameter("password");            
        
        String query = "SELECT * FROM customers WHERE email = ? AND password = ?";
        PreparedStatement pstmt = this.conn.prepareStatement(query);
        pstmt.setString(1, username);
        pstmt.setString(2, password);        
        ResultSet res = pstmt.executeQuery();        
        
        //will check if there is a next row ( or any row at all) in the resutset
        if(res.next()){                
            this.session.setAttribute("loggedInAs",res.getString("email"));    
            if(res.getBoolean("admin")) this.session.setAttribute("adminUser", true);
            return true;
        }
        return false;
        
        
    }
    
    //will gather all parameters from the request and make a new customer account
    //will return error messages through session if a parameter was invalid
    private boolean registerValidation(HttpServletRequest request) throws SQLException {
          
        
        String fullname = request.getParameter("Name");
        String email = request.getParameter("Email");
        String phonenumber = request.getParameter("Phone");
        String adress = request.getParameter("Adress");
        String password = request.getParameter("Password");
        String confirmpassword = request.getParameter("ConfirmPassword");
        boolean adminUser = false;
        String[] errors = new String[]{"","","","","",""};
        
        
        //check if the input is valid
        //if(!fullname.contains(" ")) errors[0]="* Both first and last name is required!";
        if(fullname.split(" ").length < 2) errors[0]="* Both first and last name is required!";
        if(!email.contains("@") || email.indexOf("@") == 0) errors[1]="* Not a valid email adress!";
        if(!phonenumber.matches("\\d+") || phonenumber.length() != 11) errors[2]="* Not a valid phonenumber! Enter 11 digits.";
        if(adress.length() == 0) errors[3]="* You need to enter a adress!";
        if(password.equals(""))errors[4]="* Enter a password!";
        if(confirmpassword.equals(""))errors[5]="* Enter a password!";
        if(!password.equals(confirmpassword)){
            errors[4]="* Passwords do not match!";
            errors[5]=errors[4];
        }
        //check if the email has been used before or if any error occured 
        //if everything is valid, add the new costumer and return true
        if(usernameAvailable(email,errors) && emptyStringArray(errors)){  
            String query = "INSERT INTO PreparedStatement pstmt = this.conn.prepareStatem customers (email, password, fullname, adress, phoneNumber,admin) VALUES (?,?,?,?,?, FALSE)";
            
            PreparedStatement pstmt = this.conn.prepareStatement(query);
            pstmt.setString(1, email);
            pstmt.setString(2, password); 
            pstmt.setString(3, fullname);
            pstmt.setString(4,adress);
            pstmt.setString(5, phonenumber);
            pstmt.execute();
            
            return true;
        }
        else{//if errors occured,put them in session and return false
            this.session.setAttribute("regErrors", errors);
            return false;
        }
            
        
    }
    
    //will check if every string in the given string array equals ""
    private boolean emptyStringArray(String[] array){
        boolean empty = true;
        if(array == null) return empty;
        for(String str : array){
            if(str!= "") empty = false;
        }
        return empty;
    }
    
    //Will perform a check to see if an email has been used earlier
    //used in the registration validation control
    private boolean usernameAvailable(String email, String[] errors) throws SQLException {
       String query = "SELECT * FROM customers WHERE email = ?";       
       PreparedStatement pstmt = this.conn.prepareStatement(query);
       pstmt.setString(1, email);        
       ResultSet res = pstmt.executeQuery();       
       if(res.isBeforeFirst()){
           errors[1] = "* Email is already in use!";
           return false;
       }
       
       return true;
    }

    //will return a list of customers for the jsp page
    private ResultSet getCustomers() throws SQLException {
        Statement stmt = this.conn.createStatement();
        String query = "SELECT * FROM customers";
        ResultSet res = stmt.executeQuery(query);        
        return res;
    }

    //Will return a list of items to the jsp pages
    //the boolean will determine if items with quantitys below 1 should be included
    private ResultSet getItems(boolean onlyAvailItems) throws SQLException {
        Statement stmt = this.conn.createStatement();
        String query = "SELECT * FROM items";
        if(onlyAvailItems) query += " WHERE itemQuantity > '0'";        
        ResultSet res = stmt.executeQuery(query);        
        return res;
    }

    //will update the item quantity in the database whenever customers add an item to the cart or ifthe admin updates the quantities
    private void updateItemQuantity(boolean lowerQuantity, HttpServletRequest request) throws SQLException {
        if(request.getParameter("itemAmount").matches("\\d+")){
            int itemID = Integer.parseInt(request.getParameter("itemID"));
            int itemAmount = Integer.parseInt(request.getParameter("itemAmount"));           
            String query;
            if(lowerQuantity) query = "UPDATE items SET itemQuantity = itemQuantity - ? WHERE itemID = ?";
            else query = "UPDATE items SET itemQuantity = itemQuantity + ? WHERE itemID = ?";
            PreparedStatement pstmt = this.conn.prepareStatement(query);
            pstmt.setInt(1, itemAmount);
            pstmt.setInt(2, itemID);        
            pstmt.execute();           
        }
    }

    //Will get the details for the item that is to be added to the cart
    //add the details to a new CartItem object and add the object to the existing cart ArrayList
    //Will also update the total price of the cart items which is stored in the session
    private void addItemToCart(HttpServletRequest request) throws SQLException {
        //the item to add from database
       
        int itemID = Integer.parseInt(request.getParameter("itemID"));         
        String query = "SELECT * FROM items WHERE itemID = ?";        
        PreparedStatement pstmt = this.conn.prepareStatement(query);
        pstmt.setInt(1, itemID);
        ResultSet res = pstmt.executeQuery();        
        res.next();        
        
        String itemName = res.getString("itemName");
        int itemPrice = Integer.parseInt(res.getString("price"));
        String itemDescription = res.getString("description");
        
        //lower the quantity in the item database
        updateItemQuantity(true,request);
        
        //get the cart object
        ArrayList<CartItem> arr = (ArrayList<CartItem>)this.session.getAttribute("cart");
        //create new cart item object
        CartItem newItem = new CartItem(itemID,itemName,1,itemPrice,itemDescription);
        
        //if the item already exists in the cart
        boolean itemExists = false;
        int index = 0;
        for(CartItem obj : arr){
            if(itemID == obj.getItemID()){
                obj.updateItemQuantity(true);
                itemExists = true;
                break;
            }
            index++;
        }
        //if it doesnt exist in the cart        
        if(!itemExists){
            arr.add(newItem);
            this.session.setAttribute("cart", arr);
        }
        
        //update the total price in cart
        int totPrice = Integer.parseInt((String)this.session.getAttribute("totalPrice"));
        totPrice += newItem.getItemPrice();
        this.session.setAttribute("totalPrice", Integer.toString(totPrice));
        
    }

    //will update the cart ArrayList in the session object when the customer removes an item
    //will also update the total price 
    private void removeFromCart(int itemID) {
        ArrayList<CartItem> arr = (ArrayList<CartItem>)this.session.getAttribute("cart");
        int index = 0;
        for(CartItem obj : arr){
            if(obj.getItemID() == itemID){
                int totPrice = Integer.parseInt((String)this.session.getAttribute("totalPrice"));
                totPrice -= obj.getItemPrice();
                this.session.setAttribute("totalPrice", Integer.toString(totPrice));
                if(obj.getItemQuantity() > 1)obj.updateItemQuantity(false);
                else arr.remove(index);
                break;
            }
            index++;
        }
        this.session.setAttribute("cart", arr);
    }

    //will delete the chosen item fromthe item database completely
    //admins can perform this
    private void removeItemFromDB(int itemID) throws SQLException {
        Statement stmt = this.conn.createStatement();
        String query = "DELETE FROM items WHERE itemID = ?";               
        PreparedStatement pstmt = this.conn.prepareStatement(query);
        pstmt.setInt(1, itemID);  
        pstmt.execute();
    }
    
    //will get the request parameters and perform a validation control
    //if all parameters are valid, it will add a new item tothe inventory (items table)
    //also returns error messages if one of the parameters are invalid
    private void addItemToDB(HttpServletRequest request) throws SQLException {
        String[] addItemErrors = new String[]{"","",""};
        if(!request.getParameter("itemID").matches("\\d+"))addItemErrors[0] = "* Invalid item ID!";
        else if(!itemIdAvailable(request.getParameter("itemID"))) addItemErrors[0] = "* Item ID already in use!";
        
        if(!request.getParameter("itemQuantity").matches("\\d+")) addItemErrors[1] = "* Invalid item quantity!";
        
        if(!request.getParameter("itemPrice").matches("\\d+")) addItemErrors[2] = "* Invalid item price!";
        
        if(emptyStringArray(addItemErrors)){
            int itemID = Integer.parseInt(request.getParameter("itemID"));
            String itemName = request.getParameter("itemName");
            int itemQty = Integer.parseInt(request.getParameter("itemQuantity"));
            int itemPrice = Integer.parseInt(request.getParameter("itemPrice"));
            String itemDescr = request.getParameter("itemDescription");

            Statement stmt = this.conn.createStatement();
            String query = "INSERT INTO items VALUES(?,?,?,?,?)";
            PreparedStatement pstmt = this.conn.prepareStatement(query);
            pstmt.setInt(1, itemID);
            pstmt.setString(2, itemName);
            pstmt.setInt(3, itemQty);
            pstmt.setInt(4, itemPrice);
            pstmt.setString(5, itemDescr);
            pstmt.execute();          
        }
        else this.session.setAttribute("addItemErrors", addItemErrors);
    }
    
    // will get the parameters from the request to update the current users profile info
    //will perform the same controlls as the regitration validation control
    //the textboxes that was left empty will not be updated
    private boolean updateProfileValidation(HttpServletRequest request) throws SQLException{
        String user = (String)this.session.getAttribute("loggedInAs");
        String newPassword = request.getParameter("newpassword");
        String confirmPassword = request.getParameter("confirmpassword");
        
        String fullname = request.getParameter("fullname");
        String address = request.getParameter("address");
        String phonenumber = request.getParameter("phonenumber");
        
        Statement stmt = this.conn.createStatement();
        String query = "UPDATE customers SET ";
        String parameters = "";
        
        
        String[] updateErrors = new String[]{"","","","","",""};
        boolean noUpdate = true;        
        if(!newPassword.equals("") ){
            noUpdate = false;
            if(confirmPassword.equals(newPassword)){
                String oldPassword = request.getParameter("oldpassword");
                ResultSet res = stmt.executeQuery("SELECT * FROM customers WHERE email='"+user+"' and password='"+oldPassword+"'");
                if(res.next())parameters += "password="+"'"+newPassword+"'";
                else updateErrors[0] = "* Wrong password!";
            }
            else {
                updateErrors[1] = "* Passwords does not match!";
                updateErrors[2] = "* Passwords does not match!";
            }
        }
        if(!fullname.equals("") ){
            noUpdate = false;
            if(fullname.split(" ").length > 1){
                if(!parameters.equals("")) parameters += ",";
                parameters += "fullname="+"'"+fullname+"'";
            }
            else updateErrors[3] = "* Both first and last name are required!";
        }
        if(!address.equals("")){
            noUpdate = false;
            if(!parameters.equals("")) parameters += ",";
            parameters += "adress="+"'"+address+"'";
        }
        if(!phonenumber.equals("") ){  
            noUpdate = false;
            if(phonenumber.matches("\\d+") && phonenumber.length() == 11){
                if(!parameters.equals("")) parameters += ",";
                parameters += "phoneNumber="+"'"+phonenumber+"'";
            }
            else updateErrors[5] = "* Invalid phone number! Enter 11 digits.";
        }        
        parameters += " WHERE email="+"'"+user+"'";
        if(!noUpdate && emptyStringArray(updateErrors)){
            
            stmt.executeUpdate(query+parameters);
            return true;
        }
        this.session.setAttribute("updateErrors", updateErrors);
        return false;
        
    }

    //will retrieve the profile info of the current user
    private ResultSet getProfileInfo() throws SQLException {
        String user = (String)this.session.getAttribute("loggedInAs");        
        String query = "SELECT * FROM customers WHERE email = ?";        
        PreparedStatement pstmt = this.conn.prepareStatement(query);
        pstmt.setString(1, user);
        ResultSet res = pstmt.executeQuery();
        return res;
    }

    //will update the status of a user to admin if the user is a customer
    //or downgrade an admin to normal customer level
    private void makeUserAdmin(String user) throws SQLException {
        //Statement stmt = this.conn.createStatement();        
        String query = "SELECT * FROM customers WHERE email = ?";
        PreparedStatement pstmt = this.conn.prepareStatement(query);
        pstmt.setString(1, user);        
        ResultSet res = pstmt.executeQuery();
        
        res.next();
        boolean isAdmin = res.getBoolean("admin");
        query = "UPDATE customers SET admin=? where email=?";
        pstmt = this.conn.prepareStatement(query);
        pstmt.setString(2,user); 
        if(isAdmin && !user.equals((String)this.session.getAttribute("loggedInAs")))pstmt.setBoolean(1, false);
        else pstmt.setBoolean(1, true);
        pstmt.execute();
    }
    //will check if it is ok to use a given itemID when adding a new item to the inventory
    private boolean itemIdAvailable(String itemID) throws SQLException {        
        String query = "SELECT * FROM items WHERE itemID=?";
        PreparedStatement pstmt = this.conn.prepareStatement(query);
        pstmt.setString(1, itemID);
        ResultSet res = pstmt.executeQuery();
        return !res.next();        
    }

    //look for specific items
    private ResultSet searchItem(boolean onlyAvailItems, HttpServletRequest request) throws SQLException {
        Statement stmt = this.conn.createStatement();
        String query = "SELECT * FROM items WHERE ";   
        String parameters = "";
        
        String itemID = request.getParameter("itemID");
        String itemName = request.getParameter("itemName");
        String lowerPrice = request.getParameter("lowerItemPrice");
        String upperPrice = request.getParameter("upperItemPrice");
        
        if(!itemID.equals("")){  
            if(itemID.matches("\\d+"))parameters += " itemID="+itemID;
            else parameters += " 1=0 ";
        }        
        if(!itemName.equals("")){                
            if(!parameters.equals("")) parameters += " AND ";
            parameters += " itemName LIKE '%"+itemName+"%'";
        }            
        if(!upperPrice.equals("") && upperPrice.matches("\\d+")){                
            if(!parameters.equals("")) parameters += " AND ";                
            parameters += " price <= "+upperPrice;                
        }
        if(!lowerPrice.equals("") && lowerPrice.matches("\\d+")){                
            if(!parameters.equals("")) parameters += " AND ";                
            parameters += " price >= "+lowerPrice;       
        }
            
        
        if(onlyAvailItems && parameters.equals("")) parameters += " itemQuantity > 0";
        else if(onlyAvailItems && !parameters.equals("")) parameters += " AND itemQuantity > '0'";
        
        if(parameters.equals("")) parameters +=" 1=1";
        query += parameters;                       
        ResultSet res = stmt.executeQuery(query);
        return res;
    }

    //will only perform the payment process if a 10 digit card number has been entered, otherwise give error message
    //will find the order ID of the latest order to make a new orderID for the new order
    //Will then create a new order record in the orders table
    //then loop over the items in the cart and add them tothe ordered_items table
    //refresh and empty the cart/cart total price in the end for new orders
    private boolean payItems(HttpServletRequest request) throws SQLException {
        String cardNumber = request.getParameter("cardNumber");
        if(cardNumber.matches("\\d+") && cardNumber.length() == 10){
            
            ArrayList<CartItem> cartItems = (ArrayList<CartItem>)this.session.getAttribute("cart");
            int orderIndex;
            Statement stmt = this.conn.createStatement();
            String query = "SELECT IFNULL(MAX(orderID),0) FROM orders"; 
            ResultSet res = stmt.executeQuery(query);
            
            //if(!res.isBeforeFirst()) orderIndex = 1;
            //else{
            res.next();
            orderIndex = 1 + res.getInt(1);
            //}
            
            query = "INSERT INTO orders VALUES(?, ?, ?, ?)";
            PreparedStatement pstmt = this.conn.prepareStatement(query);
            pstmt.setInt(1, orderIndex);
            pstmt.setString(2,(String)this.session.getAttribute("loggedInAs"));
            pstmt.setInt(3, Integer.parseInt((String)this.session.getAttribute("totalPrice")));
            pstmt.setBoolean(4, false);
            pstmt.execute();
            
            for(CartItem obj : cartItems){
                query = "INSERT INTO ordered_items VALUES(?, ?, ?)";
                pstmt = this.conn.prepareStatement(query);
                pstmt.setInt(1, orderIndex);
                pstmt.setInt(2, obj.getItemID());
                pstmt.setInt(3, obj.getItemQuantity());
                pstmt.execute();
            }
            
            this.session.removeAttribute("cart");
            this.session.setAttribute("cart", new ArrayList<CartItem>());
            this.session.setAttribute("totalPrice", "0");
            return true;
        }
        else{
            this.session.setAttribute("cardError", "* Not a valid card number! Enter a 10 digit card number");
            return false;
        }
    }

    //get a list of all or specific orders and store in session object
    private void getOrders(HttpServletRequest request) throws SQLException {
        Statement stmt = this.conn.createStatement();        
        String query = "SELECT * FROM orders";
        String userID = request.getParameter("userID");        
        if(userID != null && !userID.equals("")) query += " WHERE email = '"+userID+"'";   
        ResultSet res = stmt.executeQuery(query);  
        this.session.setAttribute("ordersList", res);       
    }
    
    //change the delivery status of an order
    private void setOrderConfirmed(HttpServletRequest request) throws SQLException {
        
        int orderID = Integer.parseInt(request.getParameter("orderID"));
        Statement stmt = this.conn.createStatement();        
        String query = "SELECT * FROM orders where orderID="+orderID;
        ResultSet res = stmt.executeQuery(query);
        res.next();
        query = "UPDATE orders SET confirmed = ? WHERE orderID = ?";
        PreparedStatement pstmt = this.conn.prepareStatement(query);
        pstmt.setInt(2, orderID);
        if(res.getBoolean("confirmed"))pstmt.setBoolean(1, false);
        else pstmt.setBoolean(1, true);             
        pstmt.executeUpdate();
        
    }

    //will return a list of items that belons to a specific orderID
    private ResultSet getOrderItems(HttpServletRequest request) throws SQLException {
        int orderID = Integer.parseInt(request.getParameter("orderID"));    
        String query = "select i.itemID,i.itemName,oi.quantity itemQuantity,i.price,i.description,o.confirmed from ordered_items oi, items i,orders o where o.orderID= ? and oi.orderID=o.orderID and oi.itemID=i.itemID";
        PreparedStatement pstmt = this.conn.prepareStatement(query);   
        pstmt.setInt(1, orderID);
        ResultSet res = pstmt.executeQuery();
        return res;
    }

    //will return the price of a specific order
    private String getOrderPrice(HttpServletRequest request) throws SQLException {
        int orderID = Integer.parseInt(request.getParameter("orderID"));  
        String query = "SELECT orderPrice FROM orders where orderID = ?";
        PreparedStatement pstmt = this.conn.prepareStatement(query); 
        pstmt.setInt(1, orderID);
        ResultSet res = pstmt.executeQuery();
        res.next();
        return res.getString("orderPrice");
    }
    
    //will search for a specific customer
    private ResultSet searchCustomer(HttpServletRequest request) throws SQLException {
        Statement stmt = this.conn.createStatement();
        String query = "SELECT * FROM customers WHERE ";   
        String parameters = "";
        
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String address = request.getParameter("address");
        String phonenumber = request.getParameter("phonenumber");
        
        if(!email.equals("")) parameters += " email LIKE '%"+email+"%'";  
        if(!fullname.equals("")){
            if(!parameters.equals("")) parameters += " AND ";
            parameters += " fullname LIKE '%"+fullname+"%'";
        }            
        if(!address.equals("")){                
            if(!parameters.equals("")) parameters += " AND ";                
            parameters += " adress LIKE '%"+address+"%'";                
        }
        if(!phonenumber.equals("") && phonenumber.matches("\\d+")){                
            if(!parameters.equals("")) parameters += " AND ";                
            parameters += " phoneNumber LIKE '%"+phonenumber+"%'";       
        }            
       
        if(parameters.equals("")) parameters +=" 1=1";
        query += parameters;        
        ResultSet res = stmt.executeQuery(query);   
        
        return res;
    }
    
}
