# exampleforms


1. Load data/scottish-government/* in to MarkLogic's content database
1. Ensure the form definition is in collections: latest, version-1, form-runner


## Instructions from Balvinder

Hi Adam,

Please find attached the code for orbeon ml api (THE TWO ZIP FILES),

This is roxy app so ‘local bootstrap’ and 'deploy modules’ (change local properties appropriately)
Place the orbeon-ml-api/orbeon-props/properties-local.xml file under <tomcat>/webapps/orbeon/WEB-INF/resources/config (if you change the port in local properties change it in this file as well)
Start playing with form builder and form runner
Please find attached some of the erdf forms for reference.

Thanks,
Balvinder

## Instructions from Jon
The content under data/scottish-government/* contains the updated formbuilder and formrunner instance
Import the data using the sample script form-import.xqy from the MarkLogic query console
Copy the custom.css file to the orbeon deployment under $TOMCAT_HOME/webapps/orbeon/WEB-INF/resources/config
Copy or modify properties-local.xml using supplied sample
