(:~ 
: web utils
: @author andy bunce
: @since oct 2012
:)

module namespace qweb = 'quodatum.web.utils4';
declare default function namespace 'quodatum.web.utils4'; 
import module namespace request = "http://exquery.org/ns/request";
declare namespace rest = 'http://exquery.org/ns/restxq';

(:~ map of available dice parameters :)
declare function dice(){
    let $fld:=function($n){
                        request:parameter($n)!map:entry($n,request:parameter($n))
                           }
    return map:merge(("start","limit","sort","fields")!$fld(.))
};

declare function status($code,$reason){
   <rest:response>            
       <http:response status="{$code}" reason="{$reason}"/>
   </rest:response>
};

(:~
: REST created http://restpatterns.org/HTTP_Status_Codes/401_-_Unauthorized
:)
declare function http-auth($auth-scheme,$response){
   (
   <rest:response>            
       <http:response status="401" >
	       <http:header name="WWW-Authenticate" value="{$auth-scheme}"/>
	   </http:response>
   </rest:response>,
   $response
   )
};

(:~
: REST created http://restpatterns.org/HTTP_Status_Codes/201_-_Created
:)
declare function http-created($location,$response){
   (
   <rest:response>            
       <http:response status="201" >
	       <http:header name="Location" value="{$location}"/>
	   </http:response>
   </rest:response>,
   $response
   )
};


(:~ CORS header with download option :) 
declare function headers($attachment,$response){
(<restxq:response>
    <http:response>
        <http:header name="Access-Control-Allow-Origin" value="*"/>
    {if($attachment)
    then <http:header name="Content-Disposition" value='attachment;filename="{$attachment}"'/>
    else ()}
    </http:response>
</restxq:response>, $response)
};

(:~ download as zip file :) 
declare function zip-download($zipname,$data){
    (download-response("raw",$zipname), $data)
};

(:~ headers for download  :) 
declare function method($method as xs:string){
<restxq:response>
    <output:serialization-parameters>
        <output:method value="{$method}"/>
    </output:serialization-parameters>
</restxq:response>
};

(:~ headers for download  :) 
declare function download-response($method,$filename){

<restxq:response>
    <output:serialization-parameters>
        <output:method value="{$method}"/>
    </output:serialization-parameters>
   <http:response>
       <http:header name="Content-Disposition" value='attachment;filename="{$filename}"'/> 
    </http:response>
</restxq:response>
};

(:~
 : transform xml to json serialable xml driven by @type="array" and convention.
 : all namespaces are removed
 :)
declare function fixup($n){fixup($n,"object")}; 
declare function fixup($n,$type)
{
let $n:=strip-ns($n)
let $a:=<json type="{$type}">{$n/*}</json>
return copy $c := $a
modify (
            (: for nodes with no @type and have children set @type="object" :)
            for $type in $c//*[fn:not(@type)and *]
            return insert node attribute {'type'}{'object'} into $type,
            (: for node with @type="array" and children rename children to "_" :)
            for $n in $c//*[@type="array"]/*
            return rename node $n as "_"
        )
return $c
};

declare function strip-ns($n as node()) as node() {
  if($n instance of element()) then (
    element { fn:local-name($n) } {
      $n/@*,
      $n/node()/strip-ns(.)
    }
  ) else if($n instance of document-node()) then (
    document { $n/node() }
  ) else (
    $n
  )
};

(:~ todo use basex mime :)
declare function svg-response(){
    web:response-header(map { 'media-type': "image/svg+xml",
                              'method':"xml"})
};
 
declare function json-response(){
    web:response-header(map { 'media-type': "application/json",
                              'method':"json"})
};