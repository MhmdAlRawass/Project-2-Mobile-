<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$con = mysqli_connect("localhost", "root", "", "todo");

if (mysqli_connect_errno()) {
    echo json_encode(['status' => 'error', 'message' => 'Failed to connect to MySQL: ' . mysqli_connect_error()]);
    exit();
}

$taskId = $_GET['taskId'];


$sql = "DELETE FROM tasks WHERE db_id =$taskId";

mysqli_query($con, $sql);

mysqli_close($con);



?>