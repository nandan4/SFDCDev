public without sharing class 
WOSharing {

    public static void createAccount(){
        Account acc = new Account(Name='Test');
        insert acc;
    }
    
    public static void insertAccount(){    
        WSharing.createAccount();
    }
    
}