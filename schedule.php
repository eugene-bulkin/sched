<?php
$id = $_GET["id"];

$classData = new stdClass();
$classData->name = "?";
$classData->section = null;
$classData->times = array();
$classData->color = "#" . "999999";

$time = new stdClass();
$time->days = array(1 => false, 2 => true, 3 => false, 4 => false, 5 => false);
$time->start = "09:00";
$time->end = "09:55";
$time->location = "";
$time->instructor = "";
$classData->times[] = $time;

echo json_encode(array("id" => $id, "classes" => array($classData)));