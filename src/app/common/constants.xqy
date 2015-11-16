xquery version "3.0";

module namespace c = "http://marklogic.com/orbeon-ml-api/ns/common/constants";

declare variable $c:LOGS-BASE-URI := "/orbeon/erdf/";

declare variable $c:IRI-PREFIX := "http://marklogic.com/orbeon-ml-api/ns";
declare variable $c:ENTITY-PATH-SUFFIX := "/data.xml";
declare variable $c:IRI-RDF-TYPE := "http://www.w3.org/1999/02/22-rdf-syntax-ns#type";

declare variable $c:CREATED-FOR := 'created-for';
declare variable $c:CREATED-FROM := 'created-from';
declare variable $c:HAS-DOC-URI := 'has-doc-uri';
declare variable $c:BELONGS-TO := 'belongs-to';

declare variable $c:IRI-BELONGS-TO := fn:concat( $c:IRI-PREFIX,'/', $c:BELONGS-TO);
declare variable $c:IRI-CREATED-FOR := fn:concat( $c:IRI-PREFIX,'/', $c:CREATED-FOR);
declare variable $c:IRI-CREATED-FROM := fn:concat( $c:IRI-PREFIX,'/', $c:CREATED-FROM);
declare variable $c:IRI-HAS-DOC-URI := fn:concat( $c:IRI-PREFIX,'/', $c:HAS-DOC-URI);

declare variable $c:DATA-XML-EXT := "/data.xml";
declare variable $c:XML-EXT := ".xml";
declare variable $c:_SLASH := "/";

