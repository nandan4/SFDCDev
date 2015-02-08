/**
  *  @Author      : Nandan N
  *  @Name        : Object360ViewController
  *  @Date        : 20/01/2014 
  *  @Description : Controller Extension for Object360View Page
*/
public class Object360ViewController{

    public String selObjName {get;set;}
    public String fieldToolTip {get;set;}  
    public List<FieldWrapper> fieldsList {get;set;}      
    
    public List<SelectOption> getObjList(){   
        List<Schema.SObjectType> gDesc = Schema.getGlobalDescribe().Values();     
        List<SelectOption> options = new List<SelectOption>();
        
        for(Schema.SObjectType f : gDesc){
            if(!f.getDescribe().CustomSetting){  
                options.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getLabel()));
            }
        }
        return options;
    }
    
    public void refreshView(){
        System.debug('*** selObjName ==>'+selObjName);
        Integer boolCount = 0;
        Integer strgCount = 0;
        Integer currCount = 0;
        Integer dateCount = 0;
        Integer dateTimeCount = 0;
        Integer picklistCount = 0;
        Integer multiPickCount = 0;
        Integer refCount = 0;
        Integer phoneCount = 0;
        
        fieldToolTip = ' ';
        fieldToolTip += 'Total Number of Fields : ';
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(selObjName).getDescribe().fields.getMap();
        fieldToolTip += objectFields.size() + '\n';
        for(Schema.SObjectField f : objectFields.values()){
            String type = String.ValueOf(f.getDescribe().getType());
            if(type.equalsIgnoreCase('Boolean')){
                boolCount ++;
            }
            else if(type.equalsIgnoreCase('String')){
                currCount ++;
            }
            else if(type.equalsIgnoreCase('Date')){
                dateCount ++;
            }
            else if(type.equalsIgnoreCase('DateTime')){
                dateTimeCount ++;
            }
            else if(type.equalsIgnoreCase('Picklist')){
                picklistCount ++;
            }
            else if(type.equalsIgnoreCase('MultiPicklist')){
                multiPickCount ++;
            }
            else if(type.equalsIgnoreCase('Phone')){
                phoneCount ++;
            }
            else if(type.equalsIgnoreCase('Reference')){
                refCount ++;
            }
            //options.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getLabel()));
        }
        fieldToolTip += 'Boolean Fields :  ' + boolCount + '\n';
        fieldToolTip += 'String Fields :  ' + strgCount + '\n';
        fieldToolTip += 'Date Fields :  ' + dateCount + '\n';
        fieldToolTip += 'Date-Time Fields :  ' + dateTimeCount + '\n';
        fieldToolTip += 'Picklist Fields :  ' + picklistCount + '\n';
        fieldToolTip += 'Multi-Select Picklist Fields :  ' + multiPickCount + '\n';
        fieldToolTip += 'Phone Fields :  ' + phoneCount + '\n';
        fieldToolTip += 'MD/Lookup Fields :  ' + refCount + '\n';

        System.debug('*** fieldToolTip ==>'+fieldToolTip );
    }
    
    public void fetchFields(){
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(selObjName).getDescribe().fields.getMap();
        fieldsList = new List<FieldWrapper>();
        for(Schema.SObjectField f : objectFields.values()){  
            Schema.DescribeFieldResult fieldResult = f.getDescribe();
            FieldWrapper fld = new FieldWrapper();
            fld.fieldLabel =  fieldResult.getLabel(); 
            fld.fieldName = fieldResult.getName();
            fld.dataType = String.valueOf(fieldResult.getType());
            fieldsList.add(fld);
        }  
    }
        
    public class FieldWrapper{
        public String fieldLabel {get;set;}
        public String fieldName {get;set;}
        public String dataType {get;set;}
    }
}