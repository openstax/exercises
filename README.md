<!-- Copyright 2011-2019 Rice University. Licensed under the Affero General Public
     License version 3 or later.  See the COPYRIGHT file for details. -->

OpenStax Exercises
==================

[![Tests](https://github.com/openstax/exercises/workflows/Tests/badge.svg)](https://github.com/openstax/exercises/actions?query=workflow:Tests)
[![Migrations](https://github.com/openstax/exercises/workflows/Migrations/badge.svg)](https://github.com/openstax/exercises/actions?query=workflow:Migrations)
[![Coverage](https://img.shields.io/codecov/c/github/openstax/exercises.svg)](https://codecov.io/gh/openstax/exercises)

OpenStax Exercises is an open homework and test question bank, where questions are written
by the community and access is free. Successor to Quadbase.

Requirements
------------

To run Exercises, you must have the following dependencies installed:

* Ruby 2.6.1

License
-------

See the COPYRIGHT and LICENSING files.

Contributing
------------

Contributions to Exercises are definitely welcome.

Note that like a bunch of other organizations (Apache, Sun, etc), we require contributors
to sign and submit a Contributor Agreement. The Rice University Contributor Agreement
(RCA) gives Rice and you, the contributor, joint copyright interests in the code or
other contribution. The contributor retains copyrights while also granting those
rights to Rice as the project sponsor.

The RCA can be submitted for acceptance by emailing a scanned, completed, signed copy
to info@[the openstax domain]. Only scans of physically signed documents will be accepted. No electronically generated 'signatures' will be accepted.

Here's how to contribute to Exercises:

1. Send us a completed Rice Contributor Agreement:
   * Download [the form](http://quadbase.org/rice_university_contributor_agreement_v1.pdf)
   * Complete it ("Project Name" is "OpenStax Exercises" and "Username" is your GitHub username)
   * Sign it, scan it, and email it to info@[the openstax domain]
2. Fork the code from [our repository](https://github.com/openstax/exercises) on GitHub.
3. Create a thoughtfully named topic branch to contain your change
4. Make your changes
5. Add tests and make sure everything passes
6. If necessary, rebase your commits into logical chunks, without errors
7. Push the branch up to GitHub
8. Send a pull request for your branch

Development Quick Start
-----------------------

### Use Docker

```bash
$> docker-compose up
```

Or use `docker-compose up -d` for a daemonized run.

Drop into a bash shell with

```bash
$> docker-compose run api bash
```

To run tests, make sure the test database is ready:

```bash
$> docker-compose run api bundle exec rake db:test:prepare
```

Then

```bash
$> docker-compose run api bundle exec rspec
```

### Install everything yourself

1. Install a ruby version manager on your machine, such as rbenv or rvm
2. Install ruby 2.6.1
3. Run the following shell commands from the OpenStax Exercises folder:

```sh
$ bundle --without production
$ createuser --superuser ox_exercises
$ rails db:setup
$ rails s
```

If any of the above commands fail, try prepending `bundle exec`, e.g. `bundle exec rails db:setup`

You should then be able to point a web browser to http://localhost:3000 and access OpenStax Exercises.
