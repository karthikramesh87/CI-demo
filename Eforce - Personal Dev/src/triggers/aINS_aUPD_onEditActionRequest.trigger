/**
Author      : Cognizant
Date        : 8/11/2012
Description : Trigger used to Assign Action Request record for Approval Process & 
                Update the corresponding Account record with the approved values
*/
trigger aINS_aUPD_onEditActionRequest on ActionRequest__c (after insert, after update) {

// submit the action request for approval as soon as it is created.
    if(Trigger.isInsert){
        system.debug('--- In Insert Block ---');
        for(ActionRequest__c arObj : Trigger.New){
            Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
            approvalRequest.setComments('Submitted updates on Account for approval');
            approvalRequest.setObjectId(arObj.Id);
            Approval.ProcessResult approvalProcess = Approval.process(approvalRequest);
        }
    }else
        // on approval/rejection of actionRequest record
        if(Trigger.isUpdate){
            // when status of ActionRequest record is updated
            
            List<Account> accountList = new List<Account>();
            List<ActionRequestItem__c> arItemList = new List<ActionRequestItem__c>();
            Set<String> accountIdSet = new Set<String>();
            
            for(Integer i=0;i < Trigger.New.size(); i++){
                //fetching records for which the status has been changed to approved or rejected.
                if(Trigger.Old[i].Status__c != Trigger.New[i].Status__c && Trigger.New[i].Status__c != 'Pending'){
                    accountIdSet.add(Trigger.New[i].Account__c);
                }
            }
            
            Map<Id,Account> accountMap = new Map<Id, Account>();
            for(Account acc: [select Id from Account where Id in : accountIdSet]){
                accountMap.put(acc.Id, acc);
            }
            
            List<ActionRequestItem__c> aReqItemList = [select Field_Name__c, New_Value__c, Field_Type__c, ActionRequest__c from ActionRequestItem__c where ActionRequest__r.Id in :Trigger.newMap.keyset()];
            
            for(ActionRequest__c tempAr : Trigger.New){
                //for request whcih has been approved.
                if(tempAr.Status__c == 'Approved'){
                    //fetch the associated account records from the map
                    Account account = accountMap.get(tempAr.Account__c);
                    if(account != null){
                        if(aReqItemList != null && aReqItemList.size() > 0){
                             for(ActionRequestItem__c aReqItem : aReqItemList){
                                 if(aReqItem.ActionRequest__c == tempAr.Id){
                                     if(aReqItem.Field_Type__c == 'Integer')
                                         account.put(aReqItem.Field_Name__c,Integer.valueOf(aReqItem.New_Value__c));
                                      else if(aReqItem.Field_Type__c == 'Double')
                                         account.put(aReqItem.Field_Name__c,Double.valueOf(aReqItem.New_Value__c));
                                      else if(aReqItem.Field_Type__c == 'Date')
                                         account.put(aReqItem.Field_Name__c,Date.valueOf(aReqItem.New_Value__c));
                                      else if(aReqItem.Field_Type__c == 'Boolean')
                                         account.put(aReqItem.Field_Name__c,Boolean.valueOf(aReqItem.New_Value__c));
                                      else 
                                         account.put(aReqItem.Field_Name__c,aReqItem.New_Value__c);                       
                                 }    
                             }
                             account.status__c = 'Approved';
                        }
                        accountList.add(account);
                    }
                }else{
                    //for rejected requests.
                    if(tempAr.Status__c == 'Approved'){
                        //fetch the associated account
                        Account account = accountMap.get(tempAr.Account__c);
                        if(account != null){
                            account.status__c = 'Rejected';
                            accountList.add(account);
                    }
                }
            }
            if(accountList != null && accountList.size() > 0){
                update accountList;
            }
        }
    }
}