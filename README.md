# ActiveBeans - Distributed Task Queue for Ruby applications

ActiveBeans is intended for easy distribute high load tasks between workers runned in different processes.
No need to write special workers, workers is just your application with unchanged database models.
Waiting for results from workers performed asynchronously by using `EventMachine` framework.

Quick Start
-----------

In Gemfile:

	gem 'active_beans'

Add config `active_beans.yml` in config directory:

	development:
		server: "localhost:11300"
	  
	production:
		server: "localhost:11300"

In your model:

	class User < ActiveRecord::Base
	  def statistics
	    # .. do some dirty job
	  end
	end

In controller:

	class UsersController < ApplicationController
	  def show
	    @user = User.find(params[:id])
	    @statistics = @user.async_statistics
	  end
	end

Run beanstalkd queue:

	beanstalkd &

Run worker intance:

	cd application_dir; active_beans_worker

Run your application:

	cd application_dir; rails s

And now, when you open page with action `show`, method `@user.async_statistics` performed by worker.
Variable `@statistics` is a proxy object, and inside your views will represent actual result from worker.
Of course your views rendered only after all results will be obtained.
This means using `actibe_beans` by calling one async method is not very efficient, even more, it will be
slower that just calling direct method `@statistics = @user.statistics`.
`ActiveBeans` must bring perfomance by calling two or more async requests, just imagine this action:

	class UsersController < ApplicationController
	  def show
	    @user = User.find(params[:id])
	    @statistics = @user.async_statistics
	    @user_wsdl_data = @user.async_data_from_remote_xml_service
	    @user_additional_data = @user.async_data_from_second_database
	  end
	end

Results from methods `@user.async_statistics` `@user.async_data_from_remote_xml_service` and
`@user.async_data_from_second_database` will performed asynchronously and possible you will render page in
three times faster. Remember you can start any number of `active_beans_worker` instances, each worker works synchronously, so you need three workers for this.

TODO
----

* Now it works only with Rails 3.1.3 need to make tests with other versions
* `ActiveRecord` only so far
* Add other web frameworks like Sinatra, Ramaze etc.
* `beanstalkd` queue only, need to investigate other queue frameworks

Problems
--------

* Due to using `EventMachine` framework it doesn't work with webservers based on `EventMachine` like Thin for example
* Need to get exact conditions when to use async methods and when not to use
