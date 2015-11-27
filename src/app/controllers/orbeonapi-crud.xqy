xquery version "1.0-ml";

module namespace c = "http://marklogic.com/roxy/controller/orbeonapi-crud";

import module namespace ch = "http://marklogic.com/roxy/controller-helper" at "/roxy/lib/controller-helper.xqy";
import module namespace req = "http://marklogic.com/roxy/request" at "/roxy/lib/request.xqy";

import module namespace req-helper = "http://marklogic.com/orbeon/req-helper" at "/app/models/orbeon/req-helper.xqy";
import module namespace helper = "http://marklogic.com/orbeon/helper" at "/app/models/orbeon/helper.xqy";
import module namespace eh = "http://marklogic.com/orbeon-ml-api/ns/common/entity-helper" at "/app/common/entity-helper.xqy"; 
import module namespace v = "http://marklogic.com/orbeon/versioning" at "/app/models/orbeon/versioning.xqy";
import module namespace rlib = "http://marklogic.com/orbeon-ml-api/ns/relate/relate-lib" at "/relate/relate-lib.xqy";
import module namespace con = "http://marklogic.com/orbeon-ml-api/ns/common/constants" at "/app/common/constants.xqy";

declare namespace e = "http://marklogic.com/orbeon-ml-api/ns";

declare option xdmp:mapping "false";

declare function c:crud-put() as item()*
{
   let $params := req-helper:build-params()   
   let $full-path := c:get-xform-full-path($params)   
   let $content-type := req-helper:get-param($params, 'Content-Type')
   let $versioning := req-helper:get-param($params, 'versioning', "false") 
   
   let $exists := doc-available($full-path)
   let $document := xdmp:get-request-body()/node()
   
   let $document := if (fn:matches($content-type, '^(application|text).*xml.*$'))
                    then c:manage-xml($document, $params)
                    else $document
   
   let $result := (
       (if(fn:matches($full-path, "/data/.*/data.xml"))
        then v:store-form-instance($full-path, $document, $exists, $versioning eq 'true', fn:true(), ())
        else v:store-form-instance($full-path, $document, $exists, $versioning eq 'true', fn:false(), ())
       ),
       if ($exists) then ()
       else xdmp:document-add-properties($full-path, <created>{current-dateTime()}</created>)
   )   
   return c:build-response($result) 
};

declare function c:crud-get() as item()*
{
   let $params := req-helper:build-params()
   let $form := req-helper:get-param($params, 'form')
   let $full-path := c:get-xform-full-path($params)
   let $apply-transformation := req-helper:get-param($params, 'apply-transformation', 'false')   
   let $for-document-id := req-helper:get-param($params, 'Orbeon-For-Document-Id')
   let $full-path := if($for-document-id)
                     then let $doc-uri := c:get-doc-uri(c:get-form-created-from($for-document-id, $form))
                          let $doc-uri := if($form = ('full-application', 'outline-application')) then c:manage-application-form-uri($doc-uri, $form) else $doc-uri
                          return if($doc-uri) then $doc-uri else $full-path 
                     else $full-path
   let $result :=
       if ( doc-available($full-path) ) then
          if ( $apply-transformation eq 'true' ) then
             helper:apply-xslt-transformation($form, $full-path)
          else
             doc($full-path)
       else
          <e:error code="404" message="Not found"/>
   
   (:add current version header to response, and invoke all-forms.xsl which will remove sem:triples, otherwise triple information is rendered in browser:)
   let $result :=  if (fn:ends-with($full-path,'/form.xhtml'))
                   then
                       ( let $version := v:get-version($full-path)
                         return
                             if($version) then xdmp:add-response-header("Orbeon-Form-Definition-Version", fn:concat("",v:get-version($full-path)))
                             else (),
                         helper:apply-xslt-transformation("all-forms", $full-path)
                        )
                   else $result                      
   return c:build-response($result)   
};

declare function c:crud-delete() as item()*
{
  let $params := req-helper:build-params()
  let $path := req-helper:get-param($params, 'path', '')
  let $full-path := c:get-xform-full-path($params)
  let $query := req-helper:get-param($params, 'query', ())
  
  let $result :=
     
     if ( fn:exists($path[.]) ) then
         xdmp:document-delete($full-path)
     else
        if(fn:exists($query))
        then 
            for $form in cts:search(/, cts:and-query((
                cts:directory-query($full-path, "infinity"),
                cts:word-query($query)
            )) )
            return xdmp:document-delete(fn:base-uri($form))
        else
            xdmp:directory-delete($full-path)
         
  return c:build-response($result)       
         
};

declare function c:build-response($result){
    (
      ch:add-value("response", $result ),
      ch:set-format("xml"), 
      ch:use-view("orbeonapi/crud", ("xml"))
   )
};

declare function c:get-xform-full-path($params as element(e:params)) as xs:string {
    let $type := req-helper:get-param($params, 'type')
    let $version := req-helper:get-param($params, 'Data-version')
    let $path := req-helper:get-param($params, 'path', '')
    let $final-path :=
                if($type = 'data' and fn:not($version = ''))
                then fn:string-join(fn:insert-before(fn:tokenize($path, '/'), 2, $version), "/")
                else $path
    return
        string-join(
            (
              req-helper:get-param($params, 'Orbeon-Root', '/orbeon'),
              req-helper:get-param($params, 'application'),
              req-helper:get-param($params, 'form'),
              $type,
              $final-path
            ),
            '/'
        )
};

