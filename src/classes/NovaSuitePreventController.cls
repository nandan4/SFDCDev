public class NovaSuitePreventController{
    private static Set<String> profileSet = new Set<String>{'Novacop Users'};
    private static NovaRun__c run ;
    
    public NovaSuitePreventController(ApexPages.StandardController controller){
        run = (NovaRun__c) controller.getRecord();
    }
    
    public static PageReference preventNovaRunDelete(){
        PageReference page = null;
        if(getProfileIds(profileSet).contains(Userinfo.getProfileId())){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Permission Denied'));
        }
        else{
            Database.delete(run);
            page = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
        }  
        return page;          
    }
    
    public static PageReference preventNovaRunEdit(){
        PageReference page = null;
        if(getProfileIds(profileSet).contains(Userinfo.getProfileId())){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Permission Denied'));
        }
        else{    
            page = new PageReference('/'+run.id + '/e?nooverride=1');
        }  
        return page;          
    }
    
    public static Set<Id> getProfileIds(Set<String> profileNames){
        Set<Id> profileIds = new Set<Id>();
        for(Profile pf : [SELECT Id FROM Profile WHERE Name IN: profileNames]){
            profileIds.add(pf.Id);    
        } 
        return profileIds;
    }
}