/**
  * @Author      Accenture IDC Team 
  * @CreatedDate 04/29/2013
  * @Description Interface which the Validation Rule Setup controller
  *              (i.e. VFC_CustomVRCreateEditController) will use for its all Wrapper methods.
  * @Version     0.1
  */
public interface ICreateRuleWrapper {
    
  /** 
    * @Method Get a copy of the filter criteria’s to EDIT by the controller or using class.
    * @param  NA 
    * @return List of Wrapper_FilterCriteria
    */
    List<Wrapper_RuleCriteria> getFilterCriteriasToEdit();
    
  /** 
    * @Method    Validate all the filter criteria’s and generic information.
    * @param     LIST<Wrapper_CustomVRFilterCriteria> wrapFCList
    * @return    Error Message String if any errors found. 
    */      
    String checkSyntax(List<Wrapper_RuleCriteria> wrapFCList);

  /** 
    * @Method Setter for description
    * @param  Boolean 
    * @return void
    */
    void setIsActive(Boolean isActive);
    
  /**
    * @Method Getter of Active flag
    * @param  NA 
    *   @return Boolean
    */  
    Boolean getIsActive();
        
  /** 
    * @Method Setter for validation rule name
    * @param  String 
    * @return void
    */
    void setRuleName(String ruleName);

  /** 
    * @Method Get the name of the validation rule.
    * @param  NA 
    *   @return String – validation Rule Name 
    */  
    String getRuleName();

  /** 
    * @Method Setter for Object name
    * @param  String 
    * @return void
    */
    void setObjectName(String objectName);
    
  /** 
    * @Method Get the name of the object API for this validation rule
    * @param  NA 
    * @return String – object API name
    */
    String getObjectName();      

  /**
    * @Method Get all the Field Names
    * @param  NA  
    *   @return list<String>
    */  
    list<String> extractFieldNames();
    
  /**
    * @Method Get all the operators
    * @param  NA  
    *   @return String
    */
    String getOperator();
     
  /**
    * @Method setter for operators
    * @param  String  
    * @return void
    */
    void setOperator(String operator);
     
       
  /** 
    * @Method  saveChanges
    * @Description Method called from the controller class to save changes
    * @param   <List<Wrapper_CustomVRFilterCriteria> listOfFilterCriteria>
    * @return  void
    */
    void saveChanges(List<Wrapper_RuleCriteria> listOfFilterCriteria);        

   /**
     * @Method Getter for ID
     * @param  NA  
     * @return String 
     */
     String getId();        
}