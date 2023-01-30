-- CREATE [ OR REPLACE ] RESOURCE MONITOR <name> WITH
--         [ CREDIT_QUOTA = <number> ]
--         [ FREQUENCY = { MONTHLY | DAILY | WEEKLY | YEARLY | NEVER } ]
--         [ START_TIMESTAMP = { <timestamp> | IMMEDIATELY } ]
--         [ END_TIMESTAMP = <timestamp> ]
--         [ TRIGGERS triggerDefinition [ triggerDefinition ... ] ]

USE ROLE ACCOUNTADMIN;
CREATE RESOURCE MONITOR accout_monthly_monitor WITH
    CREDIT_QUOTA = 1
    FREQUENCY = MONTHLY
    START_TIMESTAMP = IMMEDIATELY
    TRIGGERS 
        ON 100 PERCENT DO SUSPEND_IMMEDIATE
        ON 99  PERCENT DO SUSPEND
        ON 90  PERCENT DO NOTIFY
        ON 80  PERCENT DO NOTIFY
        ON 50  PERCENT DO NOTIFY;