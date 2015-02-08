trigger updateAccountWithoutValError on Account (before insert) {
for (Account obj: trigger.new){
    obj.AccountNumber= 'hello';
}
}