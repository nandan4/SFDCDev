public class VFC_MultiSelect {
    public List<Account> accList{get;set;}
    public String objName{get;set;}
    private List<String> objectNames = new List<String>{'Account','Contact'};
    
    public VFC_MultiSelect(ApexPages.StandardController controller) {
    // objName = objectNames[0];
    }
    
    public List<selectOption> getacc(){
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('','--None--'));
        system.debug('******'+options);
        for(Schema.SObjectType f : gd){ 
            for(String s: objectNames){
                if(f.getDescribe().getLabel().equalsIgnoreCase(s)){
                    options.add(new SelectOption(f.getDescribe().getLabel(),f.getDescribe().getLabel()));
                }
            }            
        } 
        system.debug('******'+options);
        return options; 
    }
    
    public void rec(){
        List<selectOption> options = new List<selectOption>();
        system.debug('** objName ==>'+ objName);
        if(objName!=null){
            system.debug('!!!!!!!inside if'+ objName);
            String queryString = ' SELECT Id, Name FROM '+ objName;
            System.debug('Query'+queryString);
            List<SObject> queryParentObject = Database.query(queryString);
            System.debug('Check it out'+Database.query(queryString));
            
            for(sObject so : queryParentObject){
                options.add(new selectOption(so.id,so.id)); 
            }
        }
    }

}