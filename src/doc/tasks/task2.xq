(:~
 : Create or update database "doc-doc" from files in the folder data/doc 
 :)

declare namespace task="https://github.com/Quodatum/app-doc/task";
import module namespace dbtools = 'quodatum.dbtools'  at "../lib/dbtools.xqm";

let $db:="doc-doc" 
let $src:=fn:resolve-uri("../data/doc")
return (dbtools:sync-from-path($db,$src),db:output("dbsync"))