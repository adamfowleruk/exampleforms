xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";

declare option xdmp:mapping "false";

declare variable $response as node()* := vh:get("response");

if (local-name($response) ne 'error') then
    $response
else 
    (xdmp:set-response-code($response/@code, $response/@message), 
    <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta name="robots" content="noindex,nofollow"/>
       </head>
       <body>
            <h1> { $response/@code || ' ' || $response/@message } </h1>
       </body>
    </html>) 
