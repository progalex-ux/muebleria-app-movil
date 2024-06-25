<?php
header("Access-Control-Allow-Origin: *");
include("dbconnection.php");
$connection = dbconnection();

$query = "SELECT `id`, `price`, `description`, `image_path` FROM `products`"; 
$exe = mysqli_query($connection, $query);

$arr = [];

while ($row = mysqli_fetch_assoc($exe)) {
    $arr[] = $row;
}

print(json_encode($arr));
?>
