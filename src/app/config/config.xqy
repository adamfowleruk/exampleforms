(:
Copyright 2012 MarkLogic Corporation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
:)
xquery version "1.0-ml";

module namespace c = "http://marklogic.com/roxy/config";

import module namespace def = "http://marklogic.com/roxy/defaults" at "/roxy/config/defaults.xqy";

declare namespace rest = "http://marklogic.com/appservices/rest";

(:
 : ***********************************************
 : Overrides for the Default Roxy control options
 :
 : See /roxy/config/defaults.xqy for the complete list of stuff that you can override.
 : Roxy will check this file (config.xqy) first. If no overrides are provided then it will use the defaults.
 :
 : Go to https://github.com/marklogic/roxy/wiki/Overriding-Roxy-Options for more details
 :
 : ***********************************************
 :)
declare variable $c:ROXY-OPTIONS :=
  <options>    
    <layouts>
      <layout format="html">three-column</layout>
    </layouts>
  </options>;
  
(:
 : ***********************************************
 : Overrides for the Default Roxy control options
 :
 : See /roxy/config/defaults.xqy for the complete list of stuff that you can override.
 : Roxy will check this file (config.xqy) first. If no overrides are provided then it will use the defaults.
 :
 : Go to https://github.com/marklogic/roxy/wiki/Overriding-Roxy-Options for more details
 :
 : ***********************************************
 { $requests:ROUTES/rest:request }
 :)
declare variable $c:ROXY-ROUTES :=
  <routes xmlns="http://marklogic.com/appservices/rest">   
    { $c:ORBEON-ROUTES/request } 

    { $def:ROXY-ROUTES/rest:request }
  </routes>;


