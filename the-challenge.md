# Ceros DevSecOps Code Challenge

Summary: Take our infrastructure, secure it, and refactor it.

## The Task

Contained with in is an AWS infrastructure that runs the Ceros Ski game's code.

Your first task is to secure that infrastructure.  There are a number of
security issues in it.  Please fix them.  Once you've secured the
infrastructure, take some time to pull out any Terraform modules that you think
it would make sense to abstract.

Please document your code and your choices.  If you make any techdebt decisions
in the interest of time, please ensure they are also well documented.  Update
the provided usage documention and architecture documentation to account for
any changes you make.

You will be graded on the cleanliness of your code, the quality of your
documentation, and your architectural choices.

The challenge is structured to take a few hours of work.  But it's not timed,
and you can take as much time with it as you want to.

You should be able to complete it sticking to the AWS free tier - and please do
so, because we won't compensate you for any charges incurred.

Note: You can ignore the code in the `/app` directory other than the Dockerfile
and any work necessary to get it deployed.  That's the challenge we give to
prospective full stack devs - it has some bugs and missing features, including
a crash that can happen right off the bat.  You don't need to worry about
fixing those.

## Acceptance Criteria

You can consider the challenge "done" when each of these has been achieved.

- The infrastructure is functional: the ceros-ski game can be loaded successfully in the browser.
- The infrastructure is secure: any security issues have been fixed.
- Any logical modules have been refactored out.

## Grading

You will be graded on the following criteria.

- How readable, organized, and documented your code is
- What has been pulled out into terraform modules, and how well structured those modules are
- How well security concerns have been handled
- The quality, detail, and clarity of your usage and architecture documentation
- How well documented and reasonable tech debt decisions are
