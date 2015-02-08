/*
    Author          : Nandan Narasappa
    Date Created    : 11/18/2012
    Description     : Custom Controller for VFP_StringExternalize
*/

public class TestGridController
{
    /* Variables */
    public static Boolean showBody {get;set;}   // Boolean variable for rendering apex component
    public static String classId {get;set;}     // variable for apex class Id
    public static list<String> classBody {get;set;} // variable for apex class Body
    public static list<String> codeBlock {get;set;} // variable for code creating custom setting
    public static list<String> extClass {get;set;}  // variable for apex class body with custom setting
    public static map<String,String> cSettingsMap = new map<String,String>();   // map with existing custom settings in an Organization    
    public static Integer count = 1;    // variable for last custom settings count in Organization
    public static ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There has been a System Error. Please Contact System Administrator.');  // Message variable for Error
    /* End of Variables */
    
    /* Constructor Starts */
    public TestGridController()
    {
        showBody = false;   // Set Render Variable to False
    }
    /* Constructor Ends */
    
    /*  @Method <This method externalizeString is used to remove Hardcoded strings from an Apex Class>
        @param <Method does not take any parameter>
        @return <Method doesnot return value>
        @throws exception - <Method is throwing exception which is handled by try-catch block>
    */
    public static void externalizeString()
    {
        /* Method Variables */
        ApexClass cls;  // variable for selected apex class        
        String lastSettingCount ;   // variable for last custom settings in Organization
        /* End of Method Variables */
        
        showBody = true;    // Set Render Variable to True
        try
        {           
            for(StaticStringCustomSettings__c cSetting : StaticStringCustomSettings__c.getAll().values())   // Iterate over existing custom settings in an Organization
            {
                cSettingsMap.put(cSetting.StaticStringValue__c,cSetting.Name);  // Map of Existing Custom Settings in an Organization
            }
            /* Get the Count of Last Custom Setting starting with CL */                             
            if(!cSettingsMap.isEmpty())
            {
                lastSettingCount = cSettingsMap.values()[0].startsWith('CL_')? cSettingsMap.values()[0].substringAfter('_'): '1';
                for(Integer i=1;i<cSettingsMap.values().size();i++)
                {
                    if(cSettingsMap.values()[i].startsWith('CL_'))  // Check whether last custom setting starts with CL
                    {
                        lastSettingCount = String.valueof(Math.max(Integer.valueOf(lastSettingCount) ,Integer.valueOf(cSettingsMap.values()[i].substringAfter('_')))) ;  // Gets Last Custom Setting Value
                    }
                }
                count = Integer.valueOf(lastSettingCount) + 1 ; // Set count to Last Value plus one
            }            
            cls = [SELECT body,name FROM ApexClass WHERE Id =: classId];    // Query Selected Class         
            classBody = cls.body.trim().split('\n');                        // Add Class Body to a List
            
            generateCSCode(cls);    // Generate Code for Custom Setting and Apex Class
            
            if(codeBlock.size() <= 2)
            {
                codeBlock.clear();  // Clear the CodeBlock list if Apex Class do not contain hard coded string
                codeBlock.add('No HardCoded Strings Found in Apex Class Or Existing Custom Setting with Same Value used :- '+ cls.Name);    // Add message that class do not contain hard coded strings
            }
        }
        catch(Exception exp)
        {
            ApexPages.addMessage(errMsg);   // Throw Error Message to the User if an Exception Occurs       
        }
    }
    
