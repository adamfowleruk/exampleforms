xquery version "1.0-ml";

module namespace c = "http://marklogic.com/roxy/controller/orbeonapi-search";

import module namespace ch = "http://marklogic.com/roxy/controller-helper" at "/roxy/lib/controller-helper.xqy";
import module namespace req = "http://marklogic.com/roxy/request" at "/roxy/lib/request.xqy";

declare namespace prop = 'http://marklogic.com/xdmp/property';
declare namespace xs = 'http://www.w3.org/2001/XMLSchema';
declare namespace xsi = 'http://www.w3.org/2001/XMLSchema-instance';

declare option xdmp:mapping "false";

declare function c:search() as item()* 
{
    let $application := xdmp:get-request-field('application')
    let $form := xdmp:get-request-field('form')
    let $search := xdmp:get-request-body()/*
    let $debug := xdmp:get-request-header('Orbeon-Debug')
    let $root := xdmp:get-request-header('Orbeon-Root', '/orbeon')
    let $full-path := string-join(($root, $application, $form, 'data', ''), '/')
    
    let $free-text-query := $search/query[1][not(@*) and normalize-space()!=""]
    let $structured-queries := $search/query[@search-field = 'true' and normalize-space()!=""]
    let $fb-lang := $search/lang
    
    (: Variables passed to the query :)
    
    let $vars := map:map(<map:map xmlns:map="http://marklogic.com/xdmp/map">
     <map:entry key="{xdmp:key-from-QName(xs:QName('full-path'))}">
       <map:value xsi:type="xs:string"
          >{$full-path}</map:value>
     </map:entry>
     <map:entry key="{xdmp:key-from-QName(xs:QName('fb-lang'))}">
       <map:value xsi:type="xs:string"
          >{$fb-lang}</map:value>
     </map:entry>
     <map:entry key="{xdmp:key-from-QName(xs:QName('free-text-query'))}">
       <map:value 
          >{$free-text-query}</map:value>
     </map:entry>
     <map:entry key="{xdmp:key-from-QName(xs:QName('structured-queries'))}">
       <map:value 
          >{$structured-queries}</map:value>
     </map:entry>
     <map:entry key="{xdmp:key-from-QName(xs:QName('page-size'))}">
       <map:value 
          >{$search/page-size}</map:value>
     </map:entry>
     <map:entry key="{xdmp:key-from-QName(xs:QName('page-number'))}">
       <map:value 
          >{$search/page-number}</map:value>
     </map:entry>
    </map:map>)
    
    (: A query to search all the documents :)
    let $search-all-query := 'let $all-documents := cts:search(/, cts:directory-query($full-path, "infinity"))[*]'
    
    (: The cts:search function call :)
    let $search-query :=
        if ($free-text-query)
        then 
            (: full text :) 
            'let $documents := cts:search(/, cts:and-query((cts:directory-query($full-path, "infinity"), cts:word-query($free-text-query, concat("lang=", if(fn:normalize-space($fb-lang)) then $fb-lang else "en")))))[*]'
        
        else if ($structured-queries)
        then string-join((
            'let $documents := cts:search(/, cts:directory-query($full-path, "infinity"))',
            for $position in 1 to count($structured-queries) 
            let $q := $structured-queries[$position]
            return concat(
                '[*][',
                if ($q/@match = 'exact')
                then concat('lower-case(*/', $q/path, ') = lower-case($structured-queries[', $position, '])')
                else concat('contains(lower-case(*/', $q/@path, '), lower-case($structured-queries[', $position, ']))'),
                ']'
            )
        ), '')
        else 
            (: Any document :) 
            'let $documents := cts:search(/, cts:directory-query($full-path, "infinity"))[*]'
    
    
    
    (: Generate the query :)
    (: TODO: beware of XQuery injection :)
    
    let $query := string-join ((
    'xquery version "1.0-ml";
    declare namespace prop = "http://marklogic.com/xdmp/property";',
    
    (: Insert namespace declarations :)
    for $ns in $search/namespace::*[name() != 'xml'] return concat('declare namespace ', name($ns), ' = "', $ns, '";'),
    
    'declare variable $full-path external;
    declare variable $fb-lang external;
    declare variable $free-text-query external;
    declare variable $structured-queries external;
    declare variable $page-number external;
    declare variable $page-size external;',
    
    $search-all-query,
    $search-query,
    
    'return 
        <documents total="{count($all-documents)}" search-total="{count($documents)}" page-size="{$page-size}" page-number="{$page-number}" query="{$free-text-query}">
        {
            let $sorted-documents := 
                for $document in $documents 
                   let $updated := $document/property::prop:last-modified
                   order by $updated descending
                   return $document
                   
            for $document in $sorted-documents[position() > ($page-number - 1) * $page-size and position() <= $page-number * $page-size]
            let $properties := $document/property::*
            let $uri-tokens := tokenize(document-uri($document), "/")
            return
            <document created="{$properties[self::created]}" last-modified="{$properties[self::prop:last-modified]}" 
                  name="{$uri-tokens[count($uri-tokens) - 1]}" operations="*" draft="false">
                <details>',
    
    (: Generate detail elements :)
    for $query in $search/query[@summary-field="true"] return
        concat('<detail>{$document/*/', $query/@path, '}</detail>'),
    
    
    '           </details>
            </document>
                
        }
        </documents>',
    
    
    ''
    ), '&#xa;')
    
    (: Execute the query :)
    
    return (
        xdmp:log('Query generated for a search request:', "debug"),
        xdmp:log($query, "debug"),
        xdmp:log($vars, "debug"),
        document {
            if ($debug = 'true')
            then comment {$query}
            else (),
            xdmp:eval($query, $vars)
        }
    )
};


