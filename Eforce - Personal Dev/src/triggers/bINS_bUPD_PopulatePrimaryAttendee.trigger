trigger bINS_bUPD_PopulatePrimaryAttendee on Call__c (before insert, before update) {
    //for Time of territory recordtype, populate the primary Attendee with the special account
    String totActivityType = System.Label.TOT_RecordType;
    List<Account> splAccount = new List<Account>();
    // splAccount = [select Id from account where name =: label.Special_Account limit 1];
    system.debug('>>>>>check ID >>>>>'+ splAccount);
    
    List<Call__c> lstCall = Trigger.New;
    for(Call__c callVar: lstCall){
        if(callVar.Activity_Type__c == totActivityType){
            if(Prepopulate_Accounts__c.getInstance(callVar.country__c).TOT_Account_ID__c != null)
                callVar.Account__c = Prepopulate_Accounts__c.getInstance(callVar.country__c).TOT_Account_ID__c;        
        }else if(callVar.Activity_Type__c == 'Workshop'){
            if(Prepopulate_Accounts__c.getInstance(callVar.country__c).workshop_account_id__c != null)
                callVar.Account__c = Prepopulate_Accounts__c.getInstance(callVar.country__c).workshop_account_id__c;
        }
    }   
}