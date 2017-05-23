-- Default analytics:

--- Number of sessions per app per day, over time (last month)
create or replace view session_daily as
select s.application_id
    ,a.name as application_name
    ,s.extension_id
    ,s.start::date as date
    ,COUNT(s.id) as num_sessions
from session s
join application a on a.id = s.application_id
--where s.extension_id = '31bc99ffd36ddfcb5d350982c31b4f1f96e45c51293ff622b8e0947b9fee'
where s.start::date > (select date_trunc('day', NOW() - interval '1 month'))
group by s.application_id,a.name,s.extension_id,s.start::date
order by s.application_id,s.start::date;

-- - Total time per app per day, over time (last month)
select a.id,a.name,a.url,a.extension_id,b.start::date as date,
SUM(b.duration) as total_time
from application a
left join session b on b.extension_id = a.extension_id and b.application_id = a.id
where a.extension_id = '31bc99ffd36ddfcb5d350982c31b4f1f96e45c51293ff622b8e0947b9fee'
and b.start::date > (select date_trunc('day', NOW() - interval '1 month'))
group by a.id,a.name,a.url,a.extension_id,b.start::date
order by a.name,b.start::date;


-- With parameters from user:

-- - Window over 24 hrs per app
select b.id,b.start,b.stop,b.duration
from application a
join session b on b.extension_id = a.extension_id and b.application_id = a.id
where a.extension_id = '31bc99ffd36ddfcb5d350982c31b4f1f96e45c51293ff622b8e0947b9fee'
and a.id = 'ecce86e4-35f6-11e7-80ad-f396424a9a3d'
and b.start::date = '2017-05-17' --user chooses date param
order by b.start;



