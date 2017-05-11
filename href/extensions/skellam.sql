
create extension if not exists plpython3u;

drop function if exists skellam(float, float, text);

create or replace function skellam
  (mu1 float, mu2 float, outcome text, OUT p float)
returns float
as $$

from scipy.stats import skellam

if (outcome=="reg_draw"):
   p = skellam.pmf(0, mu1, mu2)
elif (outcome == "reg_lose"):
   p = skellam.cdf(-1, mu1, mu2)
elif (outcome == "reg_win"):
   p = skellam.cdf(-1, mu2, mu1)
elif (outcome=="ot_lose"):
   p = skellam.pmf(0, mu1, mu2)*mu2/(mu1+mu2)
elif (outcome=="ot_win"):
   p = skellam.pmf(0, mu1, mu2)*mu1/(mu1+mu2)
elif (outcome=="lose"):
   p = skellam.cdf(-1, mu1, mu2)+skellam.pmf(0, mu1, mu2)*mu2/(mu1+mu2)
else: # win
   p = skellam.cdf(-1, mu2, mu1)+skellam.pmf(0, mu1, mu2)*mu1/(mu1+mu2)
   
return(p)

$$ language plpython3u;
