/* ============================================================
   06. Лояльность когорт и вирусность (K-factor)
   ------------------------------------------------------------
   А) Гипотеза: когорта ноя-дек 2022 (дорогая таргетированная
      реклама) лояльнее — играет дольше?
   Б) K-factor — «вирусность» игры.

   Выводы:
   - Гипотеза подтвердилась: когорта 11-12.2022 в среднем 217 мин
     за сессию против 177 мин у остальных (+40 мин).
   - K-factor = 0.92 (каждый игрок приводит ~0.92 нового);
     прогнозируемый размер будущей когорты ~314 игроков.
   ============================================================ */

-- А) Средняя длительность сессии: когорта ноя-дек 2022 vs остальные
select cohort
     , avg(len_minutes) as avg_session_duration_min
from (
    select u.id_user
         , case when reg_date between '2022-11-01' and '2022-12-31'
                then '2022-11-12' else 'other' end                     as cohort
         , extract(epoch from (end_session - start_session)) / 60       as len_minutes
    from skygame.users u
        left join skygame.game_sessions s
            on u.id_user = s.id_user
) t
where len_minutes > 5 or len_minutes is null   -- отсекаем «мусорные» короткие сессии
group by cohort;

-- Б) K-factor и прогноз размера будущей когорты
select sum(ref_reg) / count(distinct us.id_user)                        as k_factor
     , sum(ref_reg) / count(distinct date_trunc('month', reg_date))     as future_cohort_size
from skygame.users us
    left join skygame.referral r
        on us.id_user = r.id_user;
