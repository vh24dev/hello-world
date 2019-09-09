<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_to_Kunde_14_days_before_Gerichtstermin</fullName>
        <description>Send Email to Kunde 14 days before "Gerichtstermin"</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Kunde__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DieselskandalLegalJaeger/DieselJaegerLegalDateReminderCustomer14</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Kunde_2_days_before_Gerichtstermin</fullName>
        <description>Send Email to Kunde 2 days before "Gerichtstermin"</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Kunde__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DieselskandalLegalJaeger/DieselJaegerLegalDateReminderCustomer2</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Terminsvertreter_14_days_before_Gerichtstermin</fullName>
        <description>Send Email to Terminsvertreter 14 days before "Gerichtstermin"</description>
        <protected>false</protected>
        <recipients>
            <field>Representative__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DieselskandalLegalJaeger/DieselJaegerLegalDateReminderRepresentative14</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Terminsvertreter_2_days_before_Gerichtstermin</fullName>
        <description>Send Email to Terminsvertreter 2 days before "Gerichtstermin"</description>
        <protected>false</protected>
        <recipients>
            <field>Representative__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DieselskandalLegalJaeger/DieselJaegerLegalDateReminderRepresentative2</template>
    </alerts>
</Workflow>
