xquery version "1.0-ml";

module namespace rlib = "http://marklogic.com/orbeon-ml-api/ns/relate/relate-lib";

import module namespace c = "http://marklogic.com/orbeon-ml-api/ns/common/constants" at "/app/common/constants.xqy";
import module namespace mem = "http://xqdev.com/in-mem-update" at "/MarkLogic/appservices/utils/in-mem-update.xqy";
import module namespace s = "http://marklogic.com/semantics" at "/MarkLogic/semantics.xqy";

declare namespace sem = "http://marklogic.com/semantics";

declare private function rlib:already-exists(
    $sub as xs:string,
    $pred as xs:string,
    $obj as xs:string,
    $entity as node()
) as xs:boolean
{
    fn:exists(
        $entity//sem:triple[
            sem:subject = $sub and
            sem:predicate = $pred and
            sem:object = $obj
        ]
    )
};


declare function rlib:update-has-doc-uri(
    $entity as node(),
    $object-uri as xs:string
) as node()
{   
   let $has-doc-triple := $entity//sem:triple[sem:predicate = $c:IRI-HAS-DOC-URI]
   return 
       if($has-doc-triple) 
       then mem:node-replace($has-doc-triple/sem:object, <sem:object>{$object-uri}</sem:object>) 
       else $entity
};

