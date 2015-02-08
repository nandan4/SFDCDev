/**
  *  @Author      : ATL Team
  *  @Name        : ApexRulesV3_AvoidSOSLInjection
  *  @Date        : 29/12/2013 
  *  @Description : Avoid SOSL Injection - Priority P1 - Design        
*/
public class ApexRulesV3_AvoidSOSLInjection {
    public String name {get;set;}
    
    /**
      * Bad Practice: Method shows bad practice of using input parameter without escaping single quotes before using in SOSL.        
      */
    public PageReference queryBad() {   
        String qrString = 'SELECT Id FROM Contact WHERE ' +
            '(IsDeleted = false and Name like \'%' + name + '%\')';
        System.debug('** qrString ==>'+ qrString );
        List<Contact> result = Database.query(qrString); 
        System.debug('** result ==>'+ result );
        
        /*    
        String qryString = 'FIND\'Ac\'IN ALL FIELDS RETURNING Account(id,name WHERE Name like \'%'+ name+ '%\'),Contact, Lead';
        System.debug('** qryString ==>'+ qryString );
        List<List<SObject>> searchList = search.query(qryString );          
        System.debug('** searchList ==>'+ searchList); */
        return null;
    }
    
    /**
      * Good Practice: Method shows good practice of using input parameter with escaping single quotes before using in SOSL.        
      */
    public PageReference queryGood() {
        String nameVal = String.escapeSingleQuotes(name);
        System.debug('** nameVal ==>'+ nameVal );
        /*
        String qrString = 'SELECT Id FROM Contact WHERE ' +
            '(IsDeleted = false and Name like \'%' + nameVal + '%\')';
        List<Contact> result = Database.query(qrString);
        System.debug('** result ==>'+ result );
        nameVal = '%' + name + '%';
        System.debug('** nameVal ==>'+ nameVal );
        result = [SELECT Id FROM Contact WHERE (IsDeleted = false and Name like :nameVal )];
        System.debug('** result ==>'+ result );
        */
        nameVal = '%' + name + '%';
        String qryString = 'FIND\'Ac*\'IN ALL FIELDS RETURNING Account(id,name WHERE Name like \'%'+ nameVal + '%\'),Contact, Lead';
        System.debug('** qryString ==>'+ qryString );
        List<List<SObject>> searchList = search.query(qryString );
        System.debug('** searchList ==>'+ searchList); 
        searchList = [FIND 'te*' IN ALL FIELDS RETURNING Account(id,name WHERE Name like : nameVal),Contact, Lead];
        System.debug('** searchList ==>'+ searchList); 
        return null;
    }
}