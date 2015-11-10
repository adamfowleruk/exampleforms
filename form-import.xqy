(: Import form-builder and form-runner templates :)
xdmp:document-load("/vagrant/exampleforms/data/scottish-government/orbeon/ScottishGovernment/GlobalConnectionsSurvey2015/form/form.xhtml",
    <options xmlns="xdmp:document-load">
       <uri>/orbeon/ScottishGovernment/GlobalConnectionsSurvey2015/form/form.xhtml</uri>
       <collections>
          <collection>latest</collection>
          <collection>version-1</collection>
          <collection>form-runner</collection>
       </collections>
       <permissions>{xdmp:permission("orbeon-ml-api-role", "execute"),
       xdmp:permission("orbeon-ml-api-role", "update"),
       xdmp:permission("orbeon-ml-api-role", "insert"),
       xdmp:permission("orbeon-ml-api-role", "read")}</permissions>
    </options> );
xdmp:document-load("/vagrant/exampleforms/data/scottish-government/orbeon/orbeon/builder/data/090be035491c76f212b74e8de2d304fc2df83366/data.xml",
    <options xmlns="xdmp:document-load">
       <uri>/orbeon/orbeon/builder/data/090be035491c76f212b74e8de2d304fc2df83366/data.xml</uri>
       <collections>
          <collection>latest</collection>
          <collection>form-builder</collection>
       </collections>
       <permissions>{xdmp:permission("orbeon-ml-api-role", "execute"),
       xdmp:permission("orbeon-ml-api-role", "update"),
       xdmp:permission("orbeon-ml-api-role", "insert"),
       xdmp:permission("orbeon-ml-api-role", "read")}</permissions>
    </options> );    
