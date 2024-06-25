<?php 
 
   function dbconnection(){
    $connection=mysqli_connect("localhost","root","","camilamueblerias");
    return $connection;
   } 

?>