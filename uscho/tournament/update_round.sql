begin;

insert into uscho.rounds
(year,round_id,school_id,school_name,bracket,p)
(
select
r1.year as year,
r1.round_id+1 as round,
r1.school_id,
r1.school_name,
r1.bracket,
coalesce(
sum(
r1.p*r2.p*
coalesce(
sf1.strength^2/
(sf1.strength^2+sf2.strength^2),1.0)
),1.0) as p

from uscho.rounds r1
left join uscho.rounds r2
  on ((r1.year,r1.round_id,r1.bracket[r1.round_id+1])=
      (r2.year,r2.round_id,r2.bracket[r1.round_id+1])
       and not(r1.bracket[r1.round_id]=r2.bracket[r1.round_id]))
join uscho._schedule_factors sf1
  on (sf1.year,sf1.school_id)=(r1.year,r1.school_id)
left join uscho._schedule_factors sf2
  on (sf2.year,sf2.school_id)=(r2.year,r2.school_id)
where
    r1.year=2025
and r1.round_id=1
group by r1.year,round,r1.school_id,r1.school_name,r1.bracket
);

commit;
