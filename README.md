Whatsdis?
=========

Use [dstat](https://github.com/dagwieers/dstat) and Ruby stuff to make pwetty pics of how much internets there is and how much CPU and centigrades it costs.

Howcaniuse?
===========

Requirements are the abovementioned `dstat` tool (note that for temperature readout to work on PC Engine's APU2, my [add-feature-lm_sensors-to-dstat_thermal-plugin branch of dstat](https://github.com/sixtyfive/dstat/tree/add-feature-lm_sensors-to-dstat_thermal-plugin) is needed as the PR has not yet been merged by the author and I don't know if it ever will be). Also Ruby 2.2+, Rubygems, and bundler. Run `bundle install` to get the required gems. Then run `./watchsys`. After a minute, every minute, it will create a `recent.png` file, after 10 minutes, every 10 minutes, a `today.png` file. I download these two every minute from a digital picture frame, do whatever you want.
