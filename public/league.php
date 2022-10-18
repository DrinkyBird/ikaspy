<?php
    require_once '../common/common.php';
    
    $db = IkaSpy\connectDb();
    
    $now = floor(time());
    
    $filter_region = null;
    if (isset($_GET['region'])) {
        if ($_GET['region'] == 'EU' || $_GET['region'] == 'JP' || $_GET['region'] == 'US') {
            $filter_region = $_GET['region'];
        }
    }
    
    $filter_rotation = null;
    
    if (!isset($_GET['rotation'])) {
        $sql = "SELECT `rotation_id` FROM `league_teams` ORDER BY `rotation_id` DESC LIMIT 1";
        $stmt = $db->query($sql);
        $filter_rotation = $stmt->fetchColumn();
    } else {
        $filter_rotation = $_GET['rotation'];
    }
    
    $sql = "SELECT `id`, `name`, `image`, `sub`, `special` FROM `weapon_sets` ORDER BY `id` ASC";
    $stmt = $db->query($sql);
    $weaponSets = $stmt->fetchAll(PDO::FETCH_UNIQUE);
    
    $sql = "SELECT `id`, `name`, `image_a` AS `image` FROM `weapon_sub` ORDER BY `id` ASC";
    $stmt = $db->query($sql);
    $weaponSubs = $stmt->fetchAll(PDO::FETCH_UNIQUE);
    
    $sql = "SELECT `id`, `name`, `image_a` AS `image` FROM `weapon_special` ORDER BY `id` ASC";
    $stmt = $db->query($sql);
    $weaponSpecials = $stmt->fetchAll(PDO::FETCH_UNIQUE);
    
    $sql = "
        SELECT
            *
        FROM
            `rotations`
        WHERE
            `id` = :rotation_id
    ";
    $stmt = $db->prepare($sql);
    $stmt->bindParam(":rotation_id", $filter_rotation, PDO::PARAM_STR);
    $stmt->execute();
    $rotationInfo = $stmt->fetch();
    
    $sql = "SELECT `id`, `start_time` FROM `rotations` WHERE `start_time` < :start_time AND `start_time` < :now AND `type` = 2 ORDER BY `start_time` DESC LIMIT 1";
    $stmt = $db->prepare($sql);
    $stmt->bindParam(":start_time", $rotationInfo->start_time, PDO::PARAM_INT);
    $stmt->bindParam(":now", $now, PDO::PARAM_INT);
    $stmt->execute();
    $lastRotation = $stmt->fetch();
    
    $sql = "SELECT `id`, `start_time` FROM `rotations` WHERE `start_time` > :start_time AND `start_time` < :now AND `type` = 2 ORDER BY `start_time` ASC LIMIT 1";
    $stmt = $db->prepare($sql);
    $stmt->bindParam(":start_time", $rotationInfo->start_time, PDO::PARAM_INT);
    $stmt->bindParam(":now", $now, PDO::PARAM_INT);
    $stmt->execute();
    $nextRotation = $stmt->fetch();
    
    $sql = "SELECT * FROM `stages` WHERE `id` = :stage_id";
    $stmt = $db->prepare($sql);
    $stmt->bindParam(":stage_id", $rotationInfo->stage_a, PDO::PARAM_INT);
    $stmt->execute();
    $stageA = $stmt->fetch();
    $stmt = $db->prepare($sql);
    $stmt->bindParam(":stage_id", $rotationInfo->stage_b, PDO::PARAM_INT);
    $stmt->execute();
    $stageB = $stmt->fetch();
    
    $db->setAttribute(\PDO::MYSQL_ATTR_USE_BUFFERED_QUERY, false);
    
    function getLeagueData($mode)
    {
        global $db, $filter_rotation, $weaponSets, $weaponSpecials, $weaponSubs, $filter_region;
        
        $ret = [];
        
        $sql = "
            SELECT 
                * 
            FROM `league_teams` 
            WHERE 
                `league_teams`.`rotation_id` = :rotation_id 
            AND `league_teams`.`type` = :type
        ";
        if ($filter_region !== null) {
            $sql .= " AND `league_teams`.`region` = :region";
        }
        $sql .= "
            ORDER BY `league_teams`.`power` DESC
        ";
        $teamStatement = $db->prepare($sql);
        $teamStatement->bindParam(":rotation_id", $filter_rotation, PDO::PARAM_STR);
        $teamStatement->bindParam(":type", $mode, PDO::PARAM_INT);
        if ($filter_region !== null) {
            $teamStatement->bindParam(":region", $filter_region, PDO::PARAM_STR);
        }
        $teamStatement->execute();
        $teams = $teamStatement->fetchAll();
        
        $rank = 1;
        $previousPower = 0;
        
        foreach ($teams as $team) {
            $taa = [
                'team_id'           => $team->team_id,
                'power'             => $team->power,
                'rank'              => $rank,
                'region'            => $team->region,
                
                'members'           => []
            ];
        
            $sql = "
                SELECT
                    `league_members`.`player_id`,
                    `league_members`.`weapon_id`,
                    
                    `players`.`principal_id`,
                    `players`.`nickname` AS `player_name`,
                    `players`.`icon` AS `player_icon`
                FROM `league_members`, `players`
                WHERE
                    `league_members`.`rotation_id` = :rotation_id
                AND `league_members`.`team_id` = :team_id
                AND `players`.`principal_id` = `league_members`.`player_id`
            ";
            $members = $db->prepare($sql);
            $members->bindParam(":rotation_id", $filter_rotation, PDO::PARAM_STR);
            $members->bindParam(":team_id", $team->team_id, PDO::PARAM_STR);
            $members->execute();
            
            foreach ($members as $member) {
                $maa = [
                    'player_id'             =>  $member->player_id,
                    'player_nickname'       =>  $member->player_name,
                    'player_icon'           =>  $member->player_icon,
                    'weapon_id'             =>  $member->weapon_id
                ];
                
                array_push($taa['members'], $maa);
            }
        
            array_push($ret, $taa);
            
            if ($previousPower != $team->power) {
                $previousPower = $team->power;
                $rank++;
            }
        }
        
        return $ret;
    }
    
    $teamLeagueData = getLeagueData(1);
    $pairLeagueData = getLeagueData(0);
    
    $smarty = IkaSpy\createSmarty();
    $smarty->assign('filterRegion', $filter_region);
    $smarty->assign('rotationInfo', $rotationInfo);
    $smarty->assign('stageA', $stageA);
    $smarty->assign('stageB', $stageB);
    $smarty->assign('teamData', $teamLeagueData);
    $smarty->assign('pairData', $pairLeagueData);
    $smarty->assign('weaponSets', $weaponSets);
    $smarty->assign('weaponSubs', $weaponSubs);
    $smarty->assign('weaponSpecials', $weaponSpecials);
    $smarty->assign('lastRotation', $lastRotation);
    $smarty->assign('nextRotation', $nextRotation);
    $smarty->display('league.tpl');