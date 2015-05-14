<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Affiliation Primary Account ID</fullName>
        <description>Used to Update Primary Account ID field in Affiliation object</description>
        <field>Primary_Account_Id__c</field>
        <formula>IF( IsPrimary__c = true, NonHospital__r.Id , null)</formula>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Used to get primary account id and updat</fullName>
        <description>Used to Update Primary Account ID field in Affiliation object</description>
        <field>Primary_Account_Id__c</field>
        <formula>IF( IsPrimary__c = true, NonHospital__r.Id , null)</formula>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Fetch Primary Account ID</fullName>
        <actions>
            <name>Affiliation Primary Account ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Affiliation__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Used to get primary account id and update Primary Account ID field in Affiliation object</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
