/**
  * @author       : candidate@408970advdev.org
  * @date         : 28/12/2014
  * @description  : Helper class for HandymanExtension to make a service call to Handyman site
                    and parse the html response and return list of handyman licenses to extension.
  */ 
public with sharing class HandymanServiceHelper{
    
    /**
      * @description       This method is invoked from HandymanExtension to make a webservice call to
                           handyman site and fetch the licenses for user.
      * @param             contractId -  contractor id of user
      * @return            HandymanResponse
      * @throws            NA
      */ 
    public static HandymanResponse callHandymanService(String contractId){
        String endPoint = null;
        HandymanResponse resp = null;
        // verify if the contractor id sent from a extension is not blank before service call
        if(String.isNotBlank(contractId)){
            System.debug('** Label ==>'+ Label.HANDYMAN_URL);
            System.debug('** contractId ==>'+ contractId);          
            endPoint = Label.HANDYMAN_URL + contractId.replaceAll(Constants.WHITE_SPACE,Constants.EMPTY_STRING) ; // forming end point for a call
            System.debug('** contractId ==>'+ contractId);  
            try{
                HttpResponse response = invokeService(endPoint);    // invoke the webservice
                
                // verify if the service call is successful and parse the response
                if(200 == response.getStatusCode() && Constants.RESP_SUCCESS.equalsIgnoreCase(response.getStatus())){
                    resp = parseResponse(response.getXmlStreamReader());
                }
            }
            catch(System.CalloutException exp){
                resp = null;
            }
        }
        
        return resp;
    }
    
    /**
      * @description       This method is invoked from callHandymanService to make a HTTP request to 
                           endpoint and return HttpResponse.
      * @param             endPoint
      * @return            HttpResponse
      * @throws            NA
      */ 
    private static HttpResponse invokeService(String endPoint){
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndpoint(endPoint);
        httpReq.setMethod(Constants.GET);       // GET request
        HttpResponse httpResp = http.send(httpReq);
        httpResp.setHeader(Constants.CONTENT_TYPE,Constants.TEXT_XML); // setting content-type
        return httpResp ;
    }
    
    /**
      * @description       This method is invoked from parseResponse to get the corresponding number
                           for a month.
      * @param             month - name of month
      * @return            Integer
      * @throws            NA
      */ 
    private static Integer getMonthNumber(String month){
        return Constants.MONTHMAP.get(month);
    }
    
    /**
      * @description       This method is invoked from callHandymanService to get the parsed response of an HTML
                           from the Handyman site. HTML response is parsed to HandymanResponse formate which stores
                           contractor name and the list of licenses.
      * @param             reader - XMLStreamReader from the service response
      * @return            HandymanResponse
      * @throws            Method throws ParseError which is handled by try-catch block and is ignored as it is thrown
                           in parsing the response at the end which is not required for the business case.
      */ 
    private static HandymanResponse parseResponse(XmlStreamReader reader){
        HandymanResponse resp = new HandymanResponse();
        List<HandymanExtension.HandymanLicense> licenseList = new List<HandymanExtension.HandymanLicense>();
        List<String> dateVal = new List<String>();
        Integer dayVal = 0;
        HandymanExtension.HandymanLicense lic = null;
        String attr = null;
        // flags to detemine the row,column, licensename and date
        Boolean isRow = false;
        Boolean isCol = false;
        Boolean isLic = false;
        Boolean isLicDate = false;
        Boolean isContName = false;
        
        /* 
            Iterating through each tag till the last tag of the html response and determine if the tag is row and based on the 
            class attribute stored as license name and license date.
        */
        while(reader.hasNext()) {
            try {
                reader.next();  
                // check if the tag is the start tag of an element
                if(reader.geteventtype()== XmlTag.START_ELEMENT) {
                    // check if the tag is 'tr' and contains class attribute with value 'licenseInfoClass'
                    if( Constants.ROW_TAG.equalsIgnoreCase(reader.getlocalname()) && reader.getAttributeCount() > 0 
                        && Constants.CLASS_LIC_INFO.equalsIgnoreCase(reader.getAttributeValueAt(0))){
                        isRow = true;
                        lic = new HandymanExtension.HandymanLicense();  // for each row and new license is created
                    }
                    else if( Constants.COL_TAG.equalsIgnoreCase(reader.getlocalname()) ){
                        isCol = true;
                    }
                    // check if the tag is 'span' and contains class attribute with value 'contractorClass'
                    else if( Constants.SPAN_TAG.equalsIgnoreCase(reader.getlocalname()) && reader.getAttributeCount() > 0 
                            && Constants.CLASS_LIC_CONTRACT.equalsIgnoreCase(reader.getAttributeValueAt(0))){
                        isContName = true;                      
                    }
                }
                // check if the tag is end tag of an element
                else if(reader.geteventtype()== XmlTag.END_ELEMENT) {
                    // Reset flags if its end tag of row
                    if( Constants.ROW_TAG.equalsIgnoreCase(reader.getlocalname()) ){
                        isRow = false;
                        isCol = false;
                    }
                    // Reset column flag if its end tag of column
                    else if( Constants.COL_TAG.equalsIgnoreCase(reader.getlocalname()) ){
                        isCol = false;
                    }
                    // Reset contractor name flag if its end tag of span
                    else if( Constants.SPAN_TAG.equalsIgnoreCase(reader.getlocalname()) ){
                        isContName = false;
                    }
                }
                
                // If row & column flags are true, check if the span tag contains class attribute and its value is 'licenseNameClass' or 'licenseDateClass'               
                if(isRow && isCol && reader.geteventtype()== XmlTag.START_ELEMENT && Constants.SPAN_TAG.equalsIgnoreCase(reader.getlocalname())){
                    if(reader.getAttributeCount() > 0){
                        attr = reader.getAttributeValueAt(0);
                        if( Constants.CLASS_LIC_NAME.equalsIgnoreCase(attr) ){
                            isLic = true;   // setting flag that its license name
                        }
                        else if( Constants.CLASS_LIC_DATE.equalsIgnoreCase(attr) ){
                            isLicDate = true;   // setting flag that its license date
                            isLic = false;
                        }
                        else{
                            isLic = false;
                            isLicDate = false;
                        }
                    }
                }
                
                // Get the value if not blank and assign to license name and date
                if(isRow && isCol && reader.geteventtype() == XmlTag.CHARACTERS){
                    if(isLic && String.isNotBlank(reader.getText())){
                        lic.licenseName = reader.getText();
                    }
                    
                    // Date in a string format is converted to date using string methods and date methods
                    if(isLicDate && lic.licenseName != null && String.isNotBlank(reader.getText())){
                        dateVal = reader.getText().split(Constants.WHITE_SPACE);
                        dayVal = Integer.valueOf(dateVal[1].split(Constants.COMMA)[0]);
                        lic.licenseDate = Date.newInstance(Integer.valueOf(dateVal[2]),getMonthNumber(dateVal[0]),dayVal).format();
                        licenseList.add(lic);
                    }
                }
                
                // get the contractor name
                if(isContName && reader.geteventtype() == XmlTag.CHARACTERS){
                    resp.contractorName = reader.getText();
                }
            } 
            catch(Exception exp) {
                /*
                    On parsing the HTML response from Handyman site, there is an parse error for the content in script tag
                    at the end. With assumption that response from Handyman site is consistent, the parse error is ignored
                    as it is thrown for the content at the end. 
                */
                break;
            }
        }
        resp.licenseList = licenseList;     // set the list of handyman licenses for a user
        return resp;
    }
    
    /*
        Wrapper class stores contractor name and the list of handyman licenses for him returned from a service call to handyman site
        which will be returned to HandymanExtension.
    */
    public class HandymanResponse{
        public String contractorName ;
        public List<HandymanExtension.HandymanLicense> licenseList ;    // list of Handyman license wrapper for a contractor
    }
}