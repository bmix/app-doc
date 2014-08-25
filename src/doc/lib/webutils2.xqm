(:~ 
: web utils
: @author andy bunce
: @since oct 2012
:)

module namespace web = 'quodatum.web.utils2';
declare default function namespace 'quodatum.web.utils2'; 

declare namespace rest = 'http://exquery.org/ns/restxq';
import module namespace session ="http://basex.org/modules/session";

declare variable $web:html5:=
<restxq:response>
    <output:serialization-parameters>
        <output:method value="html"/>
        <output:version value="5.0"/>
    </output:serialization-parameters>
   <http:response>
       <http:header name="apb" value='test'/> 
    </http:response>
</restxq:response>;

declare variable $web:xml:=
<restxq:response>
    <output:serialization-parameters>
        <output:method value="xml"/>
    </output:serialization-parameters>
   <http:response>
       <http:header name="apb" value='test'/> 
    </http:response>
</restxq:response>;

(:~ headers for serialisation  :) 
declare function method($method as xs:string){
switch ($method) 
   case "xml" return $web:xml
   case "html5" return $web:html5
   case "html" return $web:html5
   default return fn:error(xs:QName('web:method'),"bad method") 
};

(:~
: execute function fn if session has loggedin user with matching role else 401
:)
declare function role-check($role as xs:string,$fn){
  let $uid:=session:get("uid")
  return if($uid) then
        $fn()
         else http-auth("Whizz apb auth",())
};

(:~ return user of raise error if none
: @TODO role check
:)
declare function user($role as xs:string){
  let $uid:=session:get("uid")
  return if($uid) then
        $uid
        else fn:error(xs:QName('web:session-user'),"not logged in") 
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

(:~
: REST created http://restpatterns.org/HTTP_Status_Codes/201_-_Created
:)
declare updating function Uhttp-created($location,$response){
   db:output((
   <restxq:response>            
       <http:response status="201" >
           <http:header name="Location" value="{$location}"/>
       </http:response>
   </restxq:response>,
   $response
   ))
};

(:~
: redirect to ..
:)
declare function redirect($url as xs:string) 
 {
        <rest:response>         
           <http:response status="303" >
             <http:header name="Location" value="{$url}"/>
           </http:response>                      
       </rest:response>
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