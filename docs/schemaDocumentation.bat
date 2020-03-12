echo off
cd "..\deployed\schema\"
for /R %%i in (*.xsd) do "C:\Program Files\Oxygen XML Editor 20.1\schemaDocumentation.bat" %%i   -cfg:%~dp0/schemaDocExportSettings.xml
