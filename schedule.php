<?php
if($_GET["id"] == "1") {
  $classes = array();
  $classes[] = array (
    "name" => "Ma 5a",
    "section" => 1,
    "color" => "#f84",
    "times" => array (
        array (
          "days" => array(1=>true, 2=>false, 3=>true,4=>false,5=>true),
          "start" => "09:00",
          "end" => "09:55",
          "location" => "151 SLN",
          "instructor" => null
          )
      )
  );
  $classes[] = array (
    "name" => "Ma 6a",
    "section" => 1,
    "color" => "#4f8",
    "times" => array (
      array (
        "days" => array(1 => true, 2 => false, 3 => true, 4 => false, 5 => true),
        "start" => "13:00",
        "end" => "13:55",
        "location" => "151 SLN",
        "instructor" => null
      )
    )
  );
  die(json_encode($classes));
} elseif($_GET["id"] == "2") {
  $classes = array();
  $classes[] = array(
    "name" => "Ma 108a",
    "section" => 1,
    "color" => "#48f",
    "times" => array(
        array(
          "days" => array(1=>true, 2=>false, 3=>true,4=>false,5=>true),
          "start" => "11:00",
          "end" => "11:55",
          "location" => "151 SLN",
          "instructor" => null
          )
      )
  );
  $classes[] = array (
    "name" => "Ph 2a",
    "section" => 1,
    "color" => "#4f8",
    "times" => array (
      array (
        "days" => array(1 => false, 2 => true, 3 => false, 4 => true, 5 => false),
        "start" => "11:30",
        "end" => "12:55",
        "location" => "151 SLN",
        "instructor" => null
      ),
      array (
        "days" => array(1 => false, 2 => false, 3 => false, 4 => false, 5 => true),
        "start" => "15:00",
        "end" => "15:55",
        "location" => "151 SLN",
        "instructor" => null
      )
    )
  );
  die(json_encode($classes));
} else {
  die("[]");
}
?>