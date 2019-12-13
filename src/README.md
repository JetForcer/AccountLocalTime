# How to configure organization

## Deploy the metadata from the repository

	It is looks like a workaround, but I don't know another way to do it for now, so please deploy metadata with following order:_

	labels -> Account.object -> Opportunity.object -> classes -> aura, profiles, quickActions, staticresources, triggers, remoteSiteSettings

## Move custom components to layouts

	You may customize your layouts as you want, to do it, please follow steps as described below

	- Go to Setup -> Build -> Customize -> Opportunities -> Page Layouts -> Opportunity Layout -> Edit
	- On the top of the page
		- Select 'Fields', and then drag the 'Account Local Time' to "Opportunity Detail" place
		- Select 'Quick Actions', and then drag the 'Local time' to "Quick Actions in the Salesforce Classic Publisher" place
		- Select 'Mobile & Lightning Actions', and then drag the 'Customize local time' to "Salesforce Mobile and Lightning Experience Actions" place
		
## Configure My Domain

	Without it Lightning customization form will not work properly
	
	- Go to Setup -> Administer -> Domain Management -> My Domain, and then follow the instruction from Salesforce

## Activate Geocodes for Account Billing Address

	To enable values in Account.BillingLatitude and Account.BillingLongitude need to activate the Data Integration Rule
	
	- Setup -> Data Management -> Data Integration Rules
	- Open 'Geocodes for Account Billing Address' and click on 'Activate'
	
## Create Connected App, Auth. Provider and Named Credential:

    To avoid timeout errors when you use formula with geolocation, need to configure Connected App, Auth. Provider and Named Credential
    
###Step 1: Creating a Connected App
	
	- Build -> Create -> Apps -> Connected Apps related list -> New
	- Write a name: Timezonedb, then an email: example@example.com
	- Click on 'Enable OAuth Settings' checkbox
	- Write a Callback URL: https://localhost/dummy
	- In the 'Selected OAuth Scopes' choose 'Full access (Full)' and " refresh_token, offline_access"
	- Click on 'Save'		
	- Open the Timezonedb app, then copy 'Consumer Key' and 'Consumer Secret' to your notes.It is will be needed later.
		
###Step 2: Creating an Auth. Provider
	
	- Setup -> Security Controls -> Auth. Providers -> New
	- Select provider type 'Salesforce'
	- Write a name: Timezonedb
	- Write a Default Scopes: full refresh_token_offline_access
	- Write a 'Consumer Key' and 'Consumer Secret' from your notes
	- Click on 'Save'
	- Open Timezonedb auth provider and copy 'Callback URL'
	- Open Timezonedb connected app and replace 'Callback URL' from 'https://localhost/dummy' to the one you copied
	- Click on 'Save'
		
###Step 3: Creating a Named Credential
	
	- Setup -> Security Controls -> Named Credentials -> New Named Credential
	- Write a label: Timezonedb
	- Write ‘https://api.timezonedb.com/v2.1/get-time-zone’ to ’'url' input field.
	- Near Identity Type, choose Named Principal
	- Choose OAuth 2.0 for Authentication Protocol
	- Choose the Auth Provider you created earlier for Authentication Provider
	- In the "Scope" field, specify 'full refresh_token offline_access'
	- Click on 'Start Authentication Flow on Save' checkbox
	- Click on 'Allow Merge Fields in HTTP Body' checkbox
	- You will be prompted to log in to your org. After you log in, then allow access to your app
