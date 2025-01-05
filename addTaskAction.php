<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$con = mysqli_connect("localhost", "root", "", "todo");

if(mysqli_connect_errno()){
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  exit();
}
$data = json_decode(file_get_contents("php://input"), true);

if(isset($data['desc']) && isset($data['date']) && isset($data['startTime']) && isset($data['isImportant']) && isset($data['categoryId'])) {
    $desc = $data['desc'];
    $date = $data['date']; 
    $startTime = $data['startTime']; 
    $isImportant = $data['isImportant'] ? 1 : 0;
    $categoryId = $data['categoryId'];

    $sql = "INSERT INTO tasks (db_description, db_date, db_startTime, db_isImportant, db_categoryId) 
            VALUES ('$desc', '$date', '$startTime', $isImportant, $categoryId)";

    if(mysqli_query($con, $sql)) {
        echo json_encode(["status" => "success", "message" => "Task added successfully."]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to add task."]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Missing required fields."]);
}

mysqli_close($con);
?>
