<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$con = mysqli_connect("localhost", "root", "", "todo");

if (mysqli_connect_errno()) {
    echo json_encode(['status' => 'error', 'message' => 'Failed to connect to MySQL: ' . mysqli_connect_error()]);
    exit();
}

$taskId = isset($_GET['taskId']) ? (int) $_GET['taskId'] : null;
$isDoneBool = isset($_GET['isDone']) ? $_GET['isDone'] : null;

if ($taskId === null || $isDoneBool === null) {
    echo json_encode(['status' => 'error', 'message' => 'Missing taskId or isDone parameter.']);
    exit;
}

$isDone = ($isDoneBool === 'true') ? 1 : 0;

$categoryId = $_GET['cid'];

$sql = "UPDATE tasks SET db_isDone = $isDone WHERE db_id = $taskId";
if (mysqli_query($con, $sql)) {

    $sqlCount = "SELECT COUNT(*) as doneCount FROM tasks WHERE db_isDone = 1 AND db_categoryId =$categoryId";
    $result = mysqli_query($con, $sqlCount);

    if ($result) {
        $row = mysqli_fetch_assoc($result);
        $doneCount = $row['doneCount'];

        echo json_encode(['status' => 'success', 'doneCount' => $doneCount]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to count completed tasks.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Failed to update task status.']);
}

mysqli_close($con);

?>