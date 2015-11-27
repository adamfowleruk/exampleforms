xquery version "3.0";

module namespace helper="http://marklogic.com/orbeon/helper";

import module namespace req-helper = "http://marklogic.com/orbeon/req-helper" at "/app/models/orbeon/req-helper.xqy";

declare namespace e = "http://marklogic.com/orbeon-ml-api/ns";
declare namespace err = "http://www.w3.org/2005/xqt-errors";
declare namespace xdmp = "http://marklogic.com/xdmp";

declare variable $FORM-NAME-FULL := 'dummy-form';

declare function helper:apply-xslt-transformation($form-name as xs:string, $full-path as xs:string) 
as node() 
{	
  try{
    xdmp:xslt-invoke("/app/models/xslt/" ||  $form-name || ".xsl", fn:doc($full-path))
  }
  catch err:XTSE0165 (: XSLT_XMLNODE - There is no XSLT transformation for this form type :)
  {
  	fn:doc($full-path)
  }
};

declare function helper:apply-transformation(
    $instance as node(),
    $params as element(e:params),
    $full-path as xs:string    
) as node()
{
    let $form-name := req-helper:get-param($params, 'form')
    return
        switch ( $form-name )
          case $FORM-NAME-FULL return ($instance)
          (: custom transformation to apply to the form instance before saving            
              app:manage-project(
                app:generate-reference($instance, $full-path), $full-path)            
          :)          
          default return $instance        
};
