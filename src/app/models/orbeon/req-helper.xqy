xquery version "1.0-ml";

module namespace req-helper="http://marklogic.com/orbeon/req-helper";

declare namespace e = "http://marklogic.com/orbeon-ml-api/ns";

declare function req-helper:build-params()
as element(e:params)
{
    <e:params>
    {
        for $p in fn:distinct-values((xdmp:get-request-field-names(),xdmp:get-request-header-names()))
        let $v := fn:distinct-values((xdmp:get-request-field($p),xdmp:get-request-header($p)))
        return <e:param><e:name>{$p}</e:name><e:value>{$v}</e:value></e:param>
    }
    </e:params>
};

declare function req-helper:get-param($params as element(e:params), $param as xs:string)
as xs:string?
{
    req-helper:get-param($params, $param, ())
};

(: headers are converted to camel-case, hence matching using lower-case
:)
declare function req-helper:get-param($params as element(e:params), $param as xs:string, $default as xs:string?)
as xs:string?
{
    (($params/e:param[fn:lower-case(e:name) eq fn:lower-case($param)]/e:value, $default))[1]
};
