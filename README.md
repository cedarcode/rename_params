# RenameParams

[![Build Status](https://travis-ci.org/marceloeloelo/rename_params.svg?branch=master)](https://travis-ci.org/marceloeloelo/rename_params)
[![Code Climate](https://codeclimate.com/github/marceloeloelo/rename_params/badges/gpa.svg)](https://codeclimate.com/github/marceloeloelo/rename_params)
[![Gem Version](https://badge.fury.io/rb/rename_params.svg)](https://badge.fury.io/rb/rename_params)

Simple params renaming for Rails applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rename_params'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rename_params

## Usage

Specify the input params that you would like to rename in your controller:


```ruby
class UsersController < ApplicationController
  # This will rename "username" to "login" in the params
  rename :username, to: :login, only: :index
  
  def index
    @users = User.where(query_params)
  end
  
  private
  
  def query_params
    params.permit(:login, :age)
  end
end
```

This means that for a request like the following:
```
GET /users?username=aperson&age=28
```

The `params` method will now have a key called `login` instead of `username` within the context of the `index` action:

```
> puts params
{ login: 'aperson', age: '28' }
```

## Nested params

If you need to rename a parameter which is nested into a certain key, you can use the
`namespace` option. Just specify the nesting using an array format.


```ruby
class UsersController < ApplicationController
  # Renames params[:user][:username] to params[:user][:login]
  rename :username, to: :login, namespace: :user, only: :create

  def create
    @user = User.new(user_params)
    respond_to do |format|
      format.html { redirect_to(@user, notice: 'User was successfully created.') }
    end
  end

  private

  def user_params
    params.require(:user).permit(:login)
  end
end
```

If the parameter you need to change is nested under more than one namespace, you can use the array
syntax like this:

```ruby
class UsersController < ApplicationController
  # Renames params[:session][:credentials][:username] to params[:session][:credentials][:login]
  rename :username, to: :login, namespace: [:session, :credentials]
end
```

## Converting values

There are cases where just renaming the parameter key won't be enough and you will want to also
transform the values that were sent. The `convert` option will give you some more flexibility as to
what to do with those values.

### Enum converter

If the request will only take a finite number of values you can use an Enum converter to define the
conversion rules. This will be just a mapper in the form of a hash.


```ruby
class TicketsController < ApplicationController
  # Converts params[:status] value from "open"/"in_progress"/"closed" to 0/1/2
  rename :status, to: :status, convert: { open: 0, in_progress: 1, closed: 2 }
end
```

The example above will convert the `status` parameter from `open`/`in_progress`/`closed` to `0`/`1`/`2`:
```
# If params came with { status: 'in_progress' }, then after the transformation:
> puts params
{ status: 1 }
```

### Proc converter

You can also use a `Proc` or a private method to convert the value to whatever makes sense by executing ruby code.

```ruby
class UsersController < ApplicationController
  # Converts params[:age] value into year_of_birth
  rename :age, to: :year_of_birth, convert: -> (value) { Date.today.year - value }
end
```

Assuming `Time.current` is in 2016, this will result in the following conversion:
```
# If params came with { age: 28 }, then after the transformation:
> puts params
{ year_of_birth: 1988 }
```

If you want to use private method instead of a proc, you can just declare it like this:

```ruby
class UsersController < ApplicationController
  rename :age, to: :year_of_birth, convert: :to_year

  private

  def to_year(value)
    Date.today.year - value
  end
end
````

## Multiple renaming

If you need to rename more than one parameter, just specify as many `rename` declarations
as you need.

```ruby
class UsersController < ApplicationController
  rename :username, to: :login, namespace: :user, only: :create
  rename :age, to: :year_of_birth, convert: -> (value) { Date.today.year - value }, only: :index
end
```

You can think of the transformations as if they were ran in sequence in the same order
they were defined. So keep this in mind if one transformation depends on a previous one.

## Contributing

1. Fork it ( https://github.com/marceloeloelo/rename_params/ )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

See the [Running Tests](RUNNING_TESTS.md) guide for details on how to run the test suite.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details