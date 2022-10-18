<?php
    require_once '../common/common.php';
    
    $now = time();
    
    $db = IkaSpy\connectDb();
    
    $sql = "SELECT * FROM `stages`";
    $stmt = $db->query($sql);
    $stages = $stmt->fetchAll();
    
    $stagesAssoc = [];
    foreach ($stages as $stage) {
        $stagesAssoc[$stage->id] = $stage;
    }
    
    $sql = "SELECT * FROM `rotations` WHERE `end_time` > :now ORDER BY `start_time` ASC, `type`";
    $stmt = $db->prepare($sql);
    $stmt->bindParam(":now", $now, PDO::PARAM_INT);
    $stmt->execute();
    $rotations = $stmt->fetchAll();
    
    $smarty = IkaSpy\createSmarty();
    $smarty->assign("stages", $stagesAssoc);
    $smarty->assign("rotations", $rotations);
    $smarty->display('rotations.tpl');
?>