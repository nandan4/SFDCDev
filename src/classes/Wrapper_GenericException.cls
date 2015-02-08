/**
  * @Author      <Accenture IDC Team> 
  * @CreatedDate <>04/29/2013>
  * @Description <The result of every validation rule will be encapsulated in this wrapper class. 
                  To keep usage consistent and re-usable, this class also will be used for Checked-Exceptions.>
  * @Version     <0.1>
  */
public with sharing class Wrapper_GenericException extends Exception{
    
    private String errorMessageLabel;
    private String errorLocation = Wrapper_GenericException.ERROR_PAGE_TOP;
    private Exception handledExp;
    public static String ERROR_PAGE_TOP ='ERROR_PAGE_TOP';
    
   /**
     * @constructor <The result of every validation rule will be encapsulated in this wrapper class.
     *             To keep usage consistent and re-usable, this class also will be used for Checked-Exceptions.>
     * @param <String errorMessageLabel, String errorLocation>
     */
    public Wrapper_GenericException (String errorMessageLabel, String errorLocation){
        this.errorMessageLabel = errorMessageLabel;
        this.errorLocation = errorLocation;
    }

  /**
    * @constructor <Constructor for this class. This method will be used by Service classes or any usage classes which want to use this wrapper as a checked exception.>
    * @param       <Exception handledExp>
    */
    public Wrapper_GenericException(Exception handledExp, String errorMessageLabel){
        this.handledExp = handledExp;
        this.errorMessageLabel = errorMessageLabel;
    }
    
  /** 
    * @MethodName <getErrorMessageLabel>
    * @Description <Getter method for ErrorMessageLabel>
    * @param <NA>
    * @return <String>   
    */
    public String getErrorMessageLabel() {
        return errorMessageLabel;
    }
    
  /** 
    * @MethodName <getHandledExp>
    * @Description <Getter method for handledExp>
    * @param <NA>
    * @return <Exception>   
    */
    public Exception getHandledExp() {
        return handledExp;
    }
    
  /** 
    * @MethodName <getErrorLocation>
    * @Description <Getter method for errorLocation>
    * @param <NA>
    * @return <String>   
    */
    public String getErrorLocation() {
        return errorLocation;
    }
}