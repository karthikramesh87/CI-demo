<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>IsPLanned Field Update</fullName>
        <description>If days to call is greater than 1 then true, otherwise false</description>
        <field>IsPlanned__c</field>
        <literalValue>1</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update to complete status for TOT</fullName>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Change the status of TOT</fullName>
        <actions>
            <name>Update to complete status for TOT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Call__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Time Off Territory</value>
        </criteriaItems>
        <criteriaItems>
            <field>Call__c.Status__c</field>
            <operation>equals</operation>
            <value>Planned</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>IsPlanned of Call</fullName>
        <actions>
            <name>IsPLanned Field Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Call__c.Call_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Call__c.Call_Date__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>used to update IsPlanned field of Call which will represents whether call is planned or unplanned. If call is created more than 1 day prior to Call Date, then it is Planned call. Otherwise it is a Unplanned Call.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
