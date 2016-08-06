-- phpMyAdmin SQL Dump
-- version 3.4.10.1
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2015 年 06 月 07 日 06:13
-- 服务器版本: 5.5.20
-- PHP 版本: 5.3.10

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `waf`
--

-- --------------------------------------------------------

--
-- 表的结构 `sql_log`
--

CREATE TABLE IF NOT EXISTS `sql_log` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `url` text NOT NULL,
  `type` tinyint(4) NOT NULL COMMENT '1 get 2post',
  `data` text NOT NULL,
  `is_bad` tinyint(1) NOT NULL,
  `bad_key` tinytext NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `statu` tinyint(4) DEFAULT NULL,
  `token` varchar(50) DEFAULT NULL,
  `count` int(11) DEFAULT '1',
  `ip` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=157 ;

--
-- 转存表中的数据 `sql_log`
--

INSERT INTO `sql_log` (`id`, `url`, `type`, `data`, `is_bad`, `bad_key`, `time`, `statu`, `token`, `count`, `ip`) VALUES
(72, '/hello?a=123%27%20or%201=%271', 0, '{"/hello?a": "123'' or 1=''1"}', 1, '{"/hello?a": "123'' or 1=''1"}', '2015-06-06 12:39:29', 0, 'e1db2125cb067e056051ef86bb1f210df55750ff', 6, '127.0.0.1'),
(70, '/favicon.ico', 0, '{"/favicon.ico": ""}', 0, '{}', '2015-06-06 12:37:34', 0, 'f0fde5199587ed9d500945e7c501d18ca13ce4a7', 1, '127.0.0.1'),
(71, '/hello?a=123', 0, '{"/hello?a": "123"}', 0, '{}', '2015-06-06 12:37:37', 0, 'e4554835dc371a516aac0e6d3d44b72a72291194', 2, '127.0.0.1'),
(73, '/hello', 1, '{"a": "1 union all select 1,2,3,4,5,6,name from sysobjects where xtype = ''u'' --\\n", "b": "1 union all select 1,2,3,4,5,6,name from sysobjects where xtype = ''u'' --\\n"}', 1, '{"a": "1 union all select 1,2,3,4,5,6,name from sysobjects where xtype = ''u'' --\\n"}', '2015-06-07 05:46:02', 0, '0fd0d6eb98236bac4a030ef23326144accd12778', 8, '127.0.0.1'),
(74, '/hello?a=1+union+all+select+1%2C2%2C3%2C4%2C5%2C6%2Cname+from+sysobjects+where+xtype+%3D+%27u%27+--%0A&b=1+union+all+select+1%2C2%2C3%2C4%2C5%2C6%2Cname+from+sysobjects+where+xtype+%3D+%27u%27+--%0A', 0, '{"a": "1 union all select 1,2,3,4,5,6,name from sysobjects where xtype = ''u'' --\\n", "b": "1 union all select 1,2,3,4,5,6,name from sysobjects where xtype = ''u'' --\\n"}', 1, '{"a": "1 union all select 1,2,3,4,5,6,name from sysobjects where xtype = ''u'' --\\n"}', '2015-06-07 05:46:02', 0, '77fe336a79c1c5a063a1ca65cf32454a96ee3623', 7, '127.0.0.1'),
(75, '/hello', 1, '{"a": "1 uni/**/on select all from where\\n", "b": "1 uni/**/on select all from where\\n"}', 1, '{"a": "1 uni/**/on select all from where\\n"}', '2015-06-07 05:46:02', 0, 'f02afc09bbb9afc13f7105c43759800c312b1c6d', 7, '127.0.0.1'),
(76, '/hello?a=1+uni%2F%2A%2A%2Fon+select+all+from+where%0A&b=1+uni%2F%2A%2A%2Fon+select+all+from+where%0A', 0, '{"a": "1 uni/**/on select all from where\\n", "b": "1 uni/**/on select all from where\\n"}', 1, '{"a": "1 uni/**/on select all from where\\n"}', '2015-06-07 05:46:02', 0, '837e68f21b65bbee174fade12b2d4d94dc7512c3', 7, '127.0.0.1'),
(77, '/hello', 1, '{"a": "? or 1=1 --\\n", "b": "? or 1=1 --\\n"}', 1, '{"a": "? or 1=1 --\\n"}', '2015-06-07 05:46:02', 0, '0dbb9a63fa55812a4bb8b712da29a57ba3b81a47', 7, '127.0.0.1'),
(78, '/hello?a=%3F+or+1%3D1+--%0A&b=%3F+or+1%3D1+--%0A', 0, '{"a": "? or 1=1 --\\n", "b": "? or 1=1 --\\n"}', 1, '{"a": "? or 1=1 --\\n"}', '2015-06-07 05:46:02', 0, '94d8f39e3d6125daae9799e7156fbc6306578594', 7, '127.0.0.1'),
(79, '/hello', 1, '{"a": "x'' and userid is NULL; --\\n", "b": "x'' and userid is NULL; --\\n"}', 1, '{"a": "x'' and userid is NULL; --\\n"}', '2015-06-07 05:46:02', 0, '35a579e6cd31a1d21c1cbbfdd4221cc0ba9987cc', 7, '127.0.0.1'),
(80, '/hello?a=x%27+and+userid+is+NULL%3B+--%0A&b=x%27+and+userid+is+NULL%3B+--%0A', 0, '{"a": "x'' and userid is NULL; --\\n", "b": "x'' and userid is NULL; --\\n"}', 1, '{"a": "x'' and userid is NULL; --\\n"}', '2015-06-07 05:46:02', 0, '3559ab4f6dda1c88195ad606f8500d28d787cc49', 7, '127.0.0.1'),
(81, '/hello', 1, '{"a": "x'' and email is NULL; --\\n", "b": "x'' and email is NULL; --\\n"}', 1, '{"a": "x'' and email is NULL; --\\n"}', '2015-06-07 05:46:02', 0, 'd519ee097bc12b51082707d51f2af604cb9fdcc3', 7, '127.0.0.1'),
(82, '/hello?a=x%27+and+email+is+NULL%3B+--%0A&b=x%27+and+email+is+NULL%3B+--%0A', 0, '{"a": "x'' and email is NULL; --\\n", "b": "x'' and email is NULL; --\\n"}', 1, '{"a": "x'' and email is NULL; --\\n"}', '2015-06-07 05:46:02', 0, '88886a01468a8887329ad62b22f9fd8b9f9e17b9', 7, '127.0.0.1'),
(83, '/hello', 1, '{"a": "anything'' or ''x''=''x\\n", "b": "anything'' or ''x''=''x\\n"}', 1, '{"a": "anything'' or ''x''=''x\\n"}', '2015-06-07 05:46:02', 0, '6d70e36d257829d9cc09d0da791b1918e4902371', 7, '127.0.0.1'),
(84, '/hello?a=anything%27+or+%27x%27%3D%27x%0A&b=anything%27+or+%27x%27%3D%27x%0A', 0, '{"a": "anything'' or ''x''=''x\\n", "b": "anything'' or ''x''=''x\\n"}', 1, '{"a": "anything'' or ''x''=''x\\n"}', '2015-06-07 05:46:02', 0, '13ea5c1411e839798f4840fdafdb7e667af1126a', 7, '127.0.0.1'),
(85, '/hello', 1, '{"a": "x'' and 1=(select count(*) from tabname); --\\n", "b": "x'' and 1=(select count(*) from tabname); --\\n"}', 1, '{"a": "x'' and 1=(select count(*) from tabname); --\\n"}', '2015-06-07 05:46:03', 0, 'c7f94e1acd76967e8a03f1b3b97fc1a8cdac8345', 7, '127.0.0.1'),
(86, '/hello?a=x%27+and+1%3D%28select+count%28%2A%29+from+tabname%29%3B+--%0A&b=x%27+and+1%3D%28select+count%28%2A%29+from+tabname%29%3B+--%0A', 0, '{"a": "x'' and 1=(select count(*) from tabname); --\\n", "b": "x'' and 1=(select count(*) from tabname); --\\n"}', 1, '{"a": "x'' and 1=(select count(*) from tabname); --\\n"}', '2015-06-07 05:46:03', 0, '64130e1ee47afb5874b42a61a52b361de0f4d564', 7, '127.0.0.1'),
(87, '/hello', 1, '{"a": "x'' and members.email is NULL; --\\n", "b": "x'' and members.email is NULL; --\\n"}', 1, '{"a": "x'' and members.email is NULL; --\\n"}', '2015-06-07 05:46:03', 0, 'b89d02a412e8dc48cd3f9e6420836518689172af', 7, '127.0.0.1'),
(88, '/hello?a=x%27+and+members.email+is+NULL%3B+--%0A&b=x%27+and+members.email+is+NULL%3B+--%0A', 0, '{"a": "x'' and members.email is NULL; --\\n", "b": "x'' and members.email is NULL; --\\n"}', 1, '{"a": "x'' and members.email is NULL; --\\n"}', '2015-06-07 05:46:03', 0, '4add893ad6f26e84f8d5e3c3033eafdc49368ae7', 7, '127.0.0.1'),
(89, '/hello', 1, '{"a": "x'' or full_name like ''%bob%\\n", "b": "x'' or full_name like ''%bob%\\n"}', 1, '{"a": "x'' or full_name like ''%bob%\\n"}', '2015-06-07 05:46:03', 0, '60d27c83056432780707c59172a88605733aed58', 7, '127.0.0.1'),
(90, '/hello?a=x%27+or+full_name+like+%27%25bob%25%0A&b=x%27+or+full_name+like+%27%25bob%25%0A', 0, '{"a": "x'' or full_name like ''%bob%\\n", "b": "x'' or full_name like ''%bob%\\n"}', 1, '{"a": "x'' or full_name like ''%bob%\\n"}', '2015-06-07 05:46:03', 0, '6ffa557d7c81344105025cd491489e62a09a0996', 7, '127.0.0.1'),
(91, '/hello', 1, '{"a": "23 or 1=1; --\\n", "b": "23 or 1=1; --\\n"}', 1, '{"a": "23 or 1=1; --\\n"}', '2015-06-07 05:46:03', 0, 'e792262b23f45d59b1074dd1b622697586fde58a', 7, '127.0.0.1'),
(92, '/hello?a=23+or+1%3D1%3B+--%0A&b=23+or+1%3D1%3B+--%0A', 0, '{"a": "23 or 1=1; --\\n", "b": "23 or 1=1; --\\n"}', 1, '{"a": "23 or 1=1; --\\n"}', '2015-06-07 05:46:03', 0, '3b927d9845cfa1833ac32e1e1bec2b0e5e627ad2', 7, '127.0.0.1'),
(93, '/hello', 1, '{"a": "\\"; SELECT SLEEP(5);--  AND \\"qhQF\\" LIKE \\"qhQF\\n", "b": "\\"; SELECT SLEEP(5);--  AND \\"qhQF\\" LIKE \\"qhQF\\n"}', 1, '{"a": "\\"; SELECT SLEEP(5);--  AND \\"qhQF\\" LIKE \\"qhQF\\n"}', '2015-06-07 05:46:03', 0, '154bc89057b7606fc518ef2d7b12cfb65977877e', 7, '127.0.0.1'),
(94, '/hello?a=%22%3B+SELECT+SLEEP%285%29%3B--++AND+%22qhQF%22+LIKE+%22qhQF%0A&b=%22%3B+SELECT+SLEEP%285%29%3B--++AND+%22qhQF%22+LIKE+%22qhQF%0A', 0, '{"a": "\\"; SELECT SLEEP(5);--  AND \\"qhQF\\" LIKE \\"qhQF\\n", "b": "\\"; SELECT SLEEP(5);--  AND \\"qhQF\\" LIKE \\"qhQF\\n"}', 1, '{"a": "\\"; SELECT SLEEP(5);--  AND \\"qhQF\\" LIKE \\"qhQF\\n"}', '2015-06-07 05:46:03', 0, '90606d06841d3b382d0febdbb650e4f46dd05846', 7, '127.0.0.1'),
(95, '/hello', 1, '{"a": "); SELECT PG_SLEEP(5);--\\n", "b": "); SELECT PG_SLEEP(5);--\\n"}', 1, '{"a": "); SELECT PG_SLEEP(5);--\\n"}', '2015-06-07 05:46:03', 0, '1985cc2e72745ae75339448717d8b0449477fd78', 7, '127.0.0.1'),
(96, '/hello?a=%29%3B+SELECT+PG_SLEEP%285%29%3B--%0A&b=%29%3B+SELECT+PG_SLEEP%285%29%3B--%0A', 0, '{"a": "); SELECT PG_SLEEP(5);--\\n", "b": "); SELECT PG_SLEEP(5);--\\n"}', 1, '{"a": "); SELECT PG_SLEEP(5);--\\n"}', '2015-06-07 05:46:03', 0, 'f946a37246dd6eb111e7a2e9b442a3df8af5199c', 7, '127.0.0.1'),
(97, '/hello', 1, '{"a": "''); SELECT PG_SLEEP(5);--\\n", "b": "''); SELECT PG_SLEEP(5);--\\n"}', 1, '{"a": "''); SELECT PG_SLEEP(5);--\\n"}', '2015-06-07 05:46:03', 0, '9d82387bfa585dd482198162842dd3766f76dd8d', 7, '127.0.0.1'),
(98, '/hello?a=%27%29%3B+SELECT+PG_SLEEP%285%29%3B--%0A&b=%27%29%3B+SELECT+PG_SLEEP%285%29%3B--%0A', 0, '{"a": "''); SELECT PG_SLEEP(5);--\\n", "b": "''); SELECT PG_SLEEP(5);--\\n"}', 1, '{"a": "''); SELECT PG_SLEEP(5);--\\n"}', '2015-06-07 05:46:03', 0, 'e33208408acbe1e2c046fd80dd3e30758af3e5fd', 6, '127.0.0.1'),
(99, '/hello', 1, '{"a": "''; SELECT PG_SLEEP(5);--\\n", "b": "''; SELECT PG_SLEEP(5);--\\n"}', 1, '{"a": "''; SELECT PG_SLEEP(5);--\\n"}', '2015-06-07 05:46:03', 0, '09874a68e689c7d594bd0769265233260025e1b9', 6, '127.0.0.1'),
(100, '/hello?a=%27%3B+SELECT+PG_SLEEP%285%29%3B--%0A&b=%27%3B+SELECT+PG_SLEEP%285%29%3B--%0A', 0, '{"a": "''; SELECT PG_SLEEP(5);--\\n", "b": "''; SELECT PG_SLEEP(5);--\\n"}', 1, '{"a": "''; SELECT PG_SLEEP(5);--\\n"}', '2015-06-07 05:46:03', 0, '210c5d233b557933580b6b373f97157ee5eaccfe', 6, '127.0.0.1'),
(101, '/hello', 1, '{"a": "\\"; SELECT PG_SLEEP(5);--\\n", "b": "\\"; SELECT PG_SLEEP(5);--\\n"}', 1, '{"a": "\\"; SELECT PG_SLEEP(5);--\\n"}', '2015-06-07 05:46:03', 0, 'cba153c0a6f26a8d342f10186d2eb5b1ea86e578', 5, '127.0.0.1'),
(102, '/hello?a=%22%3B+SELECT+PG_SLEEP%285%29%3B--%0A&b=%22%3B+SELECT+PG_SLEEP%285%29%3B--%0A', 0, '{"a": "\\"; SELECT PG_SLEEP(5);--\\n", "b": "\\"; SELECT PG_SLEEP(5);--\\n"}', 1, '{"a": "\\"; SELECT PG_SLEEP(5);--\\n"}', '2015-06-07 05:46:03', 0, '7f7fae4587b3ee4237727f2ae980eba40f58477d', 5, '127.0.0.1'),
(103, '/hello', 1, '{"a": "'' or ''x''=''x\\n", "b": "'' or ''x''=''x\\n"}', 1, '{"a": "'' or ''x''=''x\\n"}', '2015-06-07 05:46:03', 0, '66a2c86957baf68ff6d01664b43e4307cbed896d', 5, '127.0.0.1'),
(104, '/hello?a=%27+or+%27x%27%3D%27x%0A&b=%27+or+%27x%27%3D%27x%0A', 0, '{"a": "'' or ''x''=''x\\n", "b": "'' or ''x''=''x\\n"}', 1, '{"a": "'' or ''x''=''x\\n"}', '2015-06-07 05:46:03', 0, '0edcfc62ebaac757d54faed4bed6a3b1a60525f0', 5, '127.0.0.1'),
(105, '/hello', 1, '{"a": "\\" or \\"x\\"=\\"x\\n", "b": "\\" or \\"x\\"=\\"x\\n"}', 1, '{"a": "\\" or \\"x\\"=\\"x\\n"}', '2015-06-07 05:46:03', 0, '84797c1a71ebdd838766f71f5234bdd488af884a', 5, '127.0.0.1'),
(106, '/hello?a=%22+or+%22x%22%3D%22x%0A&b=%22+or+%22x%22%3D%22x%0A', 0, '{"a": "\\" or \\"x\\"=\\"x\\n", "b": "\\" or \\"x\\"=\\"x\\n"}', 1, '{"a": "\\" or \\"x\\"=\\"x\\n"}', '2015-06-07 05:46:03', 0, '4651944e0794c880a56dbb049d8c8af566042fa4', 5, '127.0.0.1'),
(107, '/hello', 1, '{"a": "'') or x=x--\\n", "b": "'') or x=x--\\n"}', 1, '{"a": "'') or x=x--\\n"}', '2015-06-07 05:46:03', 0, '43fee0ab13d0b66f425eca8b01903581451cd6b9', 4, '127.0.0.1'),
(108, '/hello?a=%27%29+or+x%3Dx--%0A&b=%27%29+or+x%3Dx--%0A', 0, '{"a": "'') or x=x--\\n", "b": "'') or x=x--\\n"}', 1, '{"a": "'') or x=x--\\n"}', '2015-06-07 05:46:03', 0, 'bf8227465a68555297ebe12d9ac34c7ce567c4b5', 4, '127.0.0.1'),
(109, '/hello', 1, '{"a": "'') or (''x''=''x\\n", "b": "'') or (''x''=''x\\n"}', 1, '{"a": "'') or (''x''=''x\\n"}', '2015-06-07 05:46:03', 0, 'b205f93a326b82896702d11a3b6e0a7ae92d5599', 4, '127.0.0.1'),
(110, '/hello?a=%27%29+or+%28%27x%27%3D%27x%0A&b=%27%29+or+%28%27x%27%3D%27x%0A', 0, '{"a": "'') or (''x''=''x\\n", "b": "'') or (''x''=''x\\n"}', 1, '{"a": "'') or (''x''=''x\\n"}', '2015-06-07 05:46:03', 0, '73dc7fd907e6c8258a0fed792e0f8ca647ca725b', 4, '127.0.0.1'),
(111, '/hello', 1, '{"a": "'') or 1=1--\\n", "b": "'') or 1=1--\\n"}', 1, '{"a": "'') or 1=1--\\n"}', '2015-06-07 05:46:03', 0, '7a8150cb654cb31cbea5df7f559bc5a0e8d70ceb', 4, '127.0.0.1'),
(112, '/hello?a=%27%29+or+1%3D1--%0A&b=%27%29+or+1%3D1--%0A', 0, '{"a": "'') or 1=1--\\n", "b": "'') or 1=1--\\n"}', 1, '{"a": "'') or 1=1--\\n"}', '2015-06-07 05:46:04', 0, '861e26400921b3ec4e4be3d4025f719062aa33e4', 4, '127.0.0.1'),
(113, '/hello', 1, '{"a": "0 or 1=1\\n", "b": "0 or 1=1\\n"}', 1, '{"a": "0 or 1=1\\n"}', '2015-06-07 05:46:04', 0, 'bae002e4fc67729a8cb617d101df796d87a0211f', 4, '127.0.0.1'),
(114, '/hello?a=0+or+1%3D1%0A&b=0+or+1%3D1%0A', 0, '{"a": "0 or 1=1\\n", "b": "0 or 1=1\\n"}', 1, '{"a": "0 or 1=1\\n"}', '2015-06-07 05:46:04', 0, 'aab8a6fb8d0d8284a35d3e7f770c03fde93a2491', 4, '127.0.0.1'),
(115, '/hello', 1, '{"a": "'' or 0=0--", "b": "'' or 0=0--"}', 1, '{"a": "'' or 0=0--"}', '2015-06-07 05:46:04', 0, '39bc5e12f2aa41f7d0fa05b9820447ac0b9f63c8', 4, '127.0.0.1'),
(116, '/hello?a=%27+or+0%3D0--&b=%27+or+0%3D0--', 0, '{"a": "'' or 0=0--", "b": "'' or 0=0--"}', 1, '{"a": "'' or 0=0--"}', '2015-06-07 05:46:04', 0, 'd360e620206fd14eda6cc2e6b107ae06e6cdb4a0', 4, '127.0.0.1'),
(117, '/hello?a=http%3A%2F%2F192.168.0.1%0A&b=http%3A%2F%2F192.168.0.1%0A', 0, '{"a": "http://192.168.0.1\\n", "b": "http://192.168.0.1\\n"}', 0, '{}', '2015-06-07 05:46:04', 0, '47a17649872955a9b5422ecc1a87ecbd4fb1a36a', 4, '127.0.0.1'),
(118, '/hello', 1, '{"a": "http://192.168.0.1\\n", "b": "http://192.168.0.1\\n"}', 0, '{}', '2015-06-07 05:46:04', 0, '198d3fd47249137b30df968b0cea98ad2c4c1fc7', 4, '127.0.0.1'),
(119, '/hello', 1, '{"a": "\\u6211\\u52d2\\u4e2a\\u53bb\\u5440\\uff0c \\u54c8\\u54c8\\n", "b": "\\u6211\\u52d2\\u4e2a\\u53bb\\u5440\\uff0c \\u54c8\\u54c8\\n"}', 0, '{}', '2015-06-07 05:55:28', 0, '353605929cc9c4cb9101ac6b27fe0aad60fb023e', 2, '127.0.0.1'),
(120, '/hello?a=%E6%88%91%E5%8B%92%E4%B8%AA%E5%8E%BB%E5%91%80%EF%BC%8C+%E5%93%88%E5%93%88%0A&b=%E6%88%91%E5%8B%92%E4%B8%AA%E5%8E%BB%E5%91%80%EF%BC%8C+%E5%93%88%E5%93%88%0A', 0, '{"a": "\\u6211\\u52d2\\u4e2a\\u53bb\\u5440\\uff0c \\u54c8\\u54c8\\n", "b": "\\u6211\\u52d2\\u4e2a\\u53bb\\u5440\\uff0c \\u54c8\\u54c8\\n"}', 0, '{}', '2015-06-07 05:55:28', 0, '490da60fdba68e7ce0d9473e00427dfc7c5aa0ba', 2, '127.0.0.1'),
(121, '/hello?a=8080%3A9090%0A&b=8080%3A9090%0A', 0, '{"a": "8080:9090\\n", "b": "8080:9090\\n"}', 0, '{}', '2015-06-07 05:55:28', 0, 'e68c39b27e698dfaa275dfd3415330ea78afff87', 2, '127.0.0.1'),
(122, '/hello', 1, '{"a": "8080:9090\\n", "b": "8080:9090\\n"}', 0, '{}', '2015-06-07 05:55:28', 0, 'f25a8e2a954ff97550ec5c5e134f3a49cdeebe0e', 2, '127.0.0.1'),
(123, '/hello?a=7897932s1df%0A&b=7897932s1df%0A', 0, '{"a": "7897932s1df\\n", "b": "7897932s1df\\n"}', 0, '{}', '2015-06-07 05:55:28', 0, '11751cd52a16103cc7255579b6983eea64a71127', 2, '127.0.0.1'),
(124, '/hello', 1, '{"a": "7897932s1df\\n", "b": "7897932s1df\\n"}', 0, '{}', '2015-06-07 05:55:28', 0, '54c02cb7558f84c34da58510d2c1fa079226abf8', 2, '127.0.0.1'),
(125, '/hello?a=ahh289834h+ajldfhy94n+asfy923+dfaoewshfi%0A&b=ahh289834h+ajldfhy94n+asfy923+dfaoewshfi%0A', 0, '{"a": "ahh289834h ajldfhy94n asfy923 dfaoewshfi\\n", "b": "ahh289834h ajldfhy94n asfy923 dfaoewshfi\\n"}', 0, '{}', '2015-06-07 05:55:28', 0, '5ee04dd4892a5eb07f9944d5abcc7fdc682dee8d', 2, '127.0.0.1'),
(126, '/hello', 1, '{"a": "ahh289834h ajldfhy94n asfy923 dfaoewshfi\\n", "b": "ahh289834h ajldfhy94n asfy923 dfaoewshfi\\n"}', 0, '{}', '2015-06-07 05:55:28', 0, 'a32323e56bb11158518b12363e2eb5c216402bca', 2, '127.0.0.1'),
(127, '/hello?a=F11+F12+Tab%0A&b=F11+F12+Tab%0A', 0, '{"a": "F11 F12 Tab\\n", "b": "F11 F12 Tab\\n"}', 0, '{}', '2015-06-07 05:55:28', 0, '16ab603849dbf144cbd4e11352b02cbb84282d19', 2, '127.0.0.1'),
(128, '/hello', 1, '{"a": "where are we going\\n", "b": "where are we going\\n"}', 0, '{}', '2015-06-07 05:55:28', 0, '631ee1b512d9f7e34b34200827bb64673f4652ca', 2, '127.0.0.1'),
(129, '/hello', 1, '{"a": "F11 F12 Tab\\n", "b": "F11 F12 Tab\\n"}', 0, '{}', '2015-06-07 05:55:28', 0, '21a1904d32066002ee72b71575e74a6b51f743fc', 2, '127.0.0.1'),
(130, '/hello?a=where+are+we+going%0A&b=where+are+we+going%0A', 0, '{"a": "where are we going\\n", "b": "where are we going\\n"}', 0, '{}', '2015-06-07 05:55:28', 0, 'eeb2918019c1218e3e800251f013946a40c0336c', 2, '127.0.0.1'),
(131, '/hello?a=what+are+you+doing%0A&b=what+are+you+doing%0A', 0, '{"a": "what are you doing\\n", "b": "what are you doing\\n"}', 0, '{}', '2015-06-07 05:55:28', 0, 'f565ab5355af5ecbb3115c1816d5872747d065ea', 2, '127.0.0.1'),
(132, '/hello', 1, '{"a": "what are you doing\\n", "b": "what are you doing\\n"}', 0, '{}', '2015-06-07 05:55:28', 0, '44f44cdaebe19b39389322f7493bf83085c72f48', 2, '127.0.0.1'),
(133, '/hello?a=which+is+your+select%0A&b=which+is+your+select%0A', 0, '{"a": "which is your select\\n", "b": "which is your select\\n"}', 0, '{}', '2015-06-07 05:55:28', 0, '354a120d1d5142fa19c762d6fcdde0af67cf28e9', 2, '127.0.0.1'),
(134, '/hello', 1, '{"a": "which is your select\\n", "b": "which is your select\\n"}', 0, '{}', '2015-06-07 05:55:28', 0, '4183a73b9d55377fe7d2810e8fcfef13afba977a', 2, '127.0.0.1'),
(135, '/hello?a=insert+it+and+delete+it%0A&b=insert+it+and+delete+it%0A', 0, '{"a": "insert it and delete it\\n", "b": "insert it and delete it\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, '6f8b8163c0e2c8dd8be50d5152d9c01652ae30cd', 2, '127.0.0.1'),
(136, '/hello', 1, '{"a": "insert it and delete it\\n", "b": "insert it and delete it\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, 'd27cd2fa304f4991e52c6559edc254721b5d6210', 2, '127.0.0.1'),
(137, '/hello?a=fuck+the+world%0A&b=fuck+the+world%0A', 0, '{"a": "fuck the world\\n", "b": "fuck the world\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, '318de9e1b70702736f00cff006a9bd86af0ba300', 2, '127.0.0.1'),
(138, '/hello', 1, '{"a": "fuck the world\\n", "b": "fuck the world\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, 'd9c201ca4d6573630c601863c324e9f31097a48e', 2, '127.0.0.1'),
(139, '/hello?a=I...%0A&b=I...%0A', 0, '{"a": "I...\\n", "b": "I...\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, '749172d8ddbafa2a365428f9c10e35c69209a02d', 2, '127.0.0.1'),
(140, '/hello', 1, '{"a": "I...\\n", "b": "I...\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, 'ad10a0244f35a2fbebedca30cff96e7a2f30ab13', 2, '127.0.0.1'),
(141, '/hello?a=Because+sqljs+is+still+under+heavy+development%2C%0A&b=Because+sqljs+is+still+under+heavy+development%2C%0A', 0, '{"a": "Because sqljs is still under heavy development,\\n", "b": "Because sqljs is still under heavy development,\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, '3630df8cc5d47ef5a609222d9495794cf007de79', 2, '127.0.0.1'),
(142, '/hello', 1, '{"a": "Because sqljs is still under heavy development,\\n", "b": "Because sqljs is still under heavy development,\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, '16eba4a5c8a18799af8589b8bc6bcf42ee498a80', 2, '127.0.0.1'),
(143, '/hello?a=npm+install+git%3A%2F%2Fgithub.com%2Flangpavel%2Fnode-sqljs.git%0A&b=npm+install+git%3A%2F%2Fgithub.com%2Flangpavel%2Fnode-sqljs.git%0A', 0, '{"a": "npm install git://github.com/langpavel/node-sqljs.git\\n", "b": "npm install git://github.com/langpavel/node-sqljs.git\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, 'c7e9bd7512d8e4a95a7ff9e22e826967528a0c70', 2, '127.0.0.1'),
(144, '/hello', 1, '{"a": "npm install git://github.com/langpavel/node-sqljs.git\\n", "b": "npm install git://github.com/langpavel/node-sqljs.git\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, '0e1be76cea82fc3d1f2aab657727ae0c2e585c26', 2, '127.0.0.1'),
(145, '/hello?a=%E4%BD%A0%E8%A7%89%E5%BE%97sql%E8%AF%AD%E8%A8%80%E4%BB%8E%E8%BE%93%E5%85%A5%E6%95%B0%E6%8D%AE%E5%BA%93%E5%88%B0%E6%94%BE%E5%9B%9E%E5%86%85%E5%AE%B9%E9%83%BD%E7%BB%8F%E8%BF%87%E4%BA%86%0A&b=%E4%BD%A0%E8%A7%89%E5%BE%97sql%E8%AF%AD%E8%A8%80%E4%BB%8E%E8%BE%93%E5%85%A5%E6%95%B0%E6%8D%AE%E5%BA%93%E5%88%B0%E6%94%BE%E5%9B%9E%E5%86%85%E5%AE%B9%E9%83%BD%E7%BB%8F%E8%BF%87%E4%BA%86%0A', 0, '{"a": "\\u4f60\\u89c9\\u5f97sql\\u8bed\\u8a00\\u4ece\\u8f93\\u5165\\u6570\\u636e\\u5e93\\u5230\\u653e\\u56de\\u5185\\u5bb9\\u90fd\\u7ecf\\u8fc7\\u4e86\\n", "b": "\\u4f60\\u89c9\\u5f97sql\\u8bed\\u8a00\\u4ece\\u8f93\\u5165\\u6570\\u636e\\u5e93\\u5230\\u653e\\u56de\\u5185\\u5bb9\\u90fd\\u7ecf\\u8fc7\\u4e86\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, 'adc01a5dd6496ba6b3333f3894ac054f225eb4a4', 2, '127.0.0.1'),
(146, '/hello', 1, '{"a": "\\u4f60\\u89c9\\u5f97sql\\u8bed\\u8a00\\u4ece\\u8f93\\u5165\\u6570\\u636e\\u5e93\\u5230\\u653e\\u56de\\u5185\\u5bb9\\u90fd\\u7ecf\\u8fc7\\u4e86\\n", "b": "\\u4f60\\u89c9\\u5f97sql\\u8bed\\u8a00\\u4ece\\u8f93\\u5165\\u6570\\u636e\\u5e93\\u5230\\u653e\\u56de\\u5185\\u5bb9\\u90fd\\u7ecf\\u8fc7\\u4e86\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, 'afa0d0bb5aed37db7d10591f02588c53ce9c58ba', 2, '127.0.0.1'),
(147, '/hello?a=%E6%98%AF%E4%B8%8D%E6%98%AF%E5%93%AA%E9%87%8C%E4%B8%8D%E5%AF%B9%EF%BC%8C%E5%B0%B1%E6%98%AF%E8%AF%B4%0A&b=%E6%98%AF%E4%B8%8D%E6%98%AF%E5%93%AA%E9%87%8C%E4%B8%8D%E5%AF%B9%EF%BC%8C%E5%B0%B1%E6%98%AF%E8%AF%B4%0A', 0, '{"a": "\\u662f\\u4e0d\\u662f\\u54ea\\u91cc\\u4e0d\\u5bf9\\uff0c\\u5c31\\u662f\\u8bf4\\n", "b": "\\u662f\\u4e0d\\u662f\\u54ea\\u91cc\\u4e0d\\u5bf9\\uff0c\\u5c31\\u662f\\u8bf4\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, '1a31873976149aaf3d53ced4d94809ef882330df', 2, '127.0.0.1'),
(148, '/hello', 1, '{"a": "\\u662f\\u4e0d\\u662f\\u54ea\\u91cc\\u4e0d\\u5bf9\\uff0c\\u5c31\\u662f\\u8bf4\\n", "b": "\\u662f\\u4e0d\\u662f\\u54ea\\u91cc\\u4e0d\\u5bf9\\uff0c\\u5c31\\u662f\\u8bf4\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, '8c50feade08ffabe3522faee6271f6b4149a4213', 2, '127.0.0.1'),
(149, '/hello?a=http%3A%2F%2Fbluereader.org%2Farticle%2F4883180%0A&b=http%3A%2F%2Fbluereader.org%2Farticle%2F4883180%0A', 0, '{"a": "http://bluereader.org/article/4883180\\n", "b": "http://bluereader.org/article/4883180\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, '667cfe764ab302842ed4c43b9b8903e957a2a91a', 2, '127.0.0.1'),
(150, '/hello', 1, '{"a": "http://bluereader.org/article/4883180\\n", "b": "http://bluereader.org/article/4883180\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, 'df22bd236880fcedeff773f6a89145374a3d776e', 2, '127.0.0.1'),
(151, '/hello?a=nquery%2B2%0A&b=nquery%2B2%0A', 0, '{"a": "nquery+2\\n", "b": "nquery+2\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, 'b2377c5c992413787cb08e38e5a36b243f3977f6', 2, '127.0.0.1'),
(152, '/hello', 1, '{"a": "nquery+2\\n", "b": "nquery+2\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, '5e358aec2ef0581a5983c95ab94f1023db1b4993', 2, '127.0.0.1'),
(153, '/hello?a=Jack+Jobs+babi%0A&b=Jack+Jobs+babi%0A', 0, '{"a": "Jack Jobs babi\\n", "b": "Jack Jobs babi\\n"}', 0, '{}', '2015-06-07 05:55:29', 0, '46353c06c644ff1048eb8d108a91d6df86278c2f', 2, '127.0.0.1'),
(154, '/hello', 1, '{"a": "Jack Jobs babi\\n", "b": "Jack Jobs babi\\n"}', 0, '{}', '2015-06-07 05:55:30', 0, '52d8212b510b115f772fedd1495e845bccea187f', 2, '127.0.0.1'),
(155, '/hello?a=thank+you&b=thank+you', 0, '{"a": "thank you", "b": "thank you"}', 0, '{}', '2015-06-07 05:55:30', 0, '6afe1adcf43b3ce62dfabc73a5d1bfafadc2c1ff', 2, '127.0.0.1'),
(156, '/hello', 1, '{"a": "thank you", "b": "thank you"}', 0, '{}', '2015-06-07 05:55:30', 0, '8ff28aa11c8b7bb2a543fd8bb94f5107a58e84bd', 2, '127.0.0.1');

-- --------------------------------------------------------

--
-- 表的结构 `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `username` char(50) NOT NULL,
  `password` char(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `xss_log`
--

CREATE TABLE IF NOT EXISTS `xss_log` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `error_code` mediumint(4) NOT NULL,
  `url` text NOT NULL,
  `code_xss_area` text NOT NULL,
  `payload` text NOT NULL,
  `cookie` text,
  `ip` varchar(20) NOT NULL,
  `statu` tinyint(2) NOT NULL,
  `token` varchar(50) DEFAULT NULL,
  `count` int(11) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=234 ;

--
-- 转存表中的数据 `xss_log`
--

INSERT INTO `xss_log` (`id`, `time`, `error_code`, `url`, `code_xss_area`, `payload`, `cookie`, `ip`, `statu`, `token`, `count`) VALUES
(232, '2015-06-06 12:19:24', 402, '127', 'null', 'javascript', 'null', '127.0.0.1', 0, '3b07d4b0d5a8062653915f4c3a6d62ae176c6301', 3),
(233, '2015-06-06 12:24:56', 402, '127', 'null', 'javascript', 'cookie', '127.0.0.1', 0, '0f2f20d240729977f0c22f2deb7fbb906f1baef4', 61);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
