# Running Tests

This project uses [rspec-rails](https://github.com/rspec/rspec-rails) for testing and [appraisal](https://github.com/thoughtbot/appraisal) for managing multiple rails versions.

## Testing against different rails versions

For running the specs for all the rails supported versions, you can run:

```
appraisal rspec
```

If you want to run the test suite for a singe rails version you can run:

```
appraisal <rails-version> rspec
```

So running `appraisal rails-4-2 rspec` will run the test suite with rails 4.2 installed.

## Testing with latest rails version

Additionally, if you want to run the specs using the version installed from the gemspec, you can just run:

```
rspec
```