    /*  @Method <This method generateCSCode is used to generate Anonymous Code Block>
        @param <Method does not take any parameter>
        @return <Method doesnot return value>
        @throws exception - <Method is throwing exception which is handled by try-catch block>
    */
    public static void generateCSCode(ApexClass cls)
    {
        /* Method Variables */
        String hcStrg ;         // variable for hard coded string without quotes
        String hcStrgQuote ;    // variable for hard coded string with quotes
        String rplaceStg ;      // variable for extracted string replaced with custom setting
        list<String> hcStrgList = new list<String>();
        map<String,String> hcStringMap = new map<String,String>();
        /* End of Method Variables */
        
        codeBlock = new list<String>(); // Instantiate codeBlock list   
        extClass = new list<String>();  // Instantiate externalized apex class list
        codeBlock.add('List<StaticStringCustomSettings__c> customSettingList = new List<StaticStringCustomSettings__c>();');    // Add Creation of custom setting list
        
        try
        {
            for(String strg : classBody)    // Iterate over Apex Class Body
            {
                /* Check whether the Class contains AlphaSpace, comments or Strings */
                if(!String.isBlank(strg) && !strg.isAlphaSpace() && strg.contains('\'') && !strg.containsIgnoreCase('System.debug') && !strg.contains('//') && !strg.contains('/*') && !strg.contains('*/'))
                {
                    hcStrgQuote = strg.substring(strg.indexOf('\''), strg.lastIndexOf('\'')+1); // Extract hard coded string with quotes
                    hcStrg = strg.substring(strg.indexOf('\'')+1, strg.lastIndexOf('\'')+1);      // Extract hard coded string without quotes       
                    if(!String.isBlank(hcStrg) && hcStrg.contains('\''))
                    {
                        Integer matchNum = hcStrgQuote.countMatches('\'')/2 + 1 ;
                        for(Integer i=0; i<= matchNum; i++)
                        {
                            if(hcStrg.contains('\'\'')  && (hcStrg.substring(hcStrg.indexof('\'')+1,hcStrg.indexof('\'')+2).equals('\'')))
                            {
                                if(!String.isBlank(hcStrg.substring(0,hcStrg.indexof('\'')+1)))
                                {
                                    hcStrgList.add(hcStrg.substring(0,hcStrg.indexof('\'')+1));
                                    hcStrg = hcStrg.substringafter('\'\'').substringAfter(('\''));
                                }
                            }
                            else if(!String.isBlank(hcStrg))
                            {
                                if (hcStrg.contains('+') )
                                {
                                    if(!hcStrg.startswith('+') && (!String.isBlank(hcStrg.substring(0,hcStrg.indexof('\''))) ))
                                    {
                                        if((!String.isBlank(hcStrg.substring(0,hcStrg.indexof('+'))) ) && hcStrg.substring(0,hcStrg.indexof('+')).contains('\'') && !hcStrg.substring(hcStrg.indexof('+')-1,hcStrg.indexof('+')).equals('\''))
                                        {
                                            hcStrgList.add(hcStrg.substring(0,hcStrg.indexof('\''))) ;
                                        }
                                        else
                                        {
                                            hcStrgList.add(hcStrg.substring(0,hcStrg.indexof('+')-1)) ;
                                        }
                                        hcStrg = hcStrg.substringafter('\'').substringAfter(('\'')) ;
                                    }
                                    else
                                    {
                                        hcStrg = hcStrg.substringafter('\'');   
                                    }
                                }
                                else 
                                {                             
                                    if(!String.isBlank(hcStrg.substring(0,hcStrg.indexof('\''))) && hcStrg.contains('\\') )
                                    {
                                        String tmp = hcStrg.substring(hcStrg.indexof('\'')+1);
                                        hcStrgList.add(hcStrg.substring(0,tmp.indexof('\'')+2)) ;
                                    }
                                    else if(!String.isBlank(hcStrg.substring(0,hcStrg.indexof('\''))))
                                    {
                                        hcStrgList.add(hcStrg.substring(0,hcStrg.indexof('\''))) ; 
                                    }
                                    hcStrg = hcStrg.substringafter('\'').substringAfter(('\'')) ;
                                }
                            }
                        }
                    }
                    
                    for(String hcString : hcStrgList)
                    {
                        if(!String.isEmpty(hcString) && !String.isBlank(hcString) && !cSettingsMap.isEmpty())  // Check whether the custom setting map is empty & extracted string is not space 
                        {
                            if(!cSettingsMap.containsKey(hcString))   // Check whether the custom setting map contains the hard coded string
                            {
                                /* Code for Creating Custom Setting */
                                if(hcStringMap.containsKey(hcString))
                                {
                                    rplaceStg = hcStringMap.get(hcString);
                                    strg = strg.replace('\''+hcString+'\'',rplaceStg);   // Replace hard coded string with custom setting 
                                    System.debug('*** Get Replaced Line ==> '+strg);    
                                    
                                }
                                else
                                {
                                    codeBlock.add('StaticStringCustomSettings__c csObj'+count+' = new StaticStringCustomSettings__c(Name = \'CL_'+ count +'\', StaticStringValue__c = \''+ hcString + '\', Reference__c = \''+ cls.Name +'\');');    
                                    codeBlock.add('customSettingList.add(csObj'+count+');');                            
                                    rplaceStg = 'StaticStringCustomSettings__c.getInstance(\'CL_'+count+'\').StaticStringValue__c';
                                    count++;    // Increment count on creation of custom setting
                                    hcStringMap.put(hcString,rplaceStg);                // Add hard coded string and its custom setting code to a map
                                    strg = strg.replace('\''+hcString+'\'',rplaceStg);   // Replace hard coded string with custom setting  
                                    System.debug('*** Get Replaced Line ==> '+strg);                    
                                }
                            }
                            else
                            {                       
                                /* Replace the Hard Coded string with Custom setting */
                                rplaceStg = 'StaticStringCustomSettings__c.getInstance(\''+cSettingsMap.get(hcString)+'\').StaticStringValue__c'; 
                                strg = strg.replace('\''+hcString+'\'',rplaceStg);   // Replace hard coded string with custom setting                           
                                System.debug('*** Get Replaced Line ==> '+strg);
                            }
                        }
                        else
                        {
                            /* Code for Creating Custom Setting */
                            codeBlock.add('StaticStringCustomSettings__c csObj'+count+' = new StaticStringCustomSettings__c(Name = \'CL_'+ count +'\', StaticStringValue__c = \''+ hcString + '\', Reference__c = \''+ cls.Name +'\');');    
                            codeBlock.add('customSettingList.add(csObj'+count+');');
                            rplaceStg = 'StaticStringCustomSettings__c.getInstance(\'CL_'+count+'\').StaticStringValue__c';
                            count++;    // Increment count on creation of custom setting
                            hcStringMap.put(hcString,rplaceStg);                // Add hard coded string and its custom setting code to a map
                            strg = strg.replace('\''+hcString+'\'',rplaceStg);   // Replace hard coded string with custom setting   
                            System.debug('*** Get Replaced Line ==> '+strg);
                        }
                    }
                    extClass.add(strg); // Add the line of code to a list
                }
                else
                {
                    extClass.add(strg); // Add the line of code to a list
                }               
            }           
            codeBlock.add('Database.insert(customSettingList);');       // Add Insert statement for custom setting                      
        }
        catch(Exception exp)
        {
            ApexPages.addMessage(errMsg);   // Throw Error Message to the User if an Exception Occurs           
        }
    }
}