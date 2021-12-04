# get-help
A script to make your computer cry for help when it gets low on resources

WARNING: not done yet

# todo
- make a service script to automatically run this every so often
  - should have /etc/config for that when its done
- get way to write to fd of other processes; not sure how to do that properly

# prerequisites
This is meant to run on linux systems. There are probably other prerequisites which I will
mark here once I figure out how much is system-specific.

# what is this
It makes your computer yell at you when you push it too hard. It checks memory, cpu, and disk usage,
and if any of them are too high it will yell at you. If all of them are too high it will yell at
you louder.

## what does 'yell at you' mean
It means `wall` to show all terminals how upset it is, and it also means that it will print to some
random `stdout` and `stderr` streams if I can figure out how to do that. Yelling more loudly means
that it will yell in all caps and it will also print to more streams.

## doesn't yelling take up even more system resources
yes