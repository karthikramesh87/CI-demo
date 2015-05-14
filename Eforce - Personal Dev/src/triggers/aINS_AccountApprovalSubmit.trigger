/**
Author      : Cognizant
Date        : 8/11/2012
Description : Trigger used to Assign Account record for Approval Process
*/

trigger aINS_AccountApprovalSubmit on Account (after insert) {
    if(Trigger.isInsert){
        List<Approval.ProcessSubmitRequest> apRegList = new List<Approval.ProcessSubmitRequest>();
        Map<Id,RecordType> accRecTypes = new Map<Id,RecordType>([select Id from RecordType where SobjectType='Account'
                                            and IsActive=true
                                            and Name in ('Hospital','TH-Hospital','IN-Hospital','PH-Hospital','SG-Hospital','VN-Hospital')]);     
        for(Account tempAccount: Trigger.New){
            if(accRecTypes.get(tempAccount.RecordTypeId) != null){
                Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                approvalRequest.setComments('Submitted for Approval');
                approvalRequest.setObjectId(tempAccount.Id);
                apRegList.add(approvalRequest);        
            }
        }
        if(apRegList != null && apRegList.size() > 0){
            system.debug('Checksize' + apRegList.size());
            Approval.ProcessResult[] approvalProcess = Approval.process(apRegList);
        }                                             
    }
}