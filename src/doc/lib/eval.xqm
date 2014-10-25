(:~ 
 :execute xquery code from string
 :@author Andy Bunce
 :@version 0.1
 :)
module namespace eval = 'quodatum.eval';
declare default function namespace 'quodatum.eval';
declare namespace task ="https://github.com/Quodatum/app-doc/task";

 
declare variable $eval:def-opts:=map{
     "permission" := "create",
     "timeout":=5
 };
  
(:~ eval list of tasks
 :)
declare function do-tasks($names as xs:string*){
   let $name:=fn:trace($names,"tasks: ")
   let $tasks:=fn:doc("../data/tasks.xml")/task:tasks/task:task
   return for $name in $names
          let $task:=$tasks[@name=$name]/task:xquery
          let $res:=eval($task,5)
          return fn:trace($res,$name || ": ")
};

(:~
 : execute string with update pre basex 8
 : return sequence head() is elapsed time or -1 if error, tail() is result or error code
 :)
declare function eval2($xq as xs:string,$timeout as xs:double)
as item()*{
    let $xq:= 'declare base-uri "' || fn:resolve-uri("..") ||'";&#10;' || $xq 
    let $xq:=fn:trace($xq,"eval2 ")
    return try {
              (:  let $t1:=prof:current-ms() :)
                let $x:=client:connect('localhost', 1984, 'admin', 'admin') !client:query(.,$xq)
               (: let $t:=(prof:current-ms()-$t1) div 1000 :)
                return (0,$x)
           }catch * {
                (-1 ,$err:code)
           }    
};

(:~
 : execute string
 : return sequence head() is elapsed time or -1 if error, tail() is result or error code
 :)
declare function eval($xq as xs:string,$timeout as xs:double)
as item()*{
 let $bindings:=map{}
 let $opts:=map {
     "permission" := "create",
     "timeout":=$timeout
  }
  let $xq:= 'declare base-uri "' || fn:resolve-uri("..") ||'";&#10;' || $xq
  return try{
       let $t1:=prof:current-ms()
       let $x:= xquery:eval($xq,$bindings,$opts)
       let $t:=(prof:current-ms()-$t1) div 1000
       return ($t,$x)
      }catch * 
      {
        (-1 ,$err:code)
      }
};
