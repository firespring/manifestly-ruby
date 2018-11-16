# Manifest.ly Ruby Client
[![Gem Version](https://badge.fury.io/rb/manifestly-client.svg)](https://badge.fury.io/rb/manifestly-client)
[![Build Status](https://api.travis-ci.org/firespring/manifestly-ruby.svg?branch=master)](https://travis-ci.org/firespring/manifestly-ruby)

A Ruby client that enables quick and easy interactions with the Manifest.ly api.

## Getting Started

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'manifestly-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install manifestly-client

### Basic Usage

You may begin using the entity methods after specifying the MANIFESTLY_API_KEY variable in the environment.
```ruby
require 'manifestly'

ENV['MANIFESTLY_API_KEY'] = '<secret>'
puts Manifestly::Entity::Workflow.list.inspect
```

### Workflow entity

You may create a new workflow by passing a hash of data to the Workflow constructor and invoking the `create` method. Some internal fields (like `id`) will be injected back in to the object after it is created.
```ruby
data = {title: 'Test Workflow', external_id: 'abc123'}
workflow = Manifestly::Entity::Workflow.new(data).create
workflow.create
```

If you specify an `external_id` for a local reference, Manifest.ly will use an `upsert` methodology (if the workflow does not exist it will be created - otherwise it will be updated). This effectively means that create/update/save function identically for workflows.
```ruby
data = {title: 'Test Workflow Upsert', external_id: 'def456'}
workflow = Manifestly::Entity::Workflow.new(data).create

workflow.title = "#{workflow.title} (updated)"
workflow.create
```

You may delete a workflow if you specified an external_id when creating it.
```ruby
data = {title: 'Test Workflow Delete', external_id: 'ghi789'}
workflow = Manifestly::Entity::Workflow.new(data).create
workflow.delete
```

##### Workflow Steps entity

Steps may be passed in when creating a workflow via the steps field.
```ruby
data = {title: 'Test Workflow with steps', external_id: 'jkl012', steps: [{title: 'Step One'}]}
workflow = Manifestly::Entity::Workflow.new(data)
workflow.create
```

### Checklist Run entity

You may start a new checklist run by passing a hash of data to the ChecklistRun constructor and invoking the `create` method. You must include the internal id of an existing workflow as the checklist_id. Subsequent modifications of this checklist run or it's steps is only possible if you are listed as one of the users on the run.
```ruby
my_email_address = 'john.smith@foo.bar'
my_user = Manifestly::Entity::User.list.find { |it| it.email == my_email_address }

data = {title: 'Test Workflow for checklist run', external_id: 'mno345', steps: [{title: 'Step One'}]}
workflow = Manifestly::Entity::Workflow.new(data).create

data = {title: 'Test Run', checklist_id: workflow.id, users: [my_user.id]}
checklist_run = Manifestly::Entity::ChecklistRun.new(data).create
```

You may complete a checklist step by calling the corresponding method on the step object. Currently you must either be a participant on the run or assigned to the step in order to complete it.
```ruby
my_email_address = 'john.smith@foo.bar'
my_user = Manifestly::Entity::User.list.find { |it| it.email == my_email_address }

data = {title: 'Test Workflow for checklist run step complete', external_id: 'pqr678', steps: [{title: 'Step One'}]}
workflow = Manifestly::Entity::Workflow.new(data).create

data = {title: 'Test Run step complete', checklist_id: workflow.id, users: [my_user.id]}
checklist_run = Manifestly::Entity::ChecklistRun.new(data).create

checklist_run.steps.first.assign(my_user.id)
checklist_run.steps.first.complete
```

## Supported Ruby Versions

This library is currently supported on Ruby 2.4+.

## Versioning

This library follows [Semantic Versioning](http://semver.org/).

## Contributing

Contributions to this library are always welcome and highly encouraged.

See [Contributing](CONTRIBUTING.md) for more information on how to get started.

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by its terms. See [Code of Conduct](CODE_OF_CONDUCT.md) for more information.

## License

This library is licensed under Apache 2.0. Full license text is
available in [LICENSE](LICENSE.txt).

## Support

Please [report bugs at the project on Github](https://github.com/firespring/manifestly-ruby/issues)

See [Contributing](CONTRIBUTING.md) for more information on how to get started.
