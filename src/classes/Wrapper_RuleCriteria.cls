/**
  * @Author      Accenture IDC Team 
  * @CreatedDate 04/29/2013
  * @Description Wrapper class for every filter criteria record
  * @Version     0.1
  */
public with sharing class Wrapper_RuleCriteria {
    // variables declaration for the fields of Validation rule criteria object
    public String fieldAPIName {get;set;}   
    public String filterCriteriaValue {get;set;}
    public List<SelectOption> filterCriteriaValueOptions {get;set;}
    public String operator {get;set;}
    public List<SelectOption> operatorOptions {get;set;}
    //public Integer criteriaNumber {get;set;} 
    public String fieldType {get;set;}
    public ID id;       
    public String objectName {get;set;}
    public Map<String, String> fieldDataTypeMap = new Map<String, String>();
    private boolean isDeleted=false;
    Map<String, Schema.SObjectField> fieldMap= new Map<String, Schema.SObjectField>();
    
  /**
    * @MethodName Wrapper_CustomVRFilterCriteria
    * @Description Constructor for the class used for Create operation.
    * @param <String,Integer>
    */
    public Wrapper_RuleCriteria (String objectName,Integer criteriaNumber){
        this.objectName = objectName;
        //this.criteriaNumber = criteriaNumber;
    }
    
  /**
    * @MethodName Wrapper_CustomVRFilterCriteria
    * @Description Constructor for the class used for Edit and Execution operation.
    * @param <String,String,String,String,String,String,String,String>
    */
    public Wrapper_RuleCriteria (String id, String fieldAPIName, 
                                            String operator, String filterCriteriaValue, String fieldType,
                                                String objectName) {
        this.objectName = objectName;
        this.id = id;
        this.fieldAPIName = fieldAPIName; 
        this.filterCriteriaValue = filterCriteriaValue;
        this.operator = operator;
        //this.criteriaNumber = criteriaNumber;
        this.fieldType = fieldType;
        filterCriteriaValueOptions = new List<SelectOption>();
            //For picklist type of options use value-Options as selectOption        
        if(UTIL_Constants.MULTI_PICKLIST_DATATYPE.equalsIgnoreCase(this.fieldType) 
                                        || UTIL_Constants.IN_OPERATOR.equalsIgnoreCase(this.operator) 
                                            && !String.IsBlank(filterCriteriaValue)) {
            list<string> filterCriteriaValueList= filterCriteriaValue.split(UTIL_Constants.COMMA);
            for(String filterCriteria :filterCriteriaValueList) {
                filterCriteriaValueOptions.add(new selectOption(filterCriteria,filterCriteria));
            }
        }
            fireChangeInField();
    }
    
    
    public String checkSyntax(){
         String checkSyntaxResult;
         if(String.isBlank(this.fieldAPIName)) {
            checkSyntaxResult = 'Error';     
         }else if (String.isBlank(this.operator)){
            checkSyntaxResult = 'Error';
         }else if(!String.isBlank(this.fieldType) && UTIL_Constants.DATE_DATATYPE.equalsIgnoreCase(this.fieldType)
                                                         && !String.isBlank(this.filterCriteriaValue)){
            checkSyntaxResult =  checkDateSyntax();          
         } else if(!String.isBlank(this.fieldType) 
                                              && UTIL_Constants.DATE_TIME.equalsIgnoreCase(this.fieldType) 
                                                    && !String.isBlank(this.filterCriteriaValue)){
            // if field datatype is datetime , check for the format of value entered
            checkSyntaxResult = checkDateTimeSyntax();
         }else if(!String.isBlank(this.fieldType) && 
                    (UTIL_Constants.NUMBER_DATATYPE.equalsIgnoreCase(this.fieldType) || 
                    UTIL_Constants.DOUBLE_DATATYPE.equalsIgnoreCase(this.fieldType))){
            checkSyntaxResult = checkNumberFormat();
         }    
        return checkSyntaxResult;
    }
    
  /**  
    * @MethodName <checkDateSyntax>
    * @Description <This method is used to check the syntax of date field type>
    * @param <NA>
    * @return <String checkSyntaxResult>
    */
    private String checkDateSyntax() {
        Boolean properDateFormat = false;
        String checkSyntaxResult;
         if(!String.isBlank(this.filterCriteriaValue) && 
                (UTIL_Constants.TODAY_DATATYPE.equalsIgnoreCase(this.filterCriteriaValue) || 
                    UTIL_Constants.DEATH_DATE_PC.equalsIgnoreCase(this.filterCriteriaValue)||
                        UTIL_Constants.PERSON_BIRTH_DATE.equalsIgnoreCase(this.filterCriteriaValue) || 
                            UTIL_Constants.NULL_VALUE.equalsIgnoreCase(this.filterCriteriaValue))){
              properDateFormat = true;
         }else{
            String regex = UTIL_Constants.REGEX_DATE_DATATYPE;
            Pattern MyPattern = Pattern.compile(String.valueOf(regex));
            Matcher MyMatcher = MyPattern.matcher(String.valueOf(this.filterCriteriaValue)); 
            if(MyMatcher.matches()) { 
                properDateFormat = true;
            }
          }
         checkSyntaxResult =!properDateFormat ? 'Error' : null;
         return checkSyntaxResult;
    }
    
  /**  
    * @MethodName <checkDateTimeSyntax>
    * @Description <This method is used to check the syntax of date field type>
    * @param <NA>
    * @return <String errorMessage>
    */
    private String checkDateTimeSyntax() {
           Boolean properDateFormat = false;
           String errorMessage;
           if(this.filterCriteriavalue.equalsIgnoreCase(UTIL_Constants.NOW)){
              properDateFormat = true;
           } else{
              String regex = UTIL_Constants.REGEX_DATE_TIME_DATATYPE;
              Pattern MyPattern = Pattern.compile(String.valueOf(regex));
              Matcher MyMatcher = MyPattern.matcher(String.valueOf(this.filterCriteriaValue)); 
              if(MyMatcher.matches()) {
                properDateFormat = true;
              }                 
        }
        errorMessage = !properDateFormat ? 'Error' : null;
        return errorMessage;
    }
    
  /**  
    * @MethodName <checkNumberFormat>
    * @Description <This method is used to check the Number format>
    * @param <NA>
    * @return <String checkSyntaxResult>
    */
    private String checkNumberFormat() {        
        String checkSyntaxResult;
        // if field datatype is Number , check if alphabets are entered
        if(!String.isBlank(this.filterCriteriaValue)){
            if((UTIL_Constants.NUMBER_DATATYPE.equalsIgnoreCase(this.fieldType) || 
                UTIL_Constants.DOUBLE_DATATYPE.equalsIgnoreCase(this.fieldType))) {
                String regex = UTIL_Constants.REGEX_NUMBER_DATATYPE_DATATYPE;
                Pattern MyPattern = Pattern.compile(String.valueOf(regex));
                Matcher MyMatcher = MyPattern.matcher(String.valueOf(this.filterCriteriaValue));
                if(!MyMatcher.matches()){               
                    checkSyntaxResult='Error';
                }
            }
        }
        return checkSyntaxResult;
    }
        
  /** 
    * @MethodName <getIsTextType>
    * @Description <getter method for Text Type fields >
    * @param <NA>
    * @return <boolean isTextType>   
    */
    public boolean getIsTextType() {
        boolean isTextType = false;
        if(!String.isBlank(this.fieldType)) {
                isTextType = (UTIL_Constants.EMAIL_DATATYPE.equalsIgnoreCase(this.fieldType) || 
                                UTIL_Constants.PHONE_TYPE.equalsIgnoreCase(this.fieldType)||
                                UTIL_Constants.DATE_TIME.equalsIgnoreCase(this.fieldType) ||
                                UTIL_Constants.STRING_DATATYPE.equalsIgnoreCase(this.fieldType) ||
                                UTIL_Constants.URL_DATATYPE.equalsIgnoreCase(this.fieldType) ||
                                UTIL_Constants.ADDRESS_TYPE.equalsIgnoreCase(this.fieldType) ||
                                UTIL_Constants.DOUBLE_DATATYPE.equalsIgnoreCase(this.fieldType) ||
                                UTIL_Constants.INTEGER_DATATYPE.equalsIgnoreCase(this.fieldType) ||
                                UTIL_Constants.NUMBER_DATATYPE.equalsIgnoreCase(this.fieldType) ||
                                UTIL_Constants.CURRENCY_DATATYPE.equalsIgnoreCase(this.fieldType) ||
                                UTIL_Constants.ID_TYPE.equalsIgnoreCase(this.fieldType) ||
                                UTIL_Constants.MULTI_PICKLIST_DATATYPE.equalsIgnoreCase(this.fieldType) ||
                                UTIL_Constants.ENCRYPTED_STRING_DATATYPE.equalsIgnoreCase(this.fieldType) ||
                                UTIL_Constants.TEXT_AREA_DATATYPE.equalsIgnoreCase(this.fieldType));
        } 
        else {
            isTextType = true;//For default, when no field is selected we want to show the text field as value.
        }
        return isTextType;                  
    }
    
  /** 
    * @MethodName <getIsPickListType>
    * @Description <getter method for Picklist Type fields >
    * @param <NA>
    * @return <boolean isPickListType>   
    */
    public boolean getIsPickListType() {
        boolean isPickListType = false;
        if(!String.isBlank(this.fieldType)){
                isPickListType = (UTIL_Constants.RECORD_TYPE_ID.equalsIgnoreCase(this.fieldAPIName) ||
                                    UTIL_Constants.PICKLIST_DATATYPE.equalsIgnoreCase(this.fieldType) ||
                                        UTIL_Constants.CHECKBOX_TYPE.equalsIgnoreCase(this.fieldType));
        }
        return isPickListType;
    }
    
  /** 
    * @MethodName <getIsDateType>
    * @Description <getter method for Date Type fields>
    * @param <NA>
    * @return <boolean isDateType>   
    */
    public boolean getIsDateType() {
        boolean isDateType = false;
        if(!String.isBlank(this.fieldType)){
                isDateType = UTIL_Constants.DATE_DATATYPE.equalsIgnoreCase(this.fieldType);
                            
        }
        return isDateType;
    }
    
    public void fireChangeInField(){
        //Describe Call to get the Fields of the object.
        fieldMap = Schema.getGlobalDescribe().get(this.objectName).getDescribe().fields.getMap();
        List<Schema.SObjectField> sObjectFieldList = fieldMap.values();
        for(Schema.SObjectField sFields : sObjectFieldList) {
            fieldDataTypeMap.put(sFields.getDescribe().getName(), sFields.getDescribe().getType().name());
        }
            fieldType = fieldDataTypeMap.get(this.fieldAPIName);//Get the Field Data Type
            if(!String.isBlank(fieldType)){
                if((UTIL_Constants.EMAIL_DATATYPE.equalsIgnoreCase(fieldType) || 
                    UTIL_Constants.PHONE_TYPE.equalsIgnoreCase(fieldType) || 
                        UTIL_Constants.TEXT_AREA_DATATYPE.equalsIgnoreCase(fieldType) || 
                            UTIL_Constants.STRING_DATATYPE.equalsIgnoreCase(fieldType) || 
                                UTIL_Constants.URL_DATATYPE.equalsIgnoreCase(fieldType) ||
                                    UTIL_Constants.ADDRESS_TYPE.equalsIgnoreCase(fieldType) || 
                                        UTIL_Constants.ID_TYPE.equalsIgnoreCase(fieldType) ||
                                            UTIL_Constants.ENCRYPTED_STRING_DATATYPE.equalsIgnoreCase(fieldType))){
                    buildTextOperatorOptions();//Call buildTextOperatorOptions to add operators for the field types
                }else if(UTIL_Constants.DOUBLE_DATATYPE.equalsIgnoreCase(fieldType) ||
                            UTIL_Constants.INTEGER_DATATYPE.equalsIgnoreCase(fieldType) ||
                                UTIL_Constants.NUMBER_DATATYPE.equalsIgnoreCase(fieldType) ||
                                                UTIL_Constants.CURRENCY_DATATYPE.equalsIgnoreCase(fieldType)) {
                    buildIntegerOperatorOptions();
                }else if(UTIL_Constants.DATE_DATATYPE.equalsIgnoreCase(fieldType) || 
                                        UTIL_Constants.DATE_TIME.equalsIgnoreCase(fieldType)){
                    buildDateTimeOperatorOptions(); //Call buildDateTimeOperatorOptions to add operators for the field types
                     //checking for record type field and adding the values in picklist.                
                }else if(UTIL_Constants.RECORD_TYPE_ID.equalsIgnoreCase(this.fieldAPIName)){                    
                    buildRecordTypeValueOptions();//Call buildRecordTypeValueOptions to add operators for the field types 
                }
                if(UTIL_Constants.PICKLIST_DATATYPE.equalsIgnoreCase(fieldType)){
                    //Call buildMultiSelectValueOptions to add criteria values for the field types
                    buildMultiSelectValueOptions(); 
                    //Call buildGenericOperators to add operators for the field types
                    buildGenericOperators();
                }else if(UTIL_Constants.MULTI_PICKLIST_DATATYPE.equalsIgnoreCase(fieldType)) {
                    operatorOptions = new List<selectOption>();
                    operatorOptions.add(new selectOption(UTIL_Constants.IN_OPERATOR,
                                                            UTIL_Constants.IN_OPERATOR));
                }else if(UTIL_Constants.CHECKBOX_TYPE.equalsIgnoreCase(fieldType)) {
                    buildCheckBoxValueOptions();//Call buildCheckBoxValueOptions to add criteria values for the field types 
                }
            }
    }
    
  /**
    * @Method <Getter for ID>
    * @param  <NA>  
    * @return <ID>
    */
    public ID getId() { 
        return this.id; 
    }
     
  /** 
    * @MethodName <buildGenericOperators>
    * @Description <Helper Method for fireChangeInField() >
    * @param  <NA>
    * @return <List<selectOption>operatorOptions>   
    */
    private List<SelectOption> buildGenericOperators(){
        operatorOptions = new List<selectOption>();
        operatorOptions.add(new selectOption(UTIL_Constants.EQUALS_OPERATOR,
                                                UTIL_Constants.EQUALS_OPERATOR));
        operatorOptions.add(new selectOption(UTIL_Constants.NOT_EQUALS_OPERATOR, 
                                                UTIL_Constants.NOT_EQUALS_OPERATOR));
        return operatorOptions;
    }
    
  /** 
    * @MethodName <buildTextOperatorOptions>
    * @Description <Helper Method for fireChangeInField() >
    * @param <NA>
    * @return <List<selectOption>operatorOptions>   
    */
    private List<SelectOption> buildTextOperatorOptions(){
        buildGenericOperators();
        operatorOptions.add(new selectOption(UTIL_Constants.STARTS_WITH,UTIL_Constants.STARTS_WITH));
        operatorOptions.add(new selectOption(UTIL_Constants.NOT_START_WITH,UTIL_Constants.NOT_START_WITH));
        operatorOptions.add(new selectOption(UTIL_Constants.ENDS_WITH,UTIL_Constants.ENDS_WITH));
        operatorOptions.add(new selectOption(UTIL_Constants.NOT_END_WITH,UTIL_Constants.NOT_END_WITH));
        operatorOptions.add(new selectOption(UTIL_Constants.CONTAINS_OPERATOR,
                                                UTIL_Constants.CONTAINS_OPERATOR));
        operatorOptions.add(new selectOption(UTIL_Constants.NOT_CONTAINS_OPERATOR,
                                                UTIL_Constants.NOT_CONTAINS_OPERATOR));
        operatorOptions.add(new selectOption(UTIL_Constants.REGEX_OPERATOR,UTIL_Constants.REGEX_OPERATOR));
        operatorOptions.add(new selectOption(UTIL_Constants.NOT_REGEX_OPERATOR,
                                                UTIL_Constants.NOT_REGEX_OPERATOR));
        operatorOptions.add(new selectOption(UTIL_Constants.IN_OPERATOR,UTIL_Constants.IN_OPERATOR));
        return operatorOptions;
    }
    
  /** 
    * @MethodName <buildIntegerOperatorOptions>
    * @Description <Helper Method for fireChangeInField()>
    * @param <NA>
    * @return <List<selectOption>operatorOptions>   
    */
    private List<SelectOption> buildIntegerOperatorOptions(){
        buildGenericOperators();
        operatorOptions.add(new selectOption(UTIL_Constants.GREATER_THAN_OPERATOR,
                                                UTIL_Constants.GREATER_THAN_OPERATOR));
        operatorOptions.add(new selectOption(UTIL_Constants.LESS_THAN_OPERATOR,
                                                UTIL_Constants.LESS_THAN_OPERATOR));
        operatorOptions.add(new selectOption(UTIL_Constants.GREATER_THAN_EQUAL,
                                                UTIL_Constants.GREATER_THAN_EQUAL));
        operatorOptions.add(new selectOption(UTIL_Constants.LESS_THAN_EQUAL,
                                                UTIL_Constants.LESS_THAN_EQUAL));
        operatorOptions.add(new selectOption(UTIL_Constants.REGEX_OPERATOR,
                                                UTIL_Constants.REGEX_OPERATOR));
        operatorOptions.add(new selectOption(UTIL_Constants.NOT_REGEX_OPERATOR,
                                                UTIL_Constants.NOT_REGEX_OPERATOR));
        return operatorOptions;
    }
    
  /** 
    * @MethodName <buildDateTimeOperatorOptions>
    * @Description <Helper Method for fireChangeInField() >
    * @param <NA>
    * @return <List<selectOption>operatorOptions>   
    */
    private List<SelectOption> buildDateTimeOperatorOptions(){
        buildGenericOperators();
        operatorOptions.add(new selectOption(UTIL_Constants.GREATER_THAN_OPERATOR,
                                                UTIL_Constants.GREATER_THAN_OPERATOR));
        operatorOptions.add(new selectOption(UTIL_Constants.LESS_THAN_OPERATOR,
                                                UTIL_Constants.LESS_THAN_OPERATOR));
        operatorOptions.add(new selectOption(UTIL_Constants.GREATER_THAN_EQUAL,
                                                UTIL_Constants.GREATER_THAN_EQUAL));
        operatorOptions.add(new selectOption(UTIL_Constants.LESS_THAN_EQUAL,
                                                UTIL_Constants.LESS_THAN_EQUAL));
        return operatorOptions;
    }
    
  /** 
    * @MethodName <buildRecordTypeValueOptions>
    * @Description <Helper Method for fireChangeInField()>
    * @param <NA>
    * @return <List<SelectOption>filterCriteriaValueOptions>   
    */
    private List<SelectOption> buildRecordTypeValueOptions(){
        buildGenericOperators();
        filterCriteriaValueOptions = new list<SelectOption>();
        map<String,Schema.sObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.DescribeSObjectResult objDescribe = schemaMap.get(this.objectName).getDescribe();
        // Returns a map that matches record labels to their associated record type
        map<String, Schema.RecordTypeInfo> schemaRtMap = objDescribe.getRecordTypeInfosByName();
        filterCriteriaValueOptions.add(new SelectOption(UTIL_Constants.NONE_VALUE, 
                                                            UTIL_Constants.NONE_VALUE));
        if(!schemaRtMap.isEmpty()){
            for(String sRecordTyp: schemaRtMap.keySet()){
                filterCriteriaValueOptions.add(new SelectOption( sRecordTyp, sRecordTyp));   
            }
        }
        return filterCriteriaValueOptions;
    }
    
  /** 
    *  @MethodName <buildMultiSelectValueOptions>
    *  @Description <Helper Method for fireChangeInField()>
    *  @param <NA>
    *  @return <List<SelectOption>filterCriteriaValueOptions>   
    */
    private List<SelectOption> buildMultiSelectValueOptions(){
        buildGenericOperators();
        filterCriteriaValueOptions = new list<SelectOption>();
        map<String,Schema.sObjectType> schemaMap = Schema.getGlobalDescribe();// Get the map of object type of the SObject.
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = schemaMap.get(this.objectName).getDescribe();
        map<String, Schema.SObjectField> fieldMapNew = objDescribe.fields.getMap();// Get a map of fields for the SObject
        // Get the list of picklist values for this field. 
        list<Schema.PicklistEntry> values = fieldMapNew.get(this.fieldAPIName).getDescribe().getPickListValues();
        filterCriteriaValueOptions.add(new SelectOption(UTIL_Constants.NONE_VALUE, 
                                                            UTIL_Constants.NONE_VALUE)); 
            for(Schema.PicklistEntry picklist : values){ 
                 filterCriteriaValueOptions.add(new SelectOption(picklist.getLabel(), picklist.getValue())); 
            }
        return filterCriteriaValueOptions;
    }
    
  /** 
    * @MethodName <buildCheckBoxValueOptions>
    * @Description <Helper Method for fireChangeInField()>
    * @param <NA>
    * @return <List<SelectOption>filterCriteriaValueOptions>   
    */
    private List<SelectOption> buildCheckBoxValueOptions(){
        buildGenericOperators();
        filterCriteriaValueOptions = new list<SelectOption>();
        filterCriteriaValueOptions.add(new SelectOption(UTIL_Constants.TRUE_VALUE,
                                                            UTIL_Constants.TRUE_VALUE));
        filterCriteriaValueOptions.add(new SelectOption(UTIL_Constants.FALSE_VALUE, 
                                                            UTIL_Constants.FALSE_VALUE));
        return filterCriteriaValueOptions;
    }
    
  /** 
    * @MethodName <setDeleted>
    * @Description <Setter method for Deleted>
    * @param <NA>
    * @return <void>   
    */
    public void setDeleted() {
        this.isDeleted = true;
    }
    
  /** 
    * @MethodName <getIsDeleted>
    * @Description <Getter method for Deleted>
    * @param <NA>
    * @return <boolean>   
    */
    public boolean getIsDeleted() { 
        return this.isDeleted; 
    }
}