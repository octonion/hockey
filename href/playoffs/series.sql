
select distinct home_id,visitor_id
from href.playoffs
where year=2015
and home_id<visitor_id;
