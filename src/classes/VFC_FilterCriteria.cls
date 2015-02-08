/*
    Author          : Nandan Narasappa
    Date Created    : 26/06/2013
    Description     : Controller for VFP_FilterCriteria
*/
public with sharing class VFC_FilterCriteria {
    
    // Class Variables
    public String selObjName {get;set;}
    public String selfieldName {get;set;}
    
    public VFC_FilterCriteria(ApexPages.StandardController controller){
    
    }
    
    public List<SelectOption> getObjList(){
        
        List<SelectOption> options = new List<SelectOption>();
        // ProcessInstance.TargetObjectId.getDescribe().getReferenceTo()
        //Schema.getGlobalDescribe().Values()
        for(Schema.SObjectType f : ProcessInstance.TargetObjectId.getDescribe().getReferenceTo()){
            if(!f.getDescribe().CustomSetting){  
                options.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getLabel()));
            }
        }
        return options;
    }
    
    public List<SelectOption> getfieldList(){
       
        List<SelectOption> options = new List<SelectOption>();
        if(selObjName == Null){
            selObjName = ProcessInstance.TargetObjectId.getDescribe().getReferenceTo()[0].getDescribe().getLabel();
        }
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(selObjName).getDescribe().fields.getMap();
        for(Schema.SObjectField f : objectFields.values()){
            options.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getLabel()));
        }
        return options;
    }
}