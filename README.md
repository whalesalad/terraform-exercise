# ReactiveOps Coding Challenge

#### 1. Environment

A few environment variables are required prior to running the setup script:

    export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    export AWS_DEFAULT_REGION="ap-northeast-1"

#### 2. Terraform

Terraform was used to configure AWS and deploy the EC2 instance. You'll need Terraform in order to proceed.

If you're on OS X and use [Homebrew](http://brew.sh/) it's as easy as:

    brew install terraform

Else, you can download a precompiled binary for your platform [from the Terraform website](https://www.terraform.io/downloads.html).

#### 3. Do It

Once your environment is setup, the rest is as simple as running

    terraform apply

As part of the process, the public IP address of the created EC2 instance will be returned in output resembling the following:

```
Outputs:

elb_dns_name = 54.238.206.140
```

The IP address can be copied into a web browser where a Django web application is running on port 80.

**NOTE: Due to the fetching of the Docker container, it can take a minute or so for the web app to be available.**

#### 4. Clean Up

If you'd like to destroy all the infrastructure created for this exercise (the VPC, instances, etc...) it's as easy as

    terraform destroy


### The Web Application

The web appliation is a very basic "It Worked!" style page, but it is not the default Apache/Nginx page. It's a (very lightly) scaffolded Django application running inside of a Docker container.

The source of this can be found at [github.com/whalesalad/django-docker-poc](https://github.com/whalesalad/django-docker-poc), which I created specifically for this exercise.


### Original Instructions

Using any language you prefer, write code that brings up an EC2 instance running the default page of a web application after running one line on the command line.

The one liner can (and likely will) call a longer shell script, or other configuration management code. AWS credentials for a dedicated region will be provided for you separately. By web application, feel free to choose among Django, Rails, Symfony, etc., but not the default Nginx or Apache setup.

If needed, you can manually create pre-requisites such as ssh key pairs and the like. The idea is that before you hit enter, there are no compute instances running and after, you supply an IP address, and at that address is a working web application. You're free to respond with a link to a git repo, or via email attachment.

Please don't take more than 3 hours, and questions and clarifications are entirely welcome.

Your credentials are attached as well, including the assigned region.
