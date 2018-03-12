# rename_params

[![Build Status](https://travis-ci.org/cedarcode/rename_params.svg?branch=master)](https://travis-ci.org/cedarcode/rename_params)
[![Code Climate](https://codeclimate.com/github/cedarcode/rename_params/badges/gpa.svg)](https://codeclimate.com/github/cedarcode/rename_params)
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
as you need. Normally you will want to put the `rename` declarations at the top of the file, before
any `before_action` in your controller.

```ruby
class UsersController < ApplicationController
  rename :username, to: :login, namespace: :user, only: :create
  rename :age, to: :year_of_birth, convert: -> (value) { Date.today.year - value }, only: :index
end
```

You can think of the transformations as if they were ran in sequence in the same order
they were defined. So keep this in mind if one transformation depends on a previous one.

## Moving params

There will be some cases where you will need to move a param from one namespace to another. For those
cases, you can use the `move` macro.

```ruby
class UsersController < ApplicationController
  # Moves params[:username] to params[:user][:username]
  move :username, to: [:user], only: :create

  def create
    #...
  end
end
```

In this case, the params were sent like this:
```
> puts params
{ username: 'aperson' }
```

And they were transformed to:
```
> puts params
{
  user: {
    username: 'aperson'
  }
}
```

You can specify deeper nesting using the array notation. Example:
```ruby
class UsersController < ApplicationController
  # Moves params[:street] to params[:contact][:address][:street]
  move :street, to: [:contact, :address]
end
```

This will be renamed to:
```
> puts params
{
  contact: {
    address: {
      street: '123 St.'
    }
  }
}
```

### Using a namespace with move
The `move` option also accepts a `namespace` just like `rename`. If you want to move something that is not at the root
level, you can always specify the path to it using a namespace.

Let's say you have a UsersController


```ruby
class UsersController < ApplicationController
  # Moves params[:user][:address][:street] to params[:user][:street]
  move :street, namespace: [:user, :address], to: :user
end
```

This will be renamed from this:
```
> puts params
{
  user: {
    address: {
      street: '123 St.'
    }
  }
}
```
To this:
```
> puts params
{
  user: {
    street: '123 St.'
  }
}
```

### The root option

If you need to move a param to the root level, you can do that by using the `:root` keyword:

```ruby
class UsersController < ApplicationController
  # Moves params[:user][:login] to params[:login]
  move :login, namespace: :user, to: :root
end
```

Doing a request like the following:
```
GET `/users?user[login]=aperson`
```

Will rename the params to:
```
> puts params
{ login: 'aperson' }
```

### Combining move and rename

If you want to rename something and move it to a different namespace, you can do that by either first calling `rename`
and then `move` in the line below, or you can use the `move_to` option within the same `rename` clause.

```ruby
class UsersController < ApplicationController
  # Renames params[:username] to params[:user][:login]
  rename :username, to: :login, move_to: :user, only: :create

  def create
    #...
  end
end
```

In this case, the params were sent like
```
> puts params
{ username: 'aperson' }
```

But they were transformed to:
```
> puts params
{
  user: {
    login: 'aperson'
  }
}
```

This is the same than doing:
```ruby
class UsersController < ApplicationController
  # Renames params[:username] to params[:user][:login]
  rename :username, to: :login, only: :create
  move :login, to: :user, only: :create

  def create
    #...
  end
end
```


## Contributing

1. Fork it ( https://github.com/cedarcode/rename_params/ )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

See the [Running Tests](RUNNING_TESTS.md) guide for details on how to run the test suite.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