declare variable $c:ORBEON-ROUTES := 
  <routes xmlns="http://marklogic.com/appservices/rest">
    <request uri="^/crud/([^/]+)/([^/]+)/(data|draft)/([^/]+/[^/]+)$" endpoint="/roxy/query-router.xqy">
        <uri-param name="controller">orbeonapi-crud</uri-param>
        <uri-param name="func">crud-get</uri-param>
        <uri-param name="format">xml</uri-param>
        <uri-param name="application">$1</uri-param>
        <uri-param name="form">$2</uri-param>
        <uri-param name="type">$3</uri-param>
        <uri-param name="path">$4</uri-param>
        <http method="GET"/>
    </request>,
    <request uri="^/crud/([^/]+)/([^/]+)/(form)/([^/]+)$" endpoint="/roxy/query-router.xqy">
        <uri-param name="controller">orbeonapi-crud</uri-param>
        <uri-param name="func">crud-get</uri-param>
        <uri-param name="format">xml</uri-param>
        <uri-param name="application">$1</uri-param>
        <uri-param name="form">$2</uri-param>
        <uri-param name="type">$3</uri-param>
        <uri-param name="path">$4</uri-param>
        <http method="GET"/>
    </request>
    <request uri="^/crud/(orbeon)/(builder)/(data|draft)/([^/]+/[^/]+)$" endpoint="/roxy/update-router.xqy">
        <uri-param name="controller">orbeonapi-crud</uri-param>
        <uri-param name="func">crud-form-put</uri-param>
        <uri-param name="format">xml</uri-param>
        <uri-param name="application">$1</uri-param>
        <uri-param name="form">$2</uri-param>
        <uri-param name="type">$3</uri-param>
        <uri-param name="path">$4</uri-param>
        <http method="PUT"/>
    </request>
    <request uri="^/crud/([^/]+)/([^/]+)/(data|draft)/([^/]+/[^/]+)$" endpoint="/roxy/update-router.xqy">
        <uri-param name="controller">orbeonapi-crud</uri-param>
        <uri-param name="func">crud-put</uri-param>
        <uri-param name="format">xml</uri-param>
        <uri-param name="application">$1</uri-param>
        <uri-param name="form">$2</uri-param>
        <uri-param name="type">$3</uri-param>
        <uri-param name="path">$4</uri-param>
        <http method="PUT"/>
    </request>
    <request uri="^/crud/([^/]+)/([^/]+)/(form)/([^/]+)$" endpoint="/roxy/update-router.xqy">
        <uri-param name="controller">orbeonapi-crud</uri-param>
        <uri-param name="func">crud-form-put</uri-param>
        <uri-param name="format">xml</uri-param>
        <uri-param name="application">$1</uri-param>
        <uri-param name="form">$2</uri-param>
        <uri-param name="type">$3</uri-param>
        <uri-param name="path">$4</uri-param>
        <http method="PUT"/>
    </request>
    <request uri="^/crud/([^/]+)/([^/]+)/(data|draft)/([^/]+/[^/]+)$" endpoint="/roxy/update-router.xqy">
        <uri-param name="controller">orbeonapi-crud</uri-param>
        <uri-param name="func">crud-delete</uri-param>
        <uri-param name="format">xml</uri-param>
        <uri-param name="application">$1</uri-param>
        <uri-param name="form">$2</uri-param>
        <uri-param name="type">$3</uri-param>
        <uri-param name="path">$4</uri-param>
        <http method="DELETE"/>
    </request>
    <request uri="^/crud/([^/]+)/([^/]+)/(data)/$" endpoint="/roxy/update-router.xqy">
        <uri-param name="controller">orbeonapi-crud</uri-param>
        <uri-param name="func">crud-delete</uri-param>
        <uri-param name="format">xml</uri-param>
        <uri-param name="application">$1</uri-param>
        <uri-param name="form">$2</uri-param>
        <uri-param name="type">$3</uri-param>
        <http method="DELETE"/>
    </request>
     <request uri="^/search/([^/]+)/([^/]+)$" endpoint="/roxy/query-router.xqy">
      <uri-param name="controller">orbeonapi-search</uri-param>
      <uri-param name="func">search</uri-param>
      <uri-param name="format">xml</uri-param>
      <uri-param name="application">$1</uri-param>
      <uri-param name="form">$2</uri-param>
      <http method="POST"/>
    </request>
    <request uri="^/orbeon/(erdf)/([^/]+)/(data)/([^/]+/[^/]+)$" endpoint="/roxy/update-router.xqy" user-params="allow">
      <uri-param name="controller">orbeonapi-crud</uri-param>
      <uri-param name="func">crud-put</uri-param>
      <uri-param name="format">xml</uri-param>
      <uri-param name="application">$1</uri-param>
      <uri-param name="form">$2</uri-param>
      <uri-param name="type">$3</uri-param>
      <uri-param name="path">$4</uri-param>
      <http method="PUT"/>
    </request>
    <request uri="^/orbeon/(erdf)/([^/]+)/(data)/([^/]+/[^/]+)$" endpoint="/roxy/query-router.xqy" user-params="allow">
      <uri-param name="controller">orbeonapi-crud</uri-param>
      <uri-param name="func">crud-get</uri-param>
      <uri-param name="format">xml</uri-param>
      <uri-param name="application">$1</uri-param>
      <uri-param name="form">$2</uri-param>
      <uri-param name="type">$3</uri-param>
      <uri-param name="path">$4</uri-param>
      <http method="GET"/>
    </request>
    <request uri="^/orbeon/(erdf)/([^/]+)/(data)/([^/]+/[^/]+)$" endpoint="/roxy/update-router.xqy" user-params="allow">
      <uri-param name="controller">orbeonapi-crud</uri-param>
      <uri-param name="func">crud-delete</uri-param>
      <uri-param name="format">xml</uri-param>
      <uri-param name="application">$1</uri-param>
      <uri-param name="form">$2</uri-param>
      <uri-param name="type">$3</uri-param>
      <uri-param name="path">$4</uri-param>
      <http method="DELETE"/>
    </request>
     <request uri="^/form$" endpoint="/roxy/query-router.xqy">
      <uri-param name="controller">orbeonapi-form</uri-param>
      <uri-param name="func">form-get</uri-param>
      <uri-param name="format">xml</uri-param>
      <http method="GET"/>
    </request>
    <request uri="^/form/([^/]+)$" endpoint="/roxy/query-router.xqy">
      <uri-param name="controller">orbeonapi-form</uri-param>
      <uri-param name="func">form-get</uri-param>
      <uri-param name="format">xml</uri-param>
      <uri-param name="application">$1</uri-param>
      <http method="GET"/>
    </request>
    <request uri="^/form/([^/]+)/([^/]+)$" endpoint="/roxy/query-router.xqy">
      <uri-param name="controller">orbeonapi-form</uri-param>
      <uri-param name="func">form-get</uri-param>
      <uri-param name="format">xml</uri-param>
      <uri-param name="application">$1</uri-param>
      <uri-param name="form">$2</uri-param>
      <http method="GET"/>
    </request>
    <request uri="^/orbeon/(erdf)/([^/]+)/(form)/(form.xhtml)$" endpoint="/roxy/update-router.xqy">
      <uri-param name="controller">orbeonapi-crud</uri-param>
      <uri-param name="func">crud-form-put</uri-param>
      <uri-param name="format">xml</uri-param>
      <uri-param name="application">$1</uri-param>
      <uri-param name="form">$2</uri-param>
      <uri-param name="type">$3</uri-param>
      <uri-param name="path">$4</uri-param>
      <http method="PUT"/>
    </request>    
    <request uri="^/orbeon/(orbeon)/(builder)/(data|draft)/([^/]+/[^/]+)$" endpoint="/roxy/update-router.xqy">
        <uri-param name="controller">orbeonapi-crud</uri-param>
        <uri-param name="func">crud-form-put</uri-param>
        <uri-param name="format">xml</uri-param>
        <uri-param name="application">$1</uri-param>
        <uri-param name="form">$2</uri-param>
        <uri-param name="type">$3</uri-param>
        <uri-param name="path">$4</uri-param>
        <http method="PUT"/>
    </request>
     <request uri="^/([^/]+)/([^/]+)/(version)$" endpoint="/roxy/query-router.xqy">
        <uri-param name="controller">retrieve-versions-for-document</uri-param>
        <uri-param name="func">search-form-version</uri-param>
        <uri-param name="format">xml</uri-param>
        <uri-param name="doc-id">$2</uri-param>
        <http method="GET"/>
    </request>
  </routes>;


(:
 : ***********************************************
 : A decent place to put your appservices search config
 : and various other search options.
 : The examples below are used by the appbuilder style
 : default application.
 : ***********************************************
 :)
declare variable $c:DEFAULT-PAGE-LENGTH as xs:int := 5;

declare variable $c:SEARCH-OPTIONS :=
  <options xmlns="http://marklogic.com/appservices/search">
    <search-option>filtered</search-option>
    <term>
      <term-option>case-insensitive</term-option>
    </term>    
    <return-results>true</return-results>
    <return-query>true</return-query>
    <transform-results apply="raw"/> 
  </options>;

(:
 : Labels are used by appbuilder faceting code to provide internationalization
 :)
declare variable $c:LABELS :=
  <labels xmlns="http://marklogic.com/xqutils/labels">
    <label key="facet1">
      <value xml:lang="en">Sample Facet</value>
    </label>
  </labels>;
