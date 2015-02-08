@RestResource(urlmapping = '/RestSampleService')
global class RestSampleService {
    
    @HttpGet
    global Static List<Account> retrieveAccounts(){
        return [SELECT Id,Name FROM Account];
    }
}