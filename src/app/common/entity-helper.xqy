xquery version "3.0";

module namespace eh = "http://marklogic.com/orbeon-ml-api/ns/common/entity-helper";

import module namespace c = "http://marklogic.com/orbeon-ml-api/ns/common/constants" at "/app/common/constants.xqy";

declare namespace e = "http://marklogic.com/orbeon-ml-api/ns";
declare namespace xdmp = "http://marklogic.com/xdmp";

declare function eh:entity-uid-from (
    $full-path as xs:string
) as xs:string
{
    let $uid := fn:substring-after(fn:substring-before($full-path, $c:ENTITY-PATH-SUFFIX), "/data/")
    return if($uid) then $uid else $full-path
};
