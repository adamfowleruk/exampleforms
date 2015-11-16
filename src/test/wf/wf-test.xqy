xquery version "3.0";

import module namespace wfu = "http://marklogic.com/workflow/util"   at "/app/models/util-workflow.xqy";
import module namespace wfs = "http://marklogic.com/workflow/search" at "/app/models/search-workflow.xqy";

declare namespace xdmp = "http://marklogic.com/xdmp";

declare %private function local:check-process-complete($pid, $count, $sleep, $checker)
as xs:boolean
{
    if ( $checker() ) then
        let $___________ := xdmp:log('w:check-process-complete: TRUE', "debug")
        return
            fn:true()
    else if ( $count gt 20 ) then
        fn:false()
    else
        let $___________ := xdmp:log('w:check-process-complete: LOOP', "debug")
        return
            local:check-process-complete($pid, $count + 1, xdmp:sleep(200), $checker)
};

(:~
 : Top-level controller for "has process ended?" predicate.
 :)
declare function local:has-process-ended(
   $id   as xs:string,
   $type as xs:string
) as xs:string
{
   let $pid := wfu:retriev-process-id($id, $type)


   let $res := local:check-process-complete($pid, 0, xdmp:sleep(200),
                    function() {
                        wfs:is-process-completed($pid)
                    }
   )

   return
      if ( $res ) then
         'true'
      else
         'false'


};

(:~
 : Top-level role-checking controller.
 :)
declare function local:check-role-assignment(
   $id   as xs:string,
   $type as xs:string,
   $role as xs:string
) as xs:string
{
   try {
      let $pid := wfu:retriev-process-id($id, $type)
      let $res := wfu:check-role-assignment-done($pid, $role)
      return
         if ( $res ) then
            'true'
         else
            'false'
   }
   catch * {
      'false'
   }
};

(:~
 : Top-level user-checking controller.
 :)
declare function local:check-user-assignment(
   $id   as xs:string,
   $type as xs:string,
   $user as xs:string
) as xs:string
{
   try {
      let $pid := wfu:retriev-process-id($id, $type)
      let $res := wfu:check-assignment-done($pid, $user)
      return
         if ( $res ) then
            'true'
         else
            'false'
   }
   catch * {
      'false'
   }
};

(: Extract the URL parameters, and dispatch to the right implementation.
 :)
let $func := xdmp:get-request-field('func')
let $id   := xdmp:get-request-field('id')
let $type := xdmp:get-request-field('type')
let $user := xdmp:get-request-field('user')
let $role := xdmp:get-request-field('role')
return
   switch ( $func )
      case 'has-process-ended' return
         local:has-process-ended($id, $type)
      case 'check-user-assignment' return
         local:check-user-assignment($id, $type, $user)
      case 'check-role-assignment' return
         local:check-role-assignment($id, $type, $role)
      default return
         xdmp:set-response-code(404, 'Not found')
