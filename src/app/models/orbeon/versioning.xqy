xquery version "1.0-ml";

module namespace v="http://marklogic.com/orbeon/versioning";

import module namespace rlib = "http://marklogic.com/orbeon-ml-api/ns/relate/relate-lib" at "/relate/relate-lib.xqy";

declare variable $v:VERSION-PREFIX := "version-";
declare variable $v:FIRST-VERSION  := "version-1";
declare variable $v:LATEST-VERSION := "latest";
declare variable $v:SEARCHABLE_DATA := "searchable";


declare function v:store-form-instance(
    $document-path as xs:string, 
    $document as node(), 
    $exists as xs:boolean, 
    $versioning as xs:boolean,
    $searchable as xs:boolean,
    $additional-collections as xs:string*
)
{
    if($exists) then
        let $_ := xdmp:log(fn:concat("versioning started: ", xdmp:quote($document)), 'fine')
        return 
            if($versioning) then
                let $previous-version := v:get-version($document-path) 
                let $previous-version :=
                    if(fn:not(fn:empty($previous-version))) then
                        v:manage-previous-version-doc($document-path, $previous-version)
                    else xs:int(0)
                
                let $new-version := $previous-version + 1 
                let $new-version-collections := ($v:LATEST-VERSION, fn:concat($v:VERSION-PREFIX , xs:string($new-version)), if($searchable) then $v:SEARCHABLE_DATA  else ())
                return 
                    xdmp:document-insert($document-path, 
                                     $document, 
                                     xdmp:default-permissions(),
                                     ($new-version-collections, $additional-collections))
            else 
                xdmp:document-insert($document-path, 
                                     $document, 
                                     xdmp:default-permissions(),
                                     (xdmp:document-get-collections($document-path), $additional-collections))
    else 
        let $collections := ($v:LATEST-VERSION, if($versioning) then $v:FIRST-VERSION else (), if($searchable) then $v:SEARCHABLE_DATA  else ()) 
        return 
            xdmp:document-insert($document-path, 
                             $document, 
                             xdmp:default-permissions(),
                             ($collections, $additional-collections))    
};

declare function v:get-version($document-path as xs:string)
as xs:int?
{
    let $existing-collections := xdmp:document-get-collections($document-path)
    let $version :=
        ((for $collection in $existing-collections
        return 
        if(fn:starts-with($collection, $v:VERSION-PREFIX)) 
        then xs:int(fn:replace($collection, $v:VERSION-PREFIX, "")) else () ))[1]
    return $version
};

declare function v:manage-previous-version-doc($document-path as xs:string, $previous-version as xs:int)
as xs:int
{
    let $parts := fn:tokenize($document-path, "/")    
    let $previous-version-uri := fn:string-join(fn:insert-before($parts, fn:count($parts), xs:string($previous-version)), "/")
    let $previous-version-collections := (xdmp:document-get-collections($document-path))[. ne $v:LATEST-VERSION and . ne $v:SEARCHABLE_DATA]
    let $_prev-doc := rlib:update-has-doc-uri(fn:doc($document-path)/node(), $previous-version-uri)    

    return
        (xdmp:document-insert($previous-version-uri, 
                     $_prev-doc, 
                     xdmp:default-permissions(),
                     ($previous-version-collections)),
         $previous-version
        )
};
