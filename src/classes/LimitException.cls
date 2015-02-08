global Class LimitException extends Exception{

    global String errMsg{get;set;}
    
    global LimitException (String errMsg,Integer lt){
        errMsg = 'DML Limit Has Been Exceeded';
    } 
    


}