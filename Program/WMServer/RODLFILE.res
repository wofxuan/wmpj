        ��  ��                  �  0   ��
 R O D L F I L E                     <?xml version="1.0" encoding="utf-8"?>
<Library Name="WMServer" UID="{EA432636-8BB5-43CF-99A1-A539BD51F630}" Version="3.0">
<Services>
<Service Name="WMFBData" UID="{CA1F52F9-417A-4786-A07B-D08E5F395E50}">
<Interfaces>
<Interface Name="Default" UID="{A2D40E20-9126-4015-A42B-B5C162767B59}">
<Documentation><![CDATA[Service WMServer. This service has been automatically generated using the RODL template you can find in the Templates directory.]]></Documentation>
<Operations>
<Operation Name="Sum" UID="{ABDD35B7-4B3F-4ACA-BCE2-2B5884D2CC1B}">
<Parameters>
<Parameter Name="Result" DataType="Integer" Flag="Result">
</Parameter>
<Parameter Name="A" DataType="Integer" Flag="In" >
</Parameter>
<Parameter Name="B" DataType="Integer" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="GetServerTime" UID="{B36CDC2A-17A0-4A9A-AA4D-FFFA1EE16567}">
<Parameters>
<Parameter Name="Result" DataType="DateTime" Flag="Result">
</Parameter>
</Parameters>
</Operation>
<Operation Name="QuerySQL" UID="{32720E2D-F9BB-4924-A13B-11A1F3BA1EA6}">
<Parameters>
<Parameter Name="Result" DataType="Integer" Flag="Result">
</Parameter>
<Parameter Name="ASQL" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="ABackData" DataType="OleVariant" Flag="InOut" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="OpenSQL" UID="{1D0B0A43-0149-4992-8A7B-0515205E800D}">
<Parameters>
<Parameter Name="Result" DataType="Integer" Flag="Result">
</Parameter>
<Parameter Name="ASQL" DataType="AnsiString" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="ExecuteProc" UID="{372E80F2-B5ED-4A06-BF0D-E180C5F64E39}">
<Parameters>
<Parameter Name="Result" DataType="Integer" Flag="Result">
</Parameter>
<Parameter Name="AInputParams" DataType="OleVariant" Flag="In" >
</Parameter>
<Parameter Name="AOutParams" DataType="OleVariant" Flag="Out" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="ExecuteProcBackData" UID="{74A33646-AD24-4594-A1E8-F37794EE1317}">
<Parameters>
<Parameter Name="Result" DataType="Integer" Flag="Result">
</Parameter>
<Parameter Name="AInputParams" DataType="OleVariant" Flag="In" >
</Parameter>
<Parameter Name="AOutParams" DataType="OleVariant" Flag="Out" >
</Parameter>
<Parameter Name="ABackData" DataType="OleVariant" Flag="InOut" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="SaveBill" UID="{EEE3D8D3-C08D-4C77-833E-F4FF49E12D19}">
<Parameters>
<Parameter Name="Result" DataType="Integer" Flag="Result">
</Parameter>
<Parameter Name="ABillData" DataType="OleVariant" Flag="In" >
</Parameter>
<Parameter Name="AOutPutData" DataType="OleVariant" Flag="InOut" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="Login" UID="{F2BD0A67-C132-430A-9E55-9B09D9F0EE42}">
<Parameters>
<Parameter Name="Result" DataType="Integer" Flag="Result">
</Parameter>
<Parameter Name="AUserName" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="AUserPSW" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="AMsg" DataType="AnsiString" Flag="InOut" >
</Parameter>
</Parameters>
</Operation>
</Operations>
</Interface>
</Interfaces>
</Service>
</Services>
<Structs>
</Structs>
<Enums>
</Enums>
<Arrays>
</Arrays>
</Library>
