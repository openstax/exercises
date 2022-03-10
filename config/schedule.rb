# Server time is UTC
# Times below are interpreted that way

every(1.minute)          { rake 'cron:minute' }
every(1.day, at: '8 AM') { rake 'cron:day'    }  # Midnight-1AM Pacific/2-3AM Central/3-4AM Eastern
