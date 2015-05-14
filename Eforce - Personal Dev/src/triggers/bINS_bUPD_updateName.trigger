trigger bINS_bUPD_updateName on Account (before insert,before Update) {
    for (Account acc : Trigger.new) {
        //acc.Salutation=Account.Salutation__c;
        //acc.First_Name=Account.First_Name__c;
        //acc.Last_Name=Account.Last_Name__c;
    }
}