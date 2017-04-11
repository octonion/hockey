
select distinct home_id,visitor_id
from href.playoffs
where year=2017
and home_id<visitor_id;
