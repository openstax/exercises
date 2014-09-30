<!-- Copyright 2011-2014 Rice University. Licensed under the Affero General Public 
     License version 3 or later.  See the COPYRIGHT file for details. -->

OpenStax Exercises
==================

[![Build Status](https://travis-ci.org/openstax/exercises.svg?branch=master)](https://travis-ci.org/openstax/exercises)
[![Code Climate](https://codeclimate.com/github/openstax/exercises.png)](https://codeclimate.com/github/openstax/exercises)
[![Coverage Status](https://img.shields.io/coveralls/openstax/exercises.svg)](https://coveralls.io/r/openstax/exercises)

OpenStax Exercises is an open homework and test question bank, where questions are written 
by the community and access is free. Successor to Quadbase.

Check it out at ~~http://quadbase.org~~.

Requirements
------------

To run Exercises, you must have the following dependencies installed:

* Ruby 2.1.3

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

### Use swerve

We provide a virtual environment that you can use for development. It has everything you need to get going.

See [OpenStax Swerve](http://github.com/openstax/swerve) for more information.

### Install everything yourself

1. Install a ruby version manager on your machine, such as rbenv or rvm
2. Install ruby 2.1.3
3. Run the following shell commands from the OpenStax Exercises folder:
   ```sh
     bundle --without production
     rake db:migrate
     rails g secrets
     rails s
   ```
   If any of the commands fail, try prepending `bundle exec`, e.g. `bundle exec rake db:migrate`

That's it! You should then be able to point a web browser to http://localhost:3000.
