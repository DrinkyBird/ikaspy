<?php
    require_once '../common/common.php';
    
    $filter_id = filter_input(INPUT_GET, 'id', FILTER_DEFAULT, [
        'options' => [
            'default' => null,
        ]
    ]);
    
    $db = IkaSpy\connectDb();
    $sql = "SELECT * FROM `players` WHERE `principal_id` = :id";
    $stmt = $db->prepare($sql);
    $stmt->bindParam(":id", $filter_id, PDO::PARAM_STR);
    $stmt->execute();
    $playerInfo = $stmt->fetch();
    
    $sql = "
        SELECT 
            `rank_x`.*,
            `weapon_sets`.`name` AS `weapon_name`, `weapon_sets`.`thumbnail` AS `weapon_image`,
            `weapon_sub`.`name` AS `sub_name`, `weapon_sub`.`image_a` AS `sub_image`,
            `weapon_special`.`name` AS `special_name`, `weapon_special`.`image_a` AS `special_image`
        FROM `rank_x`, `weapon_sets`, `weapon_sub`, `weapon_special`
        WHERE
            `player_id` = :id
        AND `weapon_id` = `weapon_sets`.`id`
        AND `weapon_sets`.`sub` = `weapon_sub`.`id`
        AND `weapon_sets`.`special` = `weapon_special`.`id`
        ORDER BY period DESC
    ";
    
    $stmt = $db->prepare($sql);
    $stmt->bindParam(":id", $filter_id, PDO::PARAM_STR);
    $stmt->execute();
    $xranks = $stmt->fetchAll();
    
    $sql = "
        SELECT 
            `league_members`.`rotation_id`, `league_members`.`team_id`, `league_members`.`weapon_id`, 
            `league_teams`.`type` AS `league_type`, `league_teams`.`power` AS `league_power`, `league_teams`.`rank` AS `league_rank`, `league_teams`.`region` AS `league_region`,
            `rotations`.`start_time` AS `rotation_start_time`,
            `weapon_sets`.`name` AS `weapon_name`, `weapon_sets`.`thumbnail` AS `weapon_image`,
            `weapon_sub`.`name` AS `sub_name`, `weapon_sub`.`image_a` AS `sub_image`,
            `weapon_special`.`name` AS `special_name`, `weapon_special`.`image_a` AS `special_image`
        FROM
            `league_members`, `league_teams`, `rotations`, `weapon_sets`, `weapon_sub`, `weapon_special`
        WHERE
            `player_id` = :id
        AND `league_teams`.`rotation_id` = `league_members`.`rotation_id`
        AND `league_teams`.`team_id` = `league_members`.`team_id`
        AND `rotations`.`id` = `league_members`.`rotation_id`
        AND `league_members`.`weapon_id` = `weapon_sets`.`id`
        AND `weapon_sets`.`sub` = `weapon_sub`.`id`
        AND `weapon_sets`.`special` = `weapon_special`.`id`
    ";
    $stmt = $db->prepare($sql);
    $stmt->bindParam(":id", $filter_id, PDO::PARAM_STR);
    $stmt->execute();
    $leagues = $stmt->fetchAll();
    
    $smarty = IkaSpy\createSmarty();
    $smarty->assign('id', $filter_id);
    $smarty->assign('playerInfo', $playerInfo);
    $smarty->assign('xranks', $xranks);
    $smarty->assign('leagues', $leagues);
    $smarty->display('player.tpl');