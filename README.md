# Ruby on Rails Tutorial sample application
This is the sample application for
[*Ruby on Rails Tutorial:
Learn Web Development with Rails*](https://www.railstutorial.org/)
(6th Edition)
by [Michael Hartl](https://www.michaelhartl.com/).

## License
All source code in the [Ruby on Rails Tutorial](https://www.railstutorial.org/)
is available jointly under the MIT License and the Beerware License. See
[LICENSE.md](LICENSE.md) for details.

## Prerequisite
* Ruby 2.7.1
* NodeJS
* Yarn

## Getting started
To get started with the app, clone the repo and then install the needed gems:
```
$ bundle install --without production
```
Next, migrate the database:
```
$ rails db:migrate
```
Finally, run the test suite to verify that everything is working correctly:
```
$ rails test
```
If the test suite passes, you'll be ready to run the app in a local server:
```
$ rails server
```
## Note: 
If you can't start the server, and the error is
```
Your Yarn packages are out of date!
Please run `yarn install --check-files` to update.
```
Just run
```
yarn install --check-files
```
or
```
yarn --update-checksums
```
and start the local server again.