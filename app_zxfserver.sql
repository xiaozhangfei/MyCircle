-- phpMyAdmin SQL Dump
-- version 3.3.8.1
-- http://www.phpmyadmin.net
--
-- 主机: w.rdc.sae.sina.com.cn:3307
-- 生成日期: 2016 年 04 月 15 日 11:47
-- 服务器版本: 5.6.23
-- PHP 版本: 5.3.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `app_zxfserver`
--

-- --------------------------------------------------------

--
-- 表的结构 `c_adcontent`
--

CREATE TABLE IF NOT EXISTS `c_adcontent` (
  `aid` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(250) NOT NULL,
  `pic` varchar(250) NOT NULL,
  `cdate` datetime NOT NULL,
  `mark` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`aid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- 转存表中的数据 `c_adcontent`
--

INSERT INTO `c_adcontent` (`aid`, `title`, `pic`, `cdate`, `mark`) VALUES
(2, '第二只广告', '1235.jpg', '2015-12-19 19:31:55', 0),
(1, '第一支广告', '1234.jpg', '2015-12-19 19:31:22', 0);

-- --------------------------------------------------------

--
-- 表的结构 `c_circledetail`
--

CREATE TABLE IF NOT EXISTS `c_circledetail` (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `vid` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `intro` text,
  `see` int(11) DEFAULT '0',
  `pictures` varchar(400) DEFAULT NULL,
  `location` varchar(200) DEFAULT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `isnew` varchar(5) DEFAULT '0',
  `mark` int(11) DEFAULT '0',
  PRIMARY KEY (`cid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- 转存表中的数据 `c_circledetail`
--

INSERT INTO `c_circledetail` (`cid`, `uid`, `vid`, `title`, `intro`, `see`, `pictures`, `location`, `time`, `isnew`, `mark`) VALUES
(1, 1, 3, '炸子鸡', '一条大道至简', 68, '3c50f029ee3b640c0e370e57099e8939.png', '中国，北京市，龙岗路，50号', '2015-12-19 19:39:40', '0', 0),
(2, 1, 9, '易水萧萧人去也', '一天明月白如霜', 51, '9ec3380cf3690d5113ec1911b98d3b47.png', '中国，北京市，龙岗路，50号', '2015-12-19 21:40:16', '0', 0),
(3, 1, 603, '沧海龙战', '沧海龙战血玄皇，披发长歌览大荒。\n易水萧萧人去也，一天明月白如霜。', 20, '02c636608b3b92d9e999ab04565588d8.png', '中国，北京市，龙岗路，50号', '2015-12-20 00:21:51', '0', 0),
(4, 1, 6, '小鸟', '小小鸟????', 16, '6b9794eccdad39722d7e09b46c5d57a0.png', '中国，北京市，龙岗路，50号', '2015-12-20 00:42:28', '0', 0),
(5, 1, 2949633, '龙的传人', '巨龙巨龙你擦亮眼', 6, '2949633eeaf80a84c5f2960a4f32bce4.png', '中国，北京市，龙岗路，50号', '2015-12-20 14:00:13', '0', 0);

-- --------------------------------------------------------

--
-- 表的结构 `c_friends`
--

CREATE TABLE IF NOT EXISTS `c_friends` (
  `fid` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `friendid` int(11) NOT NULL,
  `markname` varchar(200) DEFAULT NULL,
  `cdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`fid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- 转存表中的数据 `c_friends`
--

INSERT INTO `c_friends` (`fid`, `uid`, `friendid`, `markname`, `cdate`) VALUES
(1, 1, 2, '天地玄黄', '2015-12-31 10:28:24'),
(2, 1, 3, '哈哈啦那就', '2015-12-31 10:28:24'),
(3, 3, 1, '哈哈', '2016-01-01 16:59:31'),
(4, 3, 2, '大牛', '2016-01-01 16:59:31');

-- --------------------------------------------------------

--
-- 表的结构 `c_tables`
--

CREATE TABLE IF NOT EXISTS `c_tables` (
  `tid` int(11) NOT NULL AUTO_INCREMENT,
  `tablename` text,
  PRIMARY KEY (`tid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- 转存表中的数据 `c_tables`
--

INSERT INTO `c_tables` (`tid`, `tablename`) VALUES
(1, 'users'),
(2, '..name=photo..hash=FjW6x79Nyci9bUXFC2R8OSqk0NGm..location=..price='),
(3, '..name=90ae03df1ba46ba5a35fb0264cca676f..hash=FpF4LHOY36MMIPm2w8Y0pvbwIKnY..uid=..path=');

-- --------------------------------------------------------

--
-- 表的结构 `c_users`
--

CREATE TABLE IF NOT EXISTS `c_users` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `mobile` varchar(20) NOT NULL,
  `token` varchar(50) NOT NULL,
  `rctoken` varchar(100) DEFAULT NULL,
  `version` varchar(100) NOT NULL,
  `device` varchar(100) NOT NULL,
  `cdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `udate` timestamp NULL DEFAULT NULL,
  `sex` varchar(20) DEFAULT '0',
  `birth` varchar(20) DEFAULT NULL,
  `intrests` varchar(300) DEFAULT NULL,
  `intro` text,
  `nickname` varchar(200) NOT NULL,
  `password` varchar(50) NOT NULL,
  `portrait` varchar(300) DEFAULT NULL,
  `background` varchar(250) CHARACTER SET armscii8 DEFAULT NULL,
  `location` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `telephone` (`mobile`),
  UNIQUE KEY `nickname` (`nickname`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=14 ;

--
-- 转存表中的数据 `c_users`
--

INSERT INTO `c_users` (`uid`, `mobile`, `token`, `rctoken`, `version`, `device`, `cdate`, `udate`, `sex`, `birth`, `intrests`, `intro`, `nickname`, `password`, `portrait`, `background`, `location`) VALUES
(1, '15201283327', '51382f711768ae4f7f760d4566ac85a0', 'gTvU1tbvw2knhh+sgQUlNl4S3MtOrlZa1/4nB6oB+yoA4ZoK4fQDx6Pn+opeTgKHXLlxj3QUd5vjOSgcBrxjvg==', '1.0', '8B8CE676-C751-49AF-9E9D-34E3CAA6DCBB', '2015-12-19 12:33:01', '2016-04-01 01:17:53', '3', '2015-12-21', '读书', '哈哈，哈哈哈', '爆炸糖', 'e10adc3949ba59abbe56e057f20f883e', 'e940d1ad2ac05c8965da7025d0d806c6', '9e4e1f9a9f354d2166403cef1b1cbbf2', '北京，海淀'),
(2, '15201283328', '123456', 'Z3zyebaalBcg80WXnPwDPF4S3MtOrlZa1/4nB6oB+yoA4ZoK4fQDx/S5ZrF4ZpFp1bQlb2Q/SQ/jOSgcBrxjvg==', '1.0', 'iOS', '2015-12-26 19:27:40', '2016-01-01 09:56:35', '0', '1990-01-12', '11', '23443', '123', '123456', 'e940d1ad2ac05c8965da7025d0d806c6', NULL, NULL),
(3, '123457', '123456', '8dLj76YpYzqvQ79hD1+gY14S3MtOrlZa1/4nB6oB+yoA4ZoK4fQDx30a9tM3GFTxbe1nNIXNhbXjOSgcBrxjvg==', '1.0', 'iOS', '2015-12-27 12:45:44', '2016-01-01 06:14:40', NULL, NULL, NULL, '我是一只小小小鸟，飞呀飞呀飞不高', '小金刚', '123457', '1235.jpg', '301fd74661fd54bab1749bb8e92632d3', NULL),
(12, '15201283388', '45abfea705a432c40f7e43b264ab6648', '/g1sC7EK+FRZAdGJVab3MSHLFyvjLV/UYv1JzPWd2UE3VFyTsgOM+OuU1naaPMeIFmNL4KnM+SWGV8YLeUbKEw==', '2.0', 'iOS', '2016-03-17 17:55:38', '2016-03-17 05:55:38', NULL, NULL, NULL, NULL, '小小智慧树', 'e10adc3949ba59abbe56e057f20f883e', NULL, NULL, NULL),
(10, '15201283334', '4154e69c58fe0f2c0cf87a9886769c10', 'qBCG8UNGx7Y0kRP1KBFFwCHLFyvjLV/UYv1JzPWd2UHz6FVrD4Ioo2kkq+CjZ8hGam0iqn+nWDOGV8YLeUbKEw==', '1.0', 'iOS', '2016-01-05 10:15:51', '2016-01-05 10:15:51', NULL, NULL, NULL, NULL, '小牛的哥哥', 'e10adc3949ba59abbe56e057f20f883e', NULL, NULL, NULL),
(11, '15201283325', '16187f7b70a9397808998311a15b9d10', 'BmKBH02JKn/xcXwCCqOXel4S3MtOrlZa1/4nB6oB+yoA4ZoK4fQDx0w0aXBhNoZ3vFaYMzSvFWLjOSgcBrxjvg==', '1.0', 'iOS', '2016-01-05 10:17:33', '2016-01-05 10:17:33', NULL, NULL, NULL, NULL, '小牛', 'e10adc3949ba59abbe56e057f20f883e', NULL, NULL, NULL),
(13, '15201283399', '056d2b110189bf6ea580b6ccd4e71f3a', 'CB6Wh4UE5MRXNuHNOzVHl14S3MtOrlZa1/4nB6oB+yoA4ZoK4fQDxyxtbY6VKe5k5GsN3RhxhnfjOSgcBrxjvg==', '1.0', 'iOS', '2016-03-17 17:59:40', '2016-03-17 05:59:40', NULL, NULL, NULL, NULL, '小小智慧树果实', 'e10adc3949ba59abbe56e057f20f883e', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `c_videos`
--

CREATE TABLE IF NOT EXISTS `c_videos` (
  `vid` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `path` varchar(200) NOT NULL,
  `thumb` varchar(200) DEFAULT NULL,
  `videoname` varchar(200) DEFAULT NULL,
  `cdate` datetime DEFAULT NULL,
  PRIMARY KEY (`vid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2949635 ;

--
-- 转存表中的数据 `c_videos`
--

INSERT INTO `c_videos` (`vid`, `uid`, `name`, `path`, `thumb`, `videoname`, `cdate`) VALUES
(2, 1, '哈哈', 'circle/视频上传.mov', 'circle/视频上传.png', '视频上传', '2015-12-20 00:21:53'),
(3, 1, '1', 'circle/3c50f029ee3b640c0e370e57099e8939.mov', 'circle/3c50f029ee3b640c0e370e57099e8939.png', '3c50f029ee3b640c0e370e57099e8939', '2015-12-19 19:39:43'),
(6, 1, '1987', 'circle/3c2fbd190db0909cb804fa81642d235e.mov', 'circle/3c2fbd190db0909cb804fa81642d235e.png', '视频上传', '2015-12-20 00:42:29'),
(9, 1, '2', 'circle/9ec3380cf3690d5113ec1911b98d3b47.mov', 'circle/9ec3380cf3690d5113ec1911b98d3b47.png', '9ec3380cf3690d5113ec1911b98d3b47', '2015-12-19 21:40:17'),
(603, 1, '3', 'circle/603d1bf0482c0172c39814716f513ac3.mov', 'circle/123123123.png', '603d1bf0482c0172c39814716f513ac3', '2015-12-19 19:37:05'),
(2949633, 1, NULL, 'circle/9c894ef26309e9c4f74776353517a83c.mov', 'circle/9c894ef26309e9c4f74776353517a83c.png', '视频上传', '2015-12-20 14:00:34'),
(2949634, 1, '你好', 'circle/sss.mov', 'ss', '1234', '2015-12-03 00:00:00');
