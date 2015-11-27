xquery version "1.0-ml";

module namespace c = "http://marklogic.com/roxy/controller/orbeonapi-form";

import module namespace ch = "http://marklogic.com/roxy/controller-helper" at "/roxy/lib/controller-helper.xqy";
import module namespace req = "http://marklogic.com/roxy/request" at "/roxy/lib/request.xqy";

declare namespace xh = "http://www.w3.org/1999/xhtml";
declare namespace xf = "http://www.w3.org/2002/xforms";

declare option xdmp:mapping "false";


declare function c:form-get() as item()* 
{
    let $application := xdmp:get-request-field('application')
    let $form := xdmp:get-request-field('form')
    let $root := xdmp:get-request-header('Orbeon-Root', '/orbeon')
    let $full-path := string-join(($root, $application, $form, ''), '/')
    let $null :=  xdmp:log("forms.xqy --->"|| $form || $root || $full-path, "info")
    return 
        <forms>
        {
            for $form in cts:search(/, cts:directory-query($full-path, "infinity"))
                let $metadata := $form/xh:html/xh:head/xf:model[@id="fr-form-model"]/xf:instance[@id="fr-form-metadata"]/metadata
                let $updated := $form/property::prop:last-modified
                where matches(document-uri($form), '/[^/]+/[^/]+/form/form.xhtml')
                return <form>
                {(
                    $metadata/*,
                    <last-modified-time>{string($updated)}</last-modified-time>
                )}
                </form>
        }
        </forms>
};