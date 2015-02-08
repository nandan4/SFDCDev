public class FLSGlobalCont {
    
    // Variables
    public String selfieldName {get;set;}
    public String selObjName {get;set;}
    
    public List<SelectOption> getObjList(){
    
        List<Schema.SObjectType> gDesc = Schema.getGlobalDescribe().Values();     
        List<SelectOption> options = new List<SelectOption>();
        // ProcessInstance.TargetObjectId.getDescribe().getReferenceTo()
        for(Schema.SObjectType f : gDesc){
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
    
    public List<FieldPermissions> getProfilePermissions() {
        
        String field = selObjName + '.' + selfieldName  ;
        List<FieldPermissions>  prfs = new List<FieldPermissions >();
        prfs = [SELECT SystemModstamp, SobjectType, PermissionsRead, PermissionsEdit, Parent.Profile.Name, Id, Field ,Parent.PermissionsEditReadonlyFields
                FROM FieldPermissions WHERE Field =: field AND sObjectType =: selObjName  ];
        
        System.debug('** Profile Permissions ==>'+ prfs);    
        return prfs;
    
    }

}