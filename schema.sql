SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


CREATE TABLE `league_members` (
  `rotation_id` varchar(8) NOT NULL,
  `team_id` varchar(12) NOT NULL,
  `player_id` varchar(16) NOT NULL,
  `weapon_id` int(11) NOT NULL,
  `splatnet_id` varchar(24) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `league_teams` (
  `rotation_id` varchar(8) NOT NULL,
  `team_id` varchar(12) NOT NULL,
  `type` int(11) NOT NULL COMMENT '0 = pair; 1 = team',
  `power` decimal(5,1) NOT NULL,
  `rank` int(11) NOT NULL COMMENT 'regional',
  `cheater` tinyint(1) NOT NULL,
  `region` varchar(2) NOT NULL COMMENT 'NA, EU, or JP'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `players` (
  `principal_id` varchar(16) NOT NULL,
  `nickname` varchar(32) NOT NULL,
  `icon` varchar(256) DEFAULT NULL,
  `last_updated` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `rank_x` (
  `splatnet_id` varchar(20) NOT NULL,
  `mode` tinyint(4) NOT NULL COMMENT '0=Splat Zones; 1 = Tower Control; 2 = Rainmaker; 3 = Clam Blitz',
  `rank_change` tinyint(4) NOT NULL,
  `rank` int(11) NOT NULL,
  `period` int(11) NOT NULL COMMENT 'YYYYMM',
  `player_id` varchar(16) NOT NULL,
  `power` decimal(5,1) NOT NULL,
  `cheater` tinyint(1) NOT NULL,
  `weapon_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `rotations` (
  `id` varchar(8) NOT NULL,
  `start_time` bigint(20) NOT NULL,
  `end_time` bigint(20) NOT NULL,
  `type` int(11) NOT NULL COMMENT '0=regular/1=ranked/2=league',
  `mode` int(11) NOT NULL COMMENT '0=sz/1=tc/2=rm/3=cb',
  `stage_a` int(11) NOT NULL,
  `stage_b` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `stages` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `image` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `weapon_sets` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `thumbnail` varchar(256) NOT NULL,
  `image` varchar(256) NOT NULL,
  `sub` int(11) NOT NULL,
  `special` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `weapon_special` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `image_a` varchar(256) DEFAULT NULL,
  `image_b` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `weapon_sub` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `image_a` varchar(256) DEFAULT NULL,
  `image_b` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


ALTER TABLE `league_members`
  ADD PRIMARY KEY (`rotation_id`,`team_id`,`player_id`),
  ADD KEY `league_member_player_id` (`player_id`),
  ADD KEY `league_member_weapon_id` (`weapon_id`);

ALTER TABLE `league_teams`
  ADD PRIMARY KEY (`rotation_id`,`team_id`);

ALTER TABLE `players`
  ADD PRIMARY KEY (`principal_id`);

ALTER TABLE `rank_x`
  ADD PRIMARY KEY (`mode`,`period`,`player_id`),
  ADD KEY `player_principal_id` (`player_id`),
  ADD KEY `ranking_weapon` (`weapon_id`);

ALTER TABLE `rotations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rotation_stage_a` (`stage_a`),
  ADD KEY `rotation_stage_b` (`stage_b`);

ALTER TABLE `stages`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `weapon_sets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `weapon_special` (`special`),
  ADD KEY `weapon_sub` (`sub`);

ALTER TABLE `weapon_special`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `weapon_sub`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `league_members`
  ADD CONSTRAINT `league_member_player_id` FOREIGN KEY (`player_id`) REFERENCES `players` (`principal_id`),
  ADD CONSTRAINT `league_member_team_id` FOREIGN KEY (`rotation_id`,`team_id`) REFERENCES `league_teams` (`rotation_id`, `team_id`),
  ADD CONSTRAINT `league_member_weapon_id` FOREIGN KEY (`weapon_id`) REFERENCES `weapon_sets` (`id`);

ALTER TABLE `rank_x`
  ADD CONSTRAINT `player_principal_id` FOREIGN KEY (`player_id`) REFERENCES `players` (`principal_id`),
  ADD CONSTRAINT `ranking_weapon` FOREIGN KEY (`weapon_id`) REFERENCES `weapon_sets` (`id`);

ALTER TABLE `rotations`
  ADD CONSTRAINT `rotation_stage_a` FOREIGN KEY (`stage_a`) REFERENCES `stages` (`id`),
  ADD CONSTRAINT `rotation_stage_b` FOREIGN KEY (`stage_b`) REFERENCES `stages` (`id`);

ALTER TABLE `weapon_sets`
  ADD CONSTRAINT `weapon_special` FOREIGN KEY (`special`) REFERENCES `weapon_special` (`id`),
  ADD CONSTRAINT `weapon_sub` FOREIGN KEY (`sub`) REFERENCES `weapon_sub` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
