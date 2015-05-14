trigger shipmentStatusUpd on Airway_Shipment__c (before update) {
    List<Airway_Shipment__c> airways = Trigger.new;
    
    for(Airway_Shipment__c  airway : airways )
    {   
        if(airway.Arrival_Date__c !=null){  
            airway.status__c  = 'Under Clearance';
            airway.Status_Update_Date__c = date.today();
        }
        if(airway.Arrival_Date__c !=null && airway.Inbond_Date__c !=null){  
            airway.status__c  = 'Inbonding Done';        
            airway.Status_Update_Date__c = date.today();            
        }
        if(airway.Arrival_Date__c !=null && airway.Inbond_Date__c !=null && airway.Lbl_end_dt__c !=null){  
            airway.status__c  = 'Labeling Done';
            airway.Status_Update_Date__c = date.today();            
        }
        if(airway.Arrival_Date__c !=null && airway.Inbond_Date__c !=null && airway.Lbl_end_dt__c !=null && airway.Exbond_Date__c !=null){  
            airway.status__c  = 'Exbonding done';
            airway.Status_Update_Date__c = date.today();            
        }
        if(airway.Arrival_Date__c !=null && airway.Inbond_Date__c !=null && airway.Lbl_end_dt__c !=null && airway.Exbond_Date__c !=null && airway.Receipting_in_system__c !=null){  
            airway.status__c  = 'GR in system done';
            airway.Status_Update_Date__c = date.today();            
        }
    }
}