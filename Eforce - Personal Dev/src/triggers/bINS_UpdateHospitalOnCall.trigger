/**
Author      : Cognizant
Date        : 19/11/2012
Description : Trigger used to fetch Hospital Name of Primary Attendee, associated with call
*/

trigger bINS_UpdateHospitalOnCall on Call__c (before insert, before update) {

    Set<Id> accIdSet = new Set<Id>();
    for(Call__c call: Trigger.New){
        //add call date with start time and end time.
        if(call.Call_Date__c != null && call.Call_Start_Time__c != null && call.Call_End_Time__c != null){
            system.debug('Checkdate' + call.Call_Date__c);
            
            Integer year = call.Call_Date__c.year();
            Integer month = call.Call_Date__c.month();
            Integer day = call.Call_Date__c.day();
            
            //for start time
            Integer starthour = Integer.valueOf(call.Call_Start_Time__c.split(':').get(0));
            Integer startmin = Integer.valueOf(call.Call_Start_Time__c.split(':').get(1).substring(0,2));
            if(call.Call_Start_Time__c.contains('PM')){
                if(!call.Call_Start_Time__c.contains('12'))
                    starthour = starthour+12;
            }
            
            //for end time
            Integer endhour = Integer.valueOf(call.Call_End_Time__c.split(':').get(0));
            Integer endmin = Integer.valueOf(call.Call_End_Time__c.split(':').get(1).substring(0,2));
            if(call.Call_End_Time__c.contains('PM')){
                if(!call.Call_End_Time__c.contains('12'))
                    endhour = endhour+12;
            }
            
            Datetime startDateTime = datetime.newInstance(year,month,day,starthour,startmin,0);
            Datetime endDateTime = datetime.newInstance(year,month,day,endhour,endmin,0);
            
            call.Start_Time__c = startDateTime;
            call.End_Time__c = endDateTime;
        }
        accIdSet.add(call.Account__c);
    }
    
    Map<Id, String> priHospMap = new Map<Id,String>();
    if(accIdSet != null && accIdSet.size()>0){
        for(Affiliation__c tempAff : [select Id, Name, Hospital__c, Hospital__r.Name, NonHospital__c from Affiliation__c where IsPrimary__c = true and NonHospital__c in : accIdSet]){
            priHospMap.put(tempAff.NonHospital__c, tempAff.Hospital__r.Name);
        }
    }
    
    if(priHospMap != null && priHospMap.size() > 0){
        for(Call__c call: Trigger.New){
            if(priHospMap.get(call.Account__c)!= null && priHospMap.size()>0){
                call.Hospital_Name__c = priHospMap.get(call.Account__c);
            }
        }
    }
}