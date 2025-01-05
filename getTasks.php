<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$con = mysqli_connect("localhost", "root", "", "todo");

if (mysqli_connect_errno()) {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$sql = "Select * FROM tasks";

if ($result = mysqli_query($con, $sql)) {
  $taskArray = array();
  while ($row = mysqli_fetch_assoc($result))
    $taskArray[] = $row;

  echo json_encode($taskArray);

  mysqli_free_result($result);
  mysqli_close($con);
}
?>