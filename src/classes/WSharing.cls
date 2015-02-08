public with sharing class  WSharing {

    public static void createAccount(){
        Account acc = new Account(Name='Test');
        insert acc;
    }
    
    public static void insertAccount(){    
        WOSharing.createAccount();
    }
    

}