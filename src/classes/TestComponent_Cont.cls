public with sharing class TestComponent_Cont{
    public Id accId {get;set;}
    public boolean showTbl {get;set;}    
    public LIst<Account> accList {get;set;}   
    public List<contact> conList {get;set;}    
    public PageReference page {get;set;}    
    
    public TestComponent_Cont(){
        showTbl = false;    
        accList = [SELECT Id, Name FROM Account limit 5];
        System.debug('*** showTbl ==>'+ showTbl );            
        System.debug('*** accList ==>'+ accList );    
    }
    
    public void refresh(){    
        showTbl = true;    
        page = new PageReference('/apex/TestComponentPage');
        System.debug('*** showTbl ==>'+ showTbl );            
        System.debug('*** accId ==>'+ accId);    
        conList = [SELECT Id,Name FROM Contact WHERE AccountId =: accId];                
        System.debug('*** conList ==>'+ conList);        
    }
}