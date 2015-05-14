/**
Author      : Cognizant
Date        : 8/11/2012
Description : Controller used for Edit Customer Details
**/

public class CustomerEditController{
    
    public Account account{set;get;}
    public Account bfUpdAcc{set;get;}
    public List<SelectOption> fielToUpdList{get;set;}

    public List<InnerClass> innerList{set;get;}
    public Map<String,String> fieldMap = new Map<String,String>();
    public Boolean editFlag{set;get;}
    public String selectedField{set;get;}
    
    private String recType;
    private List<String> fieldNameList;
            
    public CustomerEditController(ApexPages.StandardController standardController)
    {
        String accId = ApexPages.CurrentPage().getParameters().get('id');
        
        //query record type to find out the field set
        recType = [Select id,recordtype.Name from account where id =: accId].recordtype.name;
        recType = recType.replaceAll( '\\-+', ''); 
        //remove space to generate field set name   
        recType = recType.replaceAll( '\\s+', '');        
        //generates field list from field set
        fielToUpdList = getFieldList();
        //prepare query from fields
        String accQuery = 'Select Id, Status__c ';
        for(String fName: fieldNameList)
        {
            accQuery = accQuery + ' , ' + fName;
        }
        accQuery = accQuery + ' from Account where Id = \''+accId+'\'';
        //query account record and store in 2 variable for comparison
        this.account = Database.Query(accQuery);
        bfUpdAcc = Database.Query(accQuery);
        
        if(innerList == null)
        {
            innerList = new List<InnerClass>();
        }
        
        if(this.account.Status__c == 'Pending Edit Approval' || this.account.Status__c == 'Pending' )
        {       
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.Customer_Edit_Error));
        }
         else
        {
        
        editFlag = true;
        //initialize the wrapper class    
        InnerClass innerClass = new InnerClass();         
        //initialize the wrapper list
        
        innerList.add(innerClass);
        }
    }
    
    public List<SelectOption> getFieldList(){
        List<SelectOption> options = new List<SelectOption>(); 
        fieldNameList = new List<String>();
        options.add(new SelectOption('','--Select--'));
        Map<String, Schema.FieldSet> FsMap = Schema.SObjectType.Account.FieldSets.getMap();
        system.debug('checkrecordtype' +recType);
        system.debug('fieldvalues' + FsMap);
        if(FsMap.get(recType) != null)
        {
            List<Schema.FieldSetMember> fsFieldList = FsMap.get(recType).getFields();
            
            
            //prepare the drop down using retrived fields
            for(Schema.FieldSetMember f : fsFieldList) 
            {
                options.add(new SelectOption(f.getFieldPath(),f.getLabel()));
                fieldNameList.add(f.getFieldPath());
                
                fieldMap.put(f.getFieldPath(),String.valueOf(f.getType())); 
            }
        }
        return options;
    }
    
    public PageReference addRow(){
    
        system.debug('--- CustomerEditController :: addRow() ---');
        if(innerList != null)
            innerList.add(new InnerClass());
        system.debug('--- CustomerEditController :: removeRow() :: innerList size ---'+innerList.size());
        return null;
    }
    
    public PageReference removeRow(){
    
        system.debug('--- CustomerEditController :: removeRow() ---');
        String rowNumber = ApexPages.currentPage().getParameters().get('rowNumber');
        system.debug('--- CustomerEditController :: removeRow() :: rowNumber ---'+rowNumber);
        if(innerList != null && rowNumber != null)
            innerList.remove(Integer.valueOf(rowNumber));
        system.debug('--- CustomerEditController :: removeRow() :: innerList size ---'+innerList.size());
        return null;
    }
    
    public PageReference backToDetailPage(){
    
        system.debug('--- CustomerEditController :: backToDetailPage() ---');
        String retURL = ApexPages.currentPage().getParameters().get('retURL');
        system.debug('--- CustomerEditController :: backToDetailPage() :: retURL ---'+retURL);
        PageReference pageRef = new PageReference('/'+retURL);
        return pageRef;
    }

    
    public PageReference saveDetails(){
        
        system.debug('--- CustomerEditController :: saveDetails() ---');
        ActionRequest__c aReq = new ActionRequest__c();
        aReq.Account__c = account.Id;
        aReq.Status__c = 'Pending for Approval';
        
        Savepoint sp = Database.setSavepoint();
        insert aReq;
        
        List<ActionRequestItem__c> aReqItemList = new List<ActionRequestItem__c>();

        ActionRequestItem__c aReqItem = null;
        
        for(String accField: fieldNameList)
        {
            if(account.get(accField) != bfUpdAcc.get(accField))
            {
                aReqItem = new ActionRequestItem__c();
                aReqItem.ActionRequest__c = aReq.Id;
                aReqItem.Field_Name__c = accField;
                aReqItem.New_Value__c = String.valueOf(account.get(accField));
                aReqItem.Field_Type__c = fieldMap.get(accField);
                aReqItem.Old_Value__c = String.valueOf(bfUpdAcc.get(accField));
                aReqItemList.add(aReqItem);
            }
        }
        
        System.debug('Prateek::'+aReqItemList.size()+' ::: ' +aReqItemList);
             if(aReqItemList != null && aReqItemList.size()>0)
             {
                 
                insert aReqItemList;
                Account acc = [select Id, Status__c from Account where Id=:account.Id];
                acc.Status__c = 'Pending Edit Approval';
                update acc;
            }
            else
            {
                Database.rollback(sp);
            }
        
        return backToDetailPage();
    }
     
    class Innerclass{
        public String fieldName{set;get;}
       }
   
}