<?php
$DBH = new PDO("mysql:host=localhost;dbname=sched", 'sched', 'sched');
$DBH->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
?>