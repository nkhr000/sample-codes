CREATE OR REPLACE FUNCTION sleep (t float8) RETURNS bool IMMUTABLE  AS $$ 
from time import sleep
    sleep(t)
return True

$$ LANGUAGE plpythonu;