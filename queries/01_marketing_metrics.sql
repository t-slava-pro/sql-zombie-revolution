/* ============================================================
   01. Маркетинговые метрики: DAU / WAU / MAU
   ------------------------------------------------------------
   Вопрос: видим ли мы эффект акции (первые 3 недели марта 2023,
   бесплатные кристаллы за частые заходы) на клиентских метриках?
   Дату НЕ ограничиваем — чтобы сравнить март с остальными месяцами.
   Sticky Factor (SF = DAU/WAU и DAU/MAU) считается в Excel поверх
   этих трёх выгрузок.

   Вывод: заходы выросли на ~70-80% (акция сработала на активность),
   но Sticky Factor снизился — новые игроки не стали заходить чаще.
   ============================================================ */

-- DAU (Daily Active Users): уникальные игроки по дням
select date_trunc('day', start_session) as day
     , count(distinct id_user)          as daily_active_user
from skygame.game_sessions
group by date_trunc('day', start_session)
order by day;

-- WAU (Weekly Active Users): уникальные игроки по неделям
select date_trunc('week', start_session) as week
     , count(distinct id_user)           as weekly_active_user
from skygame.game_sessions
group by date_trunc('week', start_session)
order by week;

-- MAU (Monthly Active Users): уникальные игроки по месяцам
select date_trunc('month', start_session) as month
     , count(distinct id_user)            as monthly_active_user
from skygame.game_sessions
group by date_trunc('month', start_session)
order by month;
