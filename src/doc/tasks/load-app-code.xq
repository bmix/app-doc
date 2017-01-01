(:~
 : update database "doc-{$app}" with generated xquery documentation (xqdoc)
 : for all *,xq and *.xqm files in app 
 :)
declare namespace task="https://github.com/Quodatum/app-doc/task";
declare namespace xqdoc="http://www.xqdoc.org/1.0";

import module namespace doc = 'quodatum.doc' at "../doctools.xqm";
import module namespace df = 'quodatum.doc.file' at "../lib/files.xqm";
declare variable $app external :="doc";

let $db:="doc-doc" 
let $src:=df:webpath($app || "/")

let $files:=df:dir($src,"*.xqm,*.xq")
return (db:output("modules processed: " || count($files) )
         ,for $file in $files   
        let $doc:=doc:xqdoc("app",$src ||$file)
        let $path:="/apps/" || $app || "/" || $file
        return db:replace($db,$path,$doc) 
        )