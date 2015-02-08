/**
  * @author       : candidate@408970advdev.org
  * @date         : 21/12/2014
  * @description  : Utility class for Constants
  */ 
public without sharing class Constants{
    
    // Constants for Test Class
    public static final String ENCODE_KEY = 'UTF-8';
    public static final String TIME_ZONE = 'America/Los_Angeles';
    public static final String LOCALE_KEY = 'en_US';
    public static final String USER_POSTFIX = '@advdev.org';
    public static final String ADMIN_PROFILE = 'System Administrator';
    public static final String STD_PROFILE = 'Standard User';
    
    // Constants for HandymanLicenseHelper class
    public static final String CHATTER_GROUP_NAME = 'Handyman Licenses';
    public static final String TYPE_TEXT_POST = 'TextPost';
    public static final String MSG_DOT = '. ';
    public static final String WHITE_SPACE = ' ';
    
    // Constants for HandymanExtension class
    public static final String URL_PARAM_USERID = 'sfdc.userId';
    public static final String URL_PARAM_ID = 'id';
    
    // Constants for HandymanServiceHelper class
    public static final String GET = 'GET';
    public static final String RESP_SUCCESS = 'OK';
    public static final String CONTENT_TYPE = 'Content-Type';
    public static final String TEXT_XML = 'text/xml';
    public static final String CLASS_LIC_INFO = 'licenseInfoClass';
    public static final String CLASS_LIC_NAME = 'licenseNameClass';
    public static final String CLASS_LIC_DATE = 'licenseDateClass';
    public static final String CLASS_LIC_CONTRACT = 'contractorClass';
    public static final String ROW_TAG = 'tr';
    public static final String COL_TAG = 'td';
    public static final String SPAN_TAG = 'span';
    public static final String COMMA = ',';
    public static final String EMPTY_STRING = '';
    public static final Map<String,Integer> MONTHMAP = new Map<String, Integer>{'January' => 1,
                                                                        'February' => 2,
                                                                        'March' => 3,
                                                                        'Apri' => 4,
                                                                        'May' => 5,
                                                                        'June' => 6,
                                                                        'July' => 7,
                                                                        'August' => 8,
                                                                        'September' => 9,
                                                                        'October' => 10,
                                                                        'November' => 11,
                                                                        'December' => 12
                                                                    };
}