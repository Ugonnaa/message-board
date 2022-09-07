# Message Board App

## Requirements

### Functional Requirements
- Create a single-page application (SPA)
- It should allow users who visit the page to post a message to a global board
- Anybody should be able to see the messages posted on the board (there need not 
  be any authentication system)
- Messages should show a name (provided when posting a message by the user), 
  the date it was posted, and the message itself
- Messages should be displayed by most-recent first
  - Stretch: Implement 'infinite scrolling' where the first 10 load initially, and when the user
    scrolls to the bottom, more load until there are none left, as is common on most social apps
    these days

### Technical Specification

- The App should be built using NextJS
- The App should be hosted on Compute Engine, by running NextJS in a Virtual Machine (VM)
- The App should be packaged onto a Machine Image using Packer
- Infrastructure should be managed using Terraform
- The App should scale with demand - try using scaling groups!
- You should build this in _your_ sandbox!

Basic architecture: 
User -> Load Balancer -> VM -> Firestore

This Google guide for HTTP Regional Load Balancing basically sums up the whole architecture https://cloud.google.com/load-balancing/docs/https/setting-up-reg-ext-https-lb. It doesn't discuss using Firestore as a database though. (They even have some Terraform snippets!)

Don't worry too much about HTTPS - HTTP is fine. Also don't worry about DNS, just connecting to the load balancer via IP is fine.

#### Important Notes

- You cannot assign public IPs to VMs in our organisation 
    - this means you'll have to 
        configure OSLogin and IAP to build your images - I've set up the packer file for you, 
        but you'll have to [make sure your VPC is set up for it](https://cloud.google.com/iap/docs/using-tcp-forwarding) (take special notice of the TCP firewall rule!)
    - you'll also have to [use a load balancer](https://cloud.google.com/compute/docs/load-balancing-and-autoscaling) to direct web-traffic at your instances

## Guidance

Remember to break down your problems into individual tasks.

For example, in order to post a message, think about each step in the process
- How do I create the graphical interface to allow the user to post their message?
- How do I take that information and pass it to the API?
- How do I put that information in the database?
- How can I display that message to the user?

When things aren't working - consider permissions!
- How can I allow my VM to communicate with Firestore?
- Every deployed VM has the permissions of it's associated service account,
  what permissions does it have?  (Hint: take a look in IAM and look for a 
  service account with Firebase Admin permissions, that'll be permitted to 
  communicate with firestore!)

Don't try and dive straight in and write some Terraform, figure out what infrastructure you need first - you can make it all in the Cloud Console first and codify it later!

## Repository Structure

I recommend you fork this repository and commit your changes to your own copy.

You'll notice a few folders in this repository:

`/packer` - this contains anything related to Packer, which is a tool which will help you make VM images.
  It's made by the same people as Terraform, and uses the same markup language. I've created a bit of a starting point for you
  since you've not used it before and it was a bit tricky to configure. You'll have to come up with the build 
  script yourself, which I've left hints for in the `provision.sh` file.

`/terraform` - here you should create your terraform modules and deployments:

`/terraform/modules/vpc` - here you should put your "permenant" infrastructure, for example, a VPC and subnets in which your machine should live.

You'll need to create a VPC before starting with the Packer stuff, since it starts up a VM and 'saves' it, and it needs somewhere to do that. **Start here!**

`/terraform/modules/app` - here you should put your more "destructable" infrastructure, for example, VM, load balancer

This setup will allow you to easily redeploy VMs when you're having trouble, without
having to delete and redeploy a whole VPC! You can also find 
[example modules in our `terraform-stacks` repository](https://github.com/sainsburys-tech/gcp-terraform-modules-stacks/tree/main/terraform).

`/terraform/deployment` - here you should "consume" your modules, by providing the required variables for that module declared in each module's `variables.tf` files, here is where you should run your `terraform apply`s!

`/app` - Your NextJS app

### Notes

You'll have to make sure you've got the right Terraform version installed, you can see that version in `./terraform/modules/vpc/versions.tf`

## Reference material

- [Packer](https://www.packer.io/docs)
- [Packer CLI commands](https://www.packer.io/docs/commands)
- [Terraform CLI commands](https://www.terraform.io/cli/commands)
- [Creating Terraform modules](https://www.terraform.io/language/modules/develop)
- [Consuming Terraform modules](https://www.terraform.io/language/modules/syntax)
- [Transfering files to machines with packer](https://www.packer.io/docs/provisioners/file)
- [Provisioning machines with shell scripts with packer](https://www.packer.io/docs/provisioners/shell)
- [Create next app](https://nextjs.org/docs/api-reference/create-next-app)
- [Deploying NextJS, self-hosting](https://nextjs.org/docs/deployment#nodejs-server)
- [Interact with Firebase from a server](https://cloud.google.com/firestore/docs/create-database-server-client-library)

Good luck! Trial and error is your friend.