<?php
    require_once '../common/common.php';
    
    $db = IkaSpy\connectDb();
    
    $sql = "SELECT COUNT(`players`.`principal_id`) FROM `players`";
    $stmt = $db->query($sql, \PDO::FETCH_COLUMN, 1);
    $playerCount = $stmt->fetchColumn();
    
    $sql = "SELECT  `players`.* FROM `players` ";
    $playerInfo = $db->query($sql);
    
    $smarty = IkaSpy\createSmarty();
    $smarty->assign('playerCount', $playerCount);
    $smarty->assign('playerInfo', $playerInfo);
    $smarty->display('players.tpl');