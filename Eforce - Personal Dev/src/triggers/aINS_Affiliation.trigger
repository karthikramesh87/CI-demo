/**
Author      : Cognizant
Date        : 16/11/2012
Description : Trigger used to submit account record for approval
*/


trigger aINS_Affiliation on Affiliation__c(after insert){

    Set<ID> customerIdSet = new Set<ID>();
    for(Affiliation__c tempAffiliation : Trigger.New){
        customerIdSet.add(tempAffiliation.NonHospital__c);
    }
    
    List<Account> accList = [Select Id, Name, IsPersonAccount, Status__c from Account where Id in: customerIdSet];
    List<Approval.ProcessSubmitRequest> apRegList = new List<Approval.ProcessSubmitRequest>();
    
    for(Account acc : accList){
        if(String.isBlank(acc.Status__c)){
            Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
            approvalRequest.setComments('Submitted for Approval');
            approvalRequest.setObjectId(acc.Id);
            apRegList.add(approvalRequest);
        }
    }
    
    if(apRegList != null && apRegList.size() > 0 ) {
        Approval.ProcessResult[] approvalProcess = Approval.process(apRegList);
    }    
}