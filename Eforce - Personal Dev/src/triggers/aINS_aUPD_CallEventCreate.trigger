/**
Author      : Cognizant
Date        : 12/11/2012
Description : Trigger used to create and update events that are associated with call
                used to create and update tasks that are associated with call
*/
trigger aINS_aUPD_CallEventCreate on Call__c (after insert, after update) {
    List<Event> eventsToCreate = new List<Event>();
    List<Event> eventsToUpdate = new List<Event>();
    List<Event> eventsToDelete = new List<Event>();
    List<Task> callRelatedTasks = new List<Task>();
    Set<Id> accountIdSet = new Set<Id>();
    Set<Id> callIdSet = new Set<Id>();
    // Map<Id, Account> accContactMap = new Map<Id,Account>();
    
    //prepares set of account and call id
    for(Call__c call: Trigger.new){
        accountIdSet.add(call.Account__c);
        callIdSet.add(call.Id);
    }
    
    Map<Id, Account> accMap = new Map<Id, Account>([select Id,Name,IsPersonAccount,PersonContactId from Account where Id in : accountIdSet ]);
    
    //on creation of new call create a corresponding event.
    if(Trigger.isInsert){
        for(Call__c call: Trigger.New){
            if(call.activity_type__c != 'Time Off Territory'){
                Event e = new Event();
                e.ActivityDate = call.Call_date__c;
                e.StartDateTime = call.Start_time__c;
                e.EndDatetime = call.End_Time__c;
                e.ownerId = call.Assigned_To__c;
                
                //set what id to the call record
                
                e.whatId = call.Id;
                e.IsReminderSet = true;
                e.ReminderDateTime = call.Start_Time__c.addMinutes(-15);
                e.Subject = 'Scheduled Call with ' + accMap.get(call.Account__c).Name;
                eventsToCreate.add(e);
            }
        }
        if(eventsToCreate != null && eventsToCreate.size() > 0 )
            insert eventsToCreate;
    }
     
    // when a call is updated
    
    if(Trigger.isUpdate){
        Map<Id,Task> taskMap = new Map<Id,Task>();
        Map<Id,Event> eventMap = new Map<Id, Event>();
        
        //find out events for the updated call
        for(Event callEvent: [select Id, WhatId from Event where WhatID in:callIdSet]){
            eventMap.put(callEvent.WhatId, callEvent);
        }
        
        for(Call__c call : Trigger.new){
            Call__c callOldVersion = Trigger.oldMap.get(call.Id);
            // delete the event associated with this call if status is cancelled
            
            if(callOldVersion.Status__c != null && call.Status__c != null){
                //prepare set of events that needs to be removed for cancelled calls
                if(!callOldVersion.Status__c.equalsIgnoreCase('Cancelled') && call.Status__c.equalsIgnoreCase('Cancelled')){
                    eventsToDelete.add(eventMap.get(call.Id));
                }else{
                    //for updated calls
                    //prepare set of events that needs to be updated.
                    if(callOldVersion.Start_Time__c != call.Start_Time__c || 
                    callOldVersion.End_Time__c != call.End_Time__c ||
                    callOldVersion.Call_Date__c != call.Call_Date__c ||
                    callOldVersion.Account__c != call.Account__c){
                        Event event = eventMap.get(call.Id);
                        if(event != null){
                            event.StartDateTime = call.Start_Time__c;
                            event.EndDateTime = call.End_Time__c;
                            event.ActivityDate = call.Call_Date__c;
                            event.OwnerId = call.Assigned_To__c;
                            event.WhoId = accMap.get(call.Account__c).PersonContactId;
                            event.Subject = 'Scheduled Call with' + accMap.get(call.Account__c).Name;
                            eventsToUpdate.add(event);
                        }
                    }
                    
                    //Create or update task regarding next call objective date for the call owner
                    /* if(call.Next_call_objective_date__c != null){
                            Task toDoTask = null;
                            if(taskMap != null && taskMap.get(call.Id) != null){
                                toDoTask = taskMap.get(call.Id);
                            }else{
                                toDoTask = new Task();
                                toDoTask.whatId = call.Id;
                            }    
                            
                            toDoTask.whoId = call.CreatedBy.Id;
                            toDoTask.Subject = 'Create a call for Next visit on ' + call.Next_Call_Objective_Date__c.format()+'with' + accMap.get(call.Account__c).Name;
                            toDoTask.Priority = 'High';
                            toDoTask.Status = 'Not Started';
                            toDoTask.ActivityDate = Date.newInstance(call.Next_call_Objective_date__c.year(), call.next_call_objective_date__c.month(), call.next_call_objective_date__c.day()-1);
                             toDoTask.IsReminderSet = true;
                        toDoTask.ReminderDateTime = call.Next_Call_Objective_Date__c.addDays(-1);
                        toDoTask.Description = call.Next_Call_Objective__c;
                        callRelatedTasks.add(toDoTask); 
                    }  */
                }
            } 
        }
        // perform DML
        if(eventstoUpdate != null && eventsToUpdate.size() > 0){
            update eventsToUpdate;
        }
        if(eventsToDelete != null && eventsToDelete.size() > 0){
            delete eventsToDelete;            
        }
    }
}