<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update Invoice Field</fullName>
        <field>Status__c</field>
        <literalValue>Closed</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Test Rule</fullName>
        <actions>
            <name>Update Invoice Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(Name) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
