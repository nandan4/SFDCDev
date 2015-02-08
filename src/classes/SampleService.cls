global class SampleService {
    
    webservice static List<String> retrieveAccounts(){
        List<String> accList = new List<String>();
        for(Account acc : [SELECT Id,Name FROM Account]){
            accList.add(acc.Name);
        
        }
        return accList ;
    }
}