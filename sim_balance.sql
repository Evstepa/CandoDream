-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Сен 01 2024 г., 23:57
-- Версия сервера: 5.7.39
-- Версия PHP: 8.1.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `sim_balance`
--

-- --------------------------------------------------------

--
-- Структура таблицы `sim`
--

CREATE TABLE `sim` (
  `iccid` bigint(20) UNSIGNED NOT NULL,
  `subscriber_id` int(11) UNSIGNED DEFAULT NULL,
  `balance` decimal(20,6) NOT NULL DEFAULT '0.000000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `sim`
--

INSERT INTO `sim` (`iccid`, `subscriber_id`, `balance`) VALUES
(111111, 1, '124.000000'),
(222222, 1, '366.000000');

-- --------------------------------------------------------

--
-- Структура таблицы `sim_balance_away`
--

CREATE TABLE `sim_balance_away` (
  `id` int(10) UNSIGNED NOT NULL,
  `amount` decimal(20,6) UNSIGNED NOT NULL,
  `iccid` bigint(20) UNSIGNED NOT NULL,
  `comment` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Триггеры `sim_balance_away`
--
DELIMITER $$
CREATE TRIGGER `insert_away` AFTER INSERT ON `sim_balance_away` FOR EACH ROW UPDATE `sim` AS s SET s.balance = s.balance - NEW.amount
WHERE s.iccid = NEW.iccid
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `sim_balance_come`
--

CREATE TABLE `sim_balance_come` (
  `id` int(10) UNSIGNED NOT NULL,
  `amount` decimal(20,6) UNSIGNED NOT NULL,
  `iccid` bigint(20) UNSIGNED NOT NULL,
  `comment` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Триггеры `sim_balance_come`
--
DELIMITER $$
CREATE TRIGGER `insert_come` AFTER INSERT ON `sim_balance_come` FOR EACH ROW UPDATE sim AS s SET s.balance = s.balance + NEW.amount
WHERE s.iccid = NEW.iccid
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `subscribers`
--

CREATE TABLE `subscribers` (
  `id` int(10) UNSIGNED NOT NULL,
  `min_balance` decimal(20,6) NOT NULL DEFAULT '0.000000',
  `group_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `subscribers`
--

INSERT INTO `subscribers` (`id`, `min_balance`, `group_id`) VALUES
(1, '20.000000', 1),
(2, '10.000000', 1);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `sim`
--
ALTER TABLE `sim`
  ADD PRIMARY KEY (`iccid`),
  ADD KEY `subscriber_id` (`subscriber_id`);

--
-- Индексы таблицы `sim_balance_away`
--
ALTER TABLE `sim_balance_away`
  ADD PRIMARY KEY (`id`),
  ADD KEY `iccid` (`iccid`);

--
-- Индексы таблицы `sim_balance_come`
--
ALTER TABLE `sim_balance_come`
  ADD PRIMARY KEY (`id`),
  ADD KEY `iccid` (`iccid`);

--
-- Индексы таблицы `subscribers`
--
ALTER TABLE `subscribers`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `sim_balance_away`
--
ALTER TABLE `sim_balance_away`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `sim_balance_come`
--
ALTER TABLE `sim_balance_come`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `subscribers`
--
ALTER TABLE `subscribers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `sim`
--
ALTER TABLE `sim`
  ADD CONSTRAINT `sim_ibfk_1` FOREIGN KEY (`subscriber_id`) REFERENCES `subscribers` (`id`);

--
-- Ограничения внешнего ключа таблицы `sim_balance_away`
--
ALTER TABLE `sim_balance_away`
  ADD CONSTRAINT `sim_balance_away_ibfk_1` FOREIGN KEY (`iccid`) REFERENCES `sim` (`iccid`);

--
-- Ограничения внешнего ключа таблицы `sim_balance_come`
--
ALTER TABLE `sim_balance_come`
  ADD CONSTRAINT `sim_balance_come_ibfk_1` FOREIGN KEY (`iccid`) REFERENCES `sim` (`iccid`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
