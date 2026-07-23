/* ============================================================
   03. Самые вовлечённые игроки (топ-25 по времени в игре)
   ------------------------------------------------------------
   Вопрос: кандидаты на бонусы за наибольшее время в игре.
   Условия: учитываем только сессии с заполненным end_session
   и только игроков, зарегистрированных в 2022 году.

   Вывод: лидер (id 2902744) — 6 дней 18 часов 33 минуты суммарно.
   ============================================================ */

select
    t2.id_user,
    -- человекочитаемая суммарная длительность
    extract(day    from justify_interval(sum(end_session - start_session))) || ' дней '  ||
    extract(hour   from justify_interval(sum(end_session - start_session))) || ' часов ' ||
    extract(minute from justify_interval(sum(end_session - start_session))) || ' минут'   as total_time
from skygame.game_sessions t1
    join skygame.users t2 on t1.id_user = t2.id_user
where end_session is not null
  and date_part('year', reg_date) = 2022
group by t2.id_user
order by sum(end_session - start_session) desc
limit 25;