declare function c:get-form-created-from($for-document-id as xs:string, $subjectType as xs:string) as xs:string? {
    rlib:query-for-object($con:CREATED-FROM, $for-document-id,  $subjectType)
};

declare function c:get-doc-uri($form-subject-iri as xs:string?) as xs:string* {
    if($form-subject-iri) then rlib:query-for-object($con:HAS-DOC-URI, $form-subject-iri) else ()
};


(:
: CRUD PUT for '/form/form.xhtml' and /orbeon/orbeon/builder/data/(id)/data.xml
:
:)
declare function c:crud-form-put() as item()*
{
   let $params := req-helper:build-params()
   let $form := req-helper:get-param($params, 'form')
   let $full-path := c:get-xform-full-path($params)   
   let $content-type := req-helper:get-param($params, 'Content-Type')    
   let $form-versioning := req-helper:get-param($params, 'Orbeon-Versioning', 'false')   
   let $form-def-version := req-helper:get-param($params, 'Orbeon-Form-Definition-Version')

   (:if next version then only version forms, otherwise overwrite existing version:)
   let $form-versioning := if($form-def-version eq 'next') then 'true' else 'false'   
   
   let $form-def-version := if($form-def-version eq 'next') 
                            then let $version := v:get-version($full-path) return xs:string(if($version) then $version + 1 else 1) 
                            else $form-def-version
   
   let $exists := doc-available($full-path)
   
   let $document := xdmp:get-request-body()/node()
   
   (:form builder publish overwrites /form/form.xhtml with /orbeon/builder/data/{id}/data.xml, hence need to clear existing relations:)
   let $document := rlib:remove-relations($document)
      
   (:upload script becomes element node, whereas form builder becomes document node after this rlib:remove-relations() invocation, in-mem library is not consistent:)
   let $document := if(xdmp:node-kind($document) eq "document") 
                    then $document/node()
                    else $document
   
   let $_log := xdmp:log('remove relations node kind' || xdmp:node-kind($document), "debug")
   
   (: add namespace to the form in runner location :)
   let $document := if (fn:ends-with($full-path,'/form.xhtml')) 
                    then xdmp:xslt-invoke("/app/models/orbeon/add-ns.xsl", $document)/node()                        
                    else $document
   
   (:add hasDocUri relation:)               
   let $document := if ($form-versioning) 
                    then                        
                        if (fn:ends-with($full-path,'/form.xhtml')) 
                        then rlib:enrich-with-relation($document, fn:concat($con:IRI-PREFIX, "/", $form, "/form/", $form-def-version), $con:IRI-HAS-DOC-URI, $full-path)
                        (:form builder:)                        
                        else rlib:enrich-with-relation($document, fn:concat($con:IRI-PREFIX, "/", $form, $full-path), $con:IRI-HAS-DOC-URI, $full-path)
                    else $document
                    
   let $result := (
         (if(fn:matches($full-path, "/builder/data/.*/data.xml"))
          then v:store-form-instance($full-path, $document, $exists, $form-versioning eq 'true', fn:false(), ('form-builder'))
          else v:store-form-instance($full-path, $document, $exists, $form-versioning eq 'true', fn:false(), ('form-runner'))
         ),
      if ( $exists ) then
         ()
      else
         xdmp:document-add-properties($full-path, <created>{current-dateTime()}</created>)
   )
    
   return 
       (xdmp:add-response-header("Orbeon-Form-Definition-Version", $form-def-version),
        c:build-response($result)
       )   
}; 

declare function c:manage-xml(
    $document as element(), 
    $params as element(e:params)
) as node()
{
    let $form := req-helper:get-param($params, 'form')
    let $full-path := c:get-xform-full-path($params)
    let $apply-transformation := req-helper:get-param($params, 'apply-transformation', 'false')
    let $form-versioning := req-helper:get-param($params, 'Orbeon-Versioning', "false")   
        
    let $form-def-version := req-helper:get-param($params, 'Orbeon-Form-Definition-Version')
    
    let $document := 
        if ($apply-transformation eq 'true') 
        then helper:apply-transformation($document, $params, $full-path)
        else $document
           
    let $document := rlib:enrich-with-relationship($document, $form, $full-path, eh:entity-uid-from($full-path))
         
    (:in-mem library is not consistent, better to check here:)
    let $document := if(xdmp:node-kind($document) eq "document") 
                    then $document/node()
                    else $document
      
    let $document :=
        if ($form-versioning)
        then if(fn:not(rlib:has-form-version($document, $form, eh:entity-uid-from($full-path)))) then rlib:enrich-with-form-version($document, $form, $full-path, eh:entity-uid-from($full-path), $form-def-version) else $document
        else $document
        
    return $document
};

declare function c:manage-application-form-uri(
    $doc-uri as xs:string*, 
    $form as xs:string
) as xs:string?
{
    ($doc-uri ! (if(fn:matches(., $form)) then . else ()))    
};
  

