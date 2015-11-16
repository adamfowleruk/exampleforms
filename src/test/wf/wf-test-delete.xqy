xquery version "1.0-ml";

declare option xdmp:mapping "false";
declare option xdmp:update "true";

declare function local:main() {
    let $forest-ids := xdmp:database-forests(xdmp:database("esif-content-test"))
    for $forest-id in $forest-ids
    return(
        xdmp:forest-clear($forest-id),
        xdmp:set-response-code(200, "OK")
    )
};

local:main()