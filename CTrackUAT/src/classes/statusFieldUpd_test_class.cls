@isTest
private class statusFieldUpd_test_class {

   static testmethod void test_trigger(){
        Airway_shipment__c airway = new Airway_Shipment__c(Name = 'test1', arrival_date__c = Date.newInstance(2015 , 04 ,02), status__c = 'Under clearance', Status_Update_Date__c = Date.today());
        insert airway;
        
        Airway_shipment__c air = [SELECT status__c,Status_Update_Date__c FROM Airway_shipment__c WHERE Name = :airway.Name LIMIT 1];
        System.assertEquals(airway.status__c, air.status__c);
        System.assertEquals(airway.Status_Update_Date__c, air.Status_Update_Date__c);
        
        Airway_shipment__c airway1 = new Airway_Shipment__c(Name = 'test2', arrival_date__c = Date.newInstance(2015 , 04 ,02), Inbond_Date__c= Date.newInstance(2015 , 04 ,02), status__c = 'Inbonding done', Status_Update_Date__c = Date.today());
        insert airway1;
        
        Airway_shipment__c air1 = [SELECT status__c,Status_Update_Date__c FROM Airway_shipment__c WHERE Name = :airway1.Name LIMIT 1];
        System.assertEquals(airway1.status__c, air1.status__c);
        System.assertEquals(airway.Status_Update_Date__c, air.Status_Update_Date__c);
        
        Airway_shipment__c airway2 = new Airway_Shipment__c(Name = 'test3', arrival_date__c = Date.newInstance(2015 , 04 ,02), Inbond_Date__c= Date.newInstance(2015 , 04 ,03), Lbl_end_dt__c = Date.newInstance(2015 , 04 ,04), status__c = 'Labeling done', Status_Update_Date__c = Date.today());
        insert airway2;
        
        Airway_shipment__c air2 = [SELECT status__c,Status_Update_Date__c FROM Airway_shipment__c WHERE Name = :airway2.Name LIMIT 1];
        System.assertEquals(airway2.status__c, air2.status__c);
        System.assertEquals(airway.Status_Update_Date__c, air.Status_Update_Date__c);
        
        Airway_shipment__c airway3 = new Airway_Shipment__c(Name = 'test4', arrival_date__c = Date.newInstance(2015 , 04 ,02), Inbond_Date__c= Date.newInstance(2015 , 04 ,03), Lbl_end_dt__c = Date.newInstance(2015 , 04 ,04), Exbond_Date__c = Date.newInstance(2015 , 04 ,05), status__c = 'Exbonding done', Status_Update_Date__c = Date.today());
        insert airway3;
        
        Airway_shipment__c air3 = [SELECT status__c,Status_Update_Date__c FROM Airway_shipment__c WHERE Name = :airway3.Name LIMIT 1];
        System.assertEquals(airway3.status__c, air3.status__c);
        System.assertEquals(airway.Status_Update_Date__c, air.Status_Update_Date__c);
        
        Airway_shipment__c airway4 = new Airway_Shipment__c(Name = 'test5', arrival_date__c = Date.newInstance(2015 , 04 ,02), Inbond_Date__c= Date.newInstance(2015 , 04 ,03), Lbl_end_dt__c = Date.newInstance(2015 , 04 ,04), Exbond_Date__c = Date.newInstance(2015 , 04 ,05), Receipting_in_system__c = Date.newInstance(2015 , 04 ,06), status__c = 'GR in system done', Status_Update_Date__c = Date.today());
        insert airway4;

        Airway_shipment__c air4 = [SELECT status__c,Status_Update_Date__c FROM Airway_shipment__c WHERE Name = :airway4.Name LIMIT 1];
        System.assertEquals(airway4.status__c, air4.status__c);
        System.assertEquals(airway.Status_Update_Date__c, air.Status_Update_Date__c);
    }
}