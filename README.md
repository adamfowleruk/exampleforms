# Example Forms


## Instructions from Balvinder

Hi Adam,

Please find attached the code for orbeon ml api (THE TWO ZIP FILES),

This is roxy app so ‘ml local bootstrap’ and 'ml deploy modules’ (change local properties appropriately)
Place the orbeon-ml-api/orbeon-props/properties-local.xml file under <tomcat>/webapps/orbeon/WEB-INF/resources/config (if you change the port in local properties change it in this file as well)
Start playing with form builder and form runner
Please find attached some of the erdf forms for reference.

Thanks,
Balvinder

## Instructions from Jon
The content under data/scottish-government/* contains the updated formbuilder and formrunner instance
Import the data using the sample script form-import.xqy from the MarkLogic query console
Copy the gds.css and custom.css files to the orbeon deployment under $TOMCAT_HOME/webapps/orbeon/WEB-INF/resources/config
Copy the switcher.js file to $TOMCAT_HOME/webapps/orbeon/WEB-INF/resources/forms
Copy or modify properties-local.xml using supplied sample.

The files under autocomplete should be deployed to a MarkLogic application server running on port 8048


## To run the workplace web application (Instructions from Adam)

### Install mljsadmin globally

WARNING: You MUST install mlnodetools GLOBALLY:-

1. npm install -g mlnodetools
2. If you receive permission warnings, follow the advice on the following page, and then try the above command again: https://docs.npmjs.com/getting-started/fixing-npm-permissions
3. Test by typing just 'mljsadmin' with no parameters from the command line (this MUST be issued in the root folder of your app)

### Install the workplace files

1. cd to the root folder
1. mljsadmin --update=searchoptions
1. mljsadmin --update=ontology
1. mljsadmin --update=workplace
1. mljsadmin load

### Install sample documents

1. Open up QConsole and load the data/Forms.xml workspace.
1. Execute the Add Json query

### Install form definitions

1. Open a new XQuery query in QConsole
1. Take the contents of form-import.xqy and paste in to the query
1. Modify the paths to match the location of the data directory on your system
1. Execute the query

### Run the app

1. cd to the root folder
1. mljsserve
1. Navigate a browser to http://localhost:5001/index.html5

After a couple of seconds you should see a menu of other pages. Clicking on 'search' and refreshing the page
(a slight bug there...) should show the couple of example forms

### Publish Orbeon form

You may need to republish to successfully use the form.

1. Visit http://localhost:8080/orbeon/fr
1. Open the Scottish Survey form
1. Click Publish and accept the popup box

### Test app

1. Return to your Workplace app
1. Click on 'New Form' in the navigation bar

You should see a blank orbeon form load.

## Troubleshooting

If you cannot see any navigation menus within the workplace app then you've not successfully installed Workplace. Pay
attention to the warnings when you run mljsadmin on the command line. Also read mljsadmin.log and the ML Server error
log for any further issues. Finally, read your browser's JavaScript console output and any HTTP 500 (failed) AJAX
requests to /v1/search .
