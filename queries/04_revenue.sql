/* ============================================================
   04. Динамика выручки по типам товаров
   ------------------------------------------------------------
   Вопрос: меняется ли структура выручки со временем?
   Ключевой приём: цену берём АКТУАЛЬНУЮ НА МОМЕНТ ПОКУПКИ —
   join по неравенству к истории цен log_prices, а открытый конец
   интервала (valid_to = null) закрываем COALESCE далёкой датой.

   Вывод: лидеры продаж — Ammo (боеприпасы), Currency (валюта),
   Materials (материалы).
   ============================================================ */

select date_trunc('month', dtime_pay) as mm
     , i.type
     , sum(m.cnt_buy * p.price)        as revenue
from skygame.monetary m
    join skygame.item_list i
        on m.id_item_buy = i.id_item
    join skygame.log_prices p
        on p.id_item = i.id_item
       and dtime_pay::date >= p.valid_from
       and dtime_pay::date <  coalesce(p.valid_to, to_date('3000-01-01', 'YYYY-MM-DD'))
group by mm, i.type
order by i.type, mm;
