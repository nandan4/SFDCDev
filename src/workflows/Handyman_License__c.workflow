<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set License Name</fullName>
        <description>Set the License Name field on the credential to the contents of the License picklist.</description>
        <field>Name</field>
        <formula>TEXT(License__c)</formula>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set License Name</fullName>
        <actions>
            <name>Set License Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Handyman_License__c.License__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Set the License Name field on the credential to the contents of the License picklist.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
