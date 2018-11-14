## Code of Conduct

This project and everyone participating in it is governed by the [Firespring Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [support@firespring.com](mailto:support@firespring.com).

## How to contribute

#### **Did you find a bug?**

* **Ensure the bug was not already reported** by searching on GitHub under [Issues](https://github.com/firespring/manifestly-ruby/issues).

* If you're unable to find an open issue addressing the problem, [open a new one](https://github.com/firespring/manifestly-ruby/issues/new). Be sure to include a **title and clear description**, as much relevant information as possible, and a **code sample** or an **executable test case** demonstrating the expected behavior that is not occurring.

#### **Did you write a patch that fixes a bug?**

Pull requests are always appreciated.

To get started contributing, fork and clone the repo:

```
git clone git@github.com:your-username/manifestly-ruby.git
```

Install development Gems:

```
bundle install
```

Make your code changes.

Make sure that your changes do not break any existing tests:

```
rspec spec/unit
```

Pull requests **will not be accepted** for any additional functionality without adding accompanying tests. Moreover, the repository contains a configuration for [Rubocop](https://github.com/bbatsov/rubocop). Pull requests will also not be accepted that do not pass the rubocop style-check. To check this simply run:

```
rubocop
```

Open a new GitHub pull request for the patch.

Ensure the PR description clearly describes the problem and solution. Include the relevant issue number if applicable.
