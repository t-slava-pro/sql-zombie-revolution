/* ============================================================
   02. Качество данных: пустые end_session
   ------------------------------------------------------------
   Вопрос: сколько сессий без времени окончания и правда ли, что
   большая часть таких проблемных записей приходит с iOS?

   Вывод: 3262 проблемных сессии (12% всех строк).
   97.61% всех проблемных записей — iOS (доля проблемных внутри iOS
   = 19%, внутри Android = 0.75%). Похоже на баг трекинга на iOS.
   ============================================================ */

-- Сводка одним запросом: объём, доля, разрез по устройствам
select
    -- всего проблемных сессий
    sum(case when end_session is null then 1.0 else 0.0 end)                          as null_sessions,
    -- их доля среди всех строк
    sum(case when end_session is null then 1.0 else 0.0 end) / count(*)               as share_null_total,
    -- доля проблемных ВНУТРИ каждого типа устройства
    sum(case when end_session is null and dev_type = 'ios' then 1.0 else 0.0 end)
        / nullif(sum(case when dev_type = 'ios' then 1.0 else 0.0 end), 0)            as share_null_within_ios,
    sum(case when end_session is null and dev_type = 'android' then 1.0 else 0.0 end)
        / nullif(sum(case when dev_type = 'android' then 1.0 else 0.0 end), 0)        as share_null_within_android,
    -- какой % ВСЕХ проблемных приходится на каждое устройство
    sum(case when end_session is null and dev_type = 'ios' then 1.0 else 0.0 end)
        / nullif(sum(case when end_session is null then 1.0 else 0.0 end), 0) * 100   as pct_of_nulls_ios,
    sum(case when end_session is null and dev_type = 'android' then 1.0 else 0.0 end)
        / nullif(sum(case when end_session is null then 1.0 else 0.0 end), 0) * 100   as pct_of_nulls_android
from skygame.game_sessions t1
    join skygame.users t2 on t1.id_user = t2.id_user;
