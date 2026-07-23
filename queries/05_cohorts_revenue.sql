/* ============================================================
   05. Цена на кристаллы и когортная выручка
   ------------------------------------------------------------
   А) Эффект повышения цены кристаллов с 01.01.2023.
   Б) Средняя выручка на одного клиента в месяц по когортам.

   Выводы:
   - После подорожания количество проданных кристаллов упало,
     а суммарная выручка выросла → спрос неэластичен.
   - Средняя месячная выручка на клиента по когортам растёт.
   ============================================================ */

-- А) Средний чек по кристаллам и выручка по месяцам
select date_trunc('month', dtime_pay) as mm
     , avg(m.cnt_buy)                  as avg_crystals_per_buy
     , sum(m.cnt_buy * p.price)        as revenue
from skygame.monetary m
    join skygame.item_list i
        on m.id_item_buy = i.id_item
    join skygame.log_prices p
        on p.id_item = i.id_item
       and dtime_pay::date >= p.valid_from
       and dtime_pay::date <  coalesce(p.valid_to, to_date('3000-01-01', 'YYYY-MM-DD'))
where i.name_item = 'Crystal'
group by mm
order by mm;

-- Б) Средняя выручка на клиента в месяц по когортам (когорта = месяц регистрации)
select cohort.*
     , extract(day from ((select max(dtime_pay) from skygame.monetary) - cohort.mm)) / 30            as months_active
     , cohort.avg_rev
       / (extract(day from ((select max(dtime_pay) from skygame.monetary) - cohort.mm)) / 30)        as avg_rev_per_month
from (
    select date_trunc('month', u.reg_date)                              as mm
         , sum(m.cnt_buy * p.price)                                     as revenue
         , count(distinct u.id_user)                                    as users_cnt
         , sum(m.cnt_buy * p.price) / count(distinct u.id_user)         as avg_rev
    from skygame.monetary m
        join skygame.users u
            on m.id_user = u.id_user
        join skygame.log_prices p
            on p.id_item = m.id_item_buy
           and dtime_pay::date >= p.valid_from
           and dtime_pay::date <  coalesce(p.valid_to, to_date('3000-01-01', 'YYYY-MM-DD'))
    where u.reg_date < (select max(dtime_pay) from skygame.monetary) - interval '1 month'
    group by mm
) cohort
order by cohort.mm;
