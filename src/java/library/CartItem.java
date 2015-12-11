/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author anthon
 */
 package library;

public class CartItem {
    
    private int itemID;
    private String itemName;
    private int itemQuantity;
    private int itemPrice;
    private String itemDescription;

    public CartItem(int itemID, String itemName, int itemQuantity, int price, String description) {
        this.itemID = itemID;
        this.itemName = itemName;
        this.itemQuantity = itemQuantity;
        this.itemPrice = price;
        this.itemDescription = description;
    }

    
    /**
     * @return the itemID
     */
    public int getItemID() {
        return itemID;
    }

    /**
     * @param itemID the itemID to set
     */
    public void setItemID(int itemID) {
        this.itemID = itemID;
    }

    /**
     * @return the itemName
     */
    public String getItemName() {
        return itemName;
    }

    /**
     * @param itemName the itemName to set
     */
    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    /**
     * @return the itemQuantity
     */
    public int getItemQuantity() {
        return itemQuantity;
    }

    /**
     * @param itemQuantity the itemQuantity to set
     */
    public void setItemQuantity(int itemQuantity) {
        this.itemQuantity = itemQuantity;
    }

    /**
     * @return the price
     */
    public int getItemPrice() {
        return itemPrice;
    }

    /**
     * @param itemPrice the price to set
     */
    public void setItemPrice(int itemPrice) {
        this.itemPrice = itemPrice;
    }

    /**
     * @return the description
     */
    public String getItemDescription() {
        return itemDescription;
    }

    /**
     * @param itemDescription the description to set
     */
    public void setItemDescription(String itemDescription) {
        this.itemDescription = itemDescription;
    }
    
    public void updateItemQuantity(boolean addQuantity){
        if(addQuantity)this.itemQuantity++;
        else if(this.itemQuantity > 0)this.itemQuantity--;
    }
    
    
}
