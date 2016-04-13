
select distinct home_id,visitor_id
from href.playoffs
where year=2016
and home_id<visitor_id;
