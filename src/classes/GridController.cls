Global Class GridController{
    
    /* Variables */
    public static List<Account> acc {get;set;}
    public static Integer accSize {get;set;}
    
    /* Constructor */
    Public GridController(){
        acc = [SELECT Id,Name,NumberOfEmployees,AnnualRevenue FROM Account];
        accSize  = acc.size();
    }
    
    @RemoteAction
    global static List<Account> accountList(){
        System.debug('Remote Function Called');
        acc = [SELECT Id,Name,NumberOfEmployees,AnnualRevenue FROM Account];        
        System.debug('** Account List ==>'+acc);
        System.debug('** No. Of Accounts ==>'+accSize);
        return acc;
    }
    
    @RemoteAction
    global static Boolean updateAccount(Account ac){
         System.debug('Account to be Updated ==> '+ac);
        //update ac;        
        return true;
    }
}