declare function rlib:has-form-version(
    $entity as node(),
    $entity-type as xs:string,
    $entity-uid as xs:string
) as xs:boolean
{      
   let $entity-sub := $c:IRI-PREFIX || "/"|| $entity-type || "/" || $entity-uid
   return
       fn:exists($entity//sem:triple[sem:subject = $entity-sub and sem:predicate = $c:IRI-CREATED-FROM])   
};

declare function rlib:remove-relations (
    $entity as node()
) as node()
{
    if($entity//sem:triples) then mem:node-delete($entity//sem:triples) else $entity    
};

declare function rlib:enrich-with-relation (
    $entity as node(),
    $subject as xs:string,    
    $predicate as xs:string,
    $object as xs:string   
) as node()
{        
    let $triple :=
        if(fn:not(rlib:already-exists($subject, $predicate, $object, $entity)))
        then
            <sem:triple>
                <sem:subject>{$subject}</sem:subject>
                <sem:predicate>{$predicate}</sem:predicate>
                <sem:object>{$object}</sem:object>
            </sem:triple> 
        else ()
    return
        if (fn:exists($triple))
        then
            if(fn:exists($entity//sem:triples))
            then mem:node-insert-child($entity//sem:triples, ($triple))
            else mem:node-insert-child($entity, <sem:triples>{$triple}</sem:triples>)
        else $entity
};


declare function rlib:enrich-with-form-version(
    $entity as node(),
    $entity-type as xs:string,
    $entity-uri as xs:string,
    $entity-uid as xs:string,
    $form-version as xs:string
) as node()
{        
    let $entity-sub := $c:IRI-PREFIX || "/"|| $entity-type || "/" || $entity-uid    
    let $obj := $c:IRI-PREFIX || "/"|| $entity-type || "/form/" || $form-version
    return rlib:enrich-with-relation($entity, $entity-sub, $c:IRI-CREATED-FROM, $obj)
};

declare function rlib:enrich-with-relationship(
    $entity as node(),
    $entity-type as xs:string,
    $entity-uri as xs:string,
    $entity-uid as xs:string
) as node()?
{        
    
    let $_ := xdmp:log(fn:concat("ENTITY TYPE: ", $entity-type), "debug")
    
    let $entity-sub := $c:IRI-PREFIX || "/"|| $entity-type || "/" || $entity-uid
    
    let $entity-uids-to-join := $entity/*:uids/*
    let $relationship-triples :=
            if(fn:exists($entity-uids-to-join ))
            then
                for $entity-uid-to-join in $entity-uids-to-join
                let $type := fn:local-name($entity-uid-to-join)
                let $uid := $entity-uid-to-join/fn:string()
                let $pred := (if($entity-uid-to-join/@predicate = "createdFor") then $c:IRI-CREATED-FOR else $c:IRI-BELONGS-TO),
                    $obj := $c:IRI-PREFIX || "/"|| $type ||"/" || $uid
                return
                    if(fn:not(rlib:already-exists($entity-sub, $pred, $obj, $entity)))
                    then
                        <sem:triple>
                            <sem:subject>{$entity-sub}</sem:subject>
                            <sem:predicate>{$pred}</sem:predicate>
                            <sem:object>{$obj}</sem:object>
                        </sem:triple>
                    else ()
            else ()

    let $pred := $c:IRI-HAS-DOC-URI,
        $obj := $entity-uri
    let $doc-uri-triple := 
            if(fn:not(rlib:already-exists($entity-sub, $pred, $obj, $entity)))
            then
                <sem:triple>
                    <sem:subject> { $entity-sub } </sem:subject>
                    <sem:predicate>{ $pred }</sem:predicate>
                    <sem:object datatype="http://www.w3.org/2001/XMLSchema#string">{$entity-uri}</sem:object>
                </sem:triple>
            else ()
            
    let $_ := xdmp:log(fn:concat("entity type: ", $entity-type), "debug")  
    let $_ := xdmp:log(fn:concat("rdf type: ", fn:concat($c:IRI-PREFIX, $c:_SLASH, $entity-type)), "debug")        
            
    let $type-triple :=
            if(fn:not(rlib:already-exists($entity-sub, $c:IRI-RDF-TYPE, fn:concat($c:IRI-PREFIX, $c:_SLASH, $entity-type), $entity)))
            then 
                <sem:triple>
                    <sem:subject> { $entity-sub } </sem:subject>
                    <sem:predicate> { $c:IRI-RDF-TYPE } </sem:predicate>
                    <sem:object> { fn:concat($c:IRI-PREFIX, $c:_SLASH, $entity-type) } </sem:object>
                </sem:triple>
            else ()

    return 
        if (fn:exists($relationship-triples) or fn:exists($doc-uri-triple) or fn:exists($type-triple))
        then
            if(fn:exists($entity//sem:triples))
            then mem:node-insert-child($entity//sem:triples, ($relationship-triples, $doc-uri-triple, $type-triple))
            else mem:node-insert-child($entity, <sem:triples>{($relationship-triples, $doc-uri-triple, $type-triple)}</sem:triples>)
        else $entity
};

(: map of relations: altough the keys and values are the same, in this way any type of code injection is avoided  :)
declare variable $rlib:RELATION-MAP := map:map(
  <map:map xmlns:map="http://marklogic.com/xdmp/map">
    <map:entry key="belongs-to">
       <map:value>belongs-to</map:value>
    </map:entry>
    <map:entry key="created-for">
       <map:value>created-for</map:value>
    </map:entry>
    <map:entry key="created-from">
       <map:value>created-from</map:value>
    </map:entry>
    <map:entry key="has-doc-uri">
       <map:value>has-doc-uri</map:value>
    </map:entry>
  </map:map>
);


declare function rlib:query-for-subject(
    $type as xs:string, 
    $relation as xs:string, 
    $objectId as xs:string,
    $objectType as xs:string
) as xs:string*
{
    let $object := $c:IRI-PREFIX || "/"|| $objectType ||"/" || $objectId
    let $sparql-query := 
        " PREFIX e: <http://marklogic.com/orbeon-ml-api/ns/> " ||
        " PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> " ||
        " SELECT DISTINCT ?subject " ||
        " WHERE { " || 
        " ?subject e:" || map:get($rlib:RELATION-MAP, $relation)  || " <"|| $object || "> ; " ||
        "          rdf:type <" ||  fn:concat($c:IRI-PREFIX, $c:_SLASH, $type) ||"> }"
        
    let $_ := xdmp:log(fn:concat("SPARQL: ",  $sparql-query), "debug")
    
    return     
        sem:sparql($sparql-query) ! map:get(., "subject")
};

declare function rlib:query-for-object(
    $type as xs:string, 
    $relation as xs:string, 
    $subjectId as xs:string,
    $subjectType as xs:string
) as xs:string*
{
    let $subject := $c:IRI-PREFIX || "/"|| $subjectType ||"/" || $subjectId
    let $sparql-query := 
        " PREFIX e: <http://marklogic.com/orbeon-ml-api/ns/> " ||
        " PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> " ||
        " SELECT DISTINCT ?object " ||
        " WHERE { " || 
        " <" || $subject || "> e:" || map:get($rlib:RELATION-MAP, $relation)  || " ?object . " ||
        " ?object         rdf:type <" ||  fn:concat($c:IRI-PREFIX, $c:_SLASH, $type) ||"> }"
        
    let $_ := xdmp:log(fn:concat("SPARQL: ",  $sparql-query), "debug")
    
    return     
        sem:sparql($sparql-query) ! map:get(., "object")
};

declare function rlib:query-for-object(     
    $relation as xs:string, 
    $subjectId as xs:string,
    $subjectType as xs:string
) as xs:string*
{
    let $subject := $c:IRI-PREFIX || "/"|| $subjectType ||"/" || $subjectId
    return rlib:query-for-object($relation, $subject)
};

declare function rlib:query-for-object(
    $relation as xs:string,
    $subject as xs:string    
) as xs:string*
{    
    let $sparql-query := 
        " PREFIX e: <http://marklogic.com/orbeon-ml-api/ns/> " ||
        " PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> " ||
        " SELECT DISTINCT ?object " ||
        " WHERE {  <" || $subject || "> e:" || map:get($rlib:RELATION-MAP, $relation)  || " ?object }"        
    let $_ := xdmp:log(fn:concat("SPARQL: ",  $sparql-query), "debug")    

    return     
        sem:sparql($sparql-query) ! map:get(., "object")
};

declare function rlib:enrich-with-external-relation(
     $subject as xs:string,    
     $predicate as xs:string,
     $object as xs:string   
) as xs:string* {
    
  if(rlib:already-exists-external($subject, $predicate, $object)) 
  then ()
  else
   s:rdf-insert(
    s:triple(
        s:iri($subject),            
        s:iri($predicate),
        s:iri($object)
    )
   )
};

declare function rlib:delete-external-relation(
    $subject as xs:string,    
    $predicate as xs:string,
    $object as xs:string     
) as empty-sequence() {
  if(rlib:already-exists-external($subject, $predicate, $object)) 
  then 
    (s:database-nodes(
        s:triple(
        s:iri($subject),            
        s:iri($predicate),
        s:iri($object)
      ) 
    ) ! xdmp:node-delete(.))
   else ()
};

declare private function rlib:already-exists-external(
    $subject as xs:string,
    $predicate as xs:string,
    $object as xs:string
) as xs:boolean
{
   let $query   := 
         'ASK
          WHERE {
             <' || $subject || '> <' || $predicate || '> <' || $object || '>
          }'
   return
      s:sparql($query)
};